# 14 - UEFI 進階

本章深入 UEFI 韌體與 Linux 開機的完整鏈：ESP 與 NVRAM 開機項、shim → GRUB / systemd-boot → 核心、Secure Boot 信任鏈與 MOK、BLS 與 UKI、TPM 量測開機、韌體更新，以及 UEFI 特有的故障排除。套件、路徑與工具版本皆於 Ubuntu 24.04 / Fedora 44 實驗機查證；涉及實體韌體（NVRAM、Secure Boot 狀態）的操作在容器中無法執行，指令以官方文件為準並標示。

**本章解決什麼問題**：開機是整個系統唯一「還沒有任何安全機制在跑」的階段——核心尚未載入、SELinux / AppArmor 還不存在、磁碟可能還是加密的。攻擊者只要能改掉這段的任何一個檔案（bootloader、initramfs、核心參數），就能在所有防護啟動前取得控制權，這正是 bootkit 與 evil maid 攻擊的原理。UEFI 的每個機制（Secure Boot、shim / MOK、dbx / SBAT、UKI、TPM 量測）都是對某一次真實攻擊或缺陷的回應，不理解它們在防什麼，就會在「NVIDIA 模組載不進來」「韌體更新後 LUKS 解不開」「重灌後開不了機」時只能盲目關掉 Secure Boot。本章的取捨是：先講每個機制為何存在、它防的是哪種攻擊，再給兩個發行版實測過的操作與差異。

---

## 1. UEFI 與 BIOS 的差異

**為什麼**：BIOS 是 1981 年 IBM PC 的設計：16-bit 實模式、靠中斷呼叫、開機程式塞在 MBR 的 440 bytes 裡，MBR 分割表也把磁碟限制在 2 TB；更關鍵的是它完全不驗證開機程式，2011 年前後的 Mebromi、TDL4 這類 bootkit 就是改寫 MBR 在 OS 前搶先執行。Intel 在 2000 年代為 Itanium 設計 EFI，2005 年交給 UEFI Forum 成為業界標準，把開機程式變成檔案系統裡的 `.efi` 檔、開機項存進 NVRAM，並加上簽章驗證（Secure Boot）與 TPM 量測的介面。CSM 相容模式只是過渡：它讓舊系統能開，但也讓所有 UEFI 安全機制失效，所以新硬體多已移除。

UEFI 與 BIOS 的差異不在發行版而在韌體，兩者在 Ubuntu / Fedora 上行為一致：

| | Legacy BIOS | UEFI |
|---|---|---|
| 分割表 | MBR（≤ 2 TB、4 個主分割） | GPT（無實務上限、128 個分割） |
| 開機程式位置 | MBR 前 440 bytes + 分割區間隙（GRUB `core.img`） | **ESP**（EFI System Partition，FAT32）內的 `.efi` 檔 |
| 開機項 | 由 BIOS 依磁碟順序找 MBR | 韌體 **NVRAM** 中的 `Boot####` 變數，指向「磁碟 + ESP 內的路徑」 |
| 驅動 / 執行環境 | 16-bit 實模式、中斷呼叫 | 32/64-bit、C 介面、內建網路 / 檔案系統驅動、可執行 EFI 應用程式（shell、記憶體測試、韌體更新） |
| 安全 | 無 | **Secure Boot**（簽章驗證）、TPM 量測、韌體密碼 |
| 多系統 | 互相覆蓋 MBR | 各 OS 在 ESP 有自己目錄，共存容易 |
| 韌體更新 | 廠商工具 | UEFI Capsule（`fwupd` / LVFS） |
| CSM | — | 相容模式，模擬 BIOS；新硬體多已移除，**建議關閉** |

**怎麼做**：所有後續操作都以「目前是 UEFI 模式開機」為前提，先確認；`/sys/firmware/efi` 存在代表核心是由 UEFI 韌體啟動，其下的 `efivars` 就是 NVRAM 變數的檔案介面：

```bash
# 判斷目前開機模式（兩者共通）
[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS
cat /sys/firmware/efi/fw_platform_size        # 64 = 64-bit UEFI（32-bit UEFI 的舊平板需 ia32 版 GRUB）
ls /sys/firmware/efi/efivars | head            # NVRAM 變數（efivarfs）
efivar -l | head                               # 🟠 efivar；🔵 efivar
```

**注意**：安裝程式會依「安裝媒體是用哪種模式開的」決定裝成 BIOS 還是 UEFI，之後改不了模式。

⚠️ 混用是最常見的災難來源：**用 BIOS 模式開安裝媒體 → 裝成 MBR/BIOS 開機 → 之後韌體改 UEFI 就開不了機**。安裝前確認韌體選單中的開機項名稱帶 `UEFI:` 前綴。

---

## 2. ESP 與開機檔案佈局

**為什麼**：UEFI 規範要求韌體至少要能讀 FAT，所以 ESP 用 FAT32 當所有 OS 與韌體的共同語言；每個 OS 在 `EFI/<名稱>/` 有自己的目錄，多系統不再互相覆蓋 MBR。目錄裡之所以是三個檔（shim → grub → MokManager）而不是一個 GRUB，是 Secure Boot 的產物：Microsoft 只簽一個極小的 shim，發行版憑證內嵌在 shim 裡，之後的 GRUB 與核心由發行版自己簽，發行版更新 GRUB 就不必每次送 Microsoft 簽（§4）。ESP 內的 `grub.cfg` 只是跳板，因為 ESP 是 FAT、不該放會頻繁改寫的設定，真正的 `grub.cfg` 留在 `/boot`。

**怎麼做**：ESP：FAT32、建議 512 MB～1 GB、GPT 類型 `EFI System`（`ef00`）、掛在 `/boot/efi`（兩者相同）。實測的目錄結構：

```
/boot/efi/EFI/
├── BOOT/BOOTX64.EFI          ← 後備開機程式（韌體找不到任何 Boot#### 時執行；通常是 shim 副本）
├── BOOT/fbx64.efi            ← 🔵 shim 的 fallback，會依 BOOTX64.CSV 重建 NVRAM 開機項
├── ubuntu/                   ← 🟠
│   ├── shimx64.efi           ← Microsoft 簽署的 shim（第一階段）
│   ├── grubx64.efi           ← Canonical 簽署的 GRUB
│   ├── mmx64.efi             ← MokManager
│   ├── grub.cfg              ← 極小的跳板：search 真正的 /boot/grub/grub.cfg
│   └── BOOTX64.CSV
└── fedora/                   ← 🔵（實測 shim-x64 16.1、grub2-efi-x64 2.12）
    ├── shimx64.efi / shim.efi
    ├── grubx64.efi
    ├── mmx64.efi
    ├── grub.cfg              ← 跳板（實測由 grub2-efi-x64 提供）：configfile $prefix/grub.cfg → /boot/grub2/grub.cfg
    └── BOOTX64.CSV
```

要知道 ESP 裡的檔案是哪個套件放的（修復時重裝哪個套件），查套件檔案清單：

```bash
# 🟠 檔案來源
dpkg -L shim-signed | grep efi            # /usr/lib/shim/shimx64.efi、mmx64.efi、fbx64.efi
dpkg -L grub-efi-amd64-signed | grep signed   # /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed
# 🔵 檔案來源（實測）
rpm -ql shim-x64 | grep efi               # /usr/lib/efi/shim/16.1-5/EFI/fedora/shimx64.efi 與 /boot/efi/EFI/fedora/...
rpm -ql grub2-efi-x64 | grep -E 'efi$|grub.cfg'   # /boot/efi/EFI/fedora/grubx64.efi、/boot/efi/EFI/fedora/grub.cfg、/boot/grub2/grub.cfg
```

**注意**：兩邊真正的 `grub.cfg` 位置不同，是因為 Fedora 在 34 之後把 BIOS 與 UEFI 的設定統一到 `/boot/grub2/`（UEFI 的 grub.cfg 從 ESP 移出改成跳板），而 Ubuntu 一直維持 Debian 的 `/boot/grub/`；兩邊也都不是「在 ESP 裡改設定」。重要差異：
- 🟠 Ubuntu：`grub.cfg` 真正內容在 **`/boot/grub/grub.cfg`**，由 `update-grub` 產生；ESP 內的 `grub.cfg` 只是跳板。
- 🔵 Fedora：`grub.cfg` 在 **`/boot/grub2/grub.cfg`**（BIOS 與 UEFI 同一份），ESP 內的 `/boot/efi/EFI/fedora/grub.cfg` 是跳板（舊版曾是真正設定，Fedora 34 起改為跳板，這是網路上舊教學常錯的地方）。`grub2-mkconfig -o /boot/grub2/grub.cfg` 永遠是正確指令；**UEFI 系統不要執行 `grub2-install`**（會產生未簽署的 GRUB，Secure Boot 下拒絕開機）。

---

## 3. NVRAM 開機項：efibootmgr

**為什麼**：BIOS 只會找「第一顆磁碟的 MBR」，UEFI 則把「開哪顆磁碟的哪個檔案」寫成 NVRAM 裡的 `Boot####` 變數與 `BootOrder`，所以多系統、多磁碟、一次性開救援媒體都不必動磁碟內容。代價是這份清單存在主機板而不是硬碟上：換主機板、韌體重設、部分雲端平台重建 VM、Windows 更新改順序，都會讓清單消失或錯亂，磁碟明明完好卻「No bootable device」。`efibootmgr` 是從 Linux 端讀寫這些變數的工具，故障排除時它是第一個要看的東西。

**怎麼做**：先 `-v` 看目前清單，再依需要改順序、設一次性開機、刪除殘留項或重建：

```bash
sudo efibootmgr -v                       # 列出 BootOrder、BootCurrent、每個 Boot#### 的路徑
# 範例：
# BootCurrent: 0001
# BootOrder: 0001,0002,0000
# Boot0000* Windows Boot Manager  HD(1,GPT,...)/File(\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI)
# Boot0001* ubuntu                HD(1,GPT,...)/File(\EFI\UBUNTU\SHIMX64.EFI)
# Boot0002* Fedora                HD(1,GPT,...)/File(\EFI\FEDORA\SHIMX64.EFI)

sudo efibootmgr -o 0001,0002,0000        # 改順序
sudo efibootmgr -n 0002                  # 下次一次性開機用 0002（BootNext）
sudo efibootmgr -b 0003 -B               # 刪除項目
sudo efibootmgr -b 0001 -A / -a          # 停用 / 啟用
sudo efibootmgr -t 5                     # 韌體選單等待秒數
# 新增（磁碟 /dev/sda、ESP 是第 1 分割）
sudo efibootmgr -c -d /dev/sda -p 1 -L "ubuntu" -l '\EFI\ubuntu\shimx64.efi'      # 🟠
sudo efibootmgr -c -d /dev/sda -p 1 -L "Fedora" -l '\EFI\fedora\shimx64.efi'      # 🔵
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Linux UKI" -l '\EFI\Linux\linux.efi'  # 直接開 UKI（§7）
```

**注意**：UEFI 規範定義了 `EFI/BOOT/BOOTX64.EFI` 這條「可移除媒體路徑」——韌體在沒有任何有效 `Boot####` 時會嘗試它——正是為了 NVRAM 遺失的情況。兩邊在這裡的差異來自 shim 的 fallback 功能：Fedora 把 `fbx64.efi` 與 `BOOTX64.CSV` 一起裝進 ESP，從後備路徑開機時會自動重建開機項；Ubuntu 的 `shim-signed` 雖含 `fbx64.efi`，但預設不裝到 ESP，所以要手動重建。

- 兩者的 GRUB 套件在安裝 / 升級時會自動呼叫 `efibootmgr` 建立項目（🟠 `grub-install` 的 postinst；🔵 shim 的 `fbx64.efi` + `BOOTX64.CSV`）。
- 某些主機板 / 雲端（Hyper-V Gen2、部分 OEM）會**遺失或重設 NVRAM**；`EFI/BOOT/BOOTX64.EFI` 後備路徑就是為此存在。🔵 Fedora 的 fallback 機制會在下次從後備路徑開機時自動重建 `Fedora` 項目；🟠 Ubuntu 需手動 `efibootmgr -c` 或重跑 `grub-install`。
- 移除已不存在的舊項目（重灌後常見的 `ubuntu`、`fedora` 殘留）用 `efibootmgr -b XXXX -B`。

---

## 4. Secure Boot 信任鏈

**為什麼**：Secure Boot 的目標只有一個：**韌體只執行帶有可信簽章的開機程式**，讓 bootkit 無法在 OS 之前插入自己。它源於 2011 年 Microsoft 的 Windows 8 硬體認證要求（回應當時氾濫的 MBR bootkit），Linux 陣營則用 shim + MOK 讓自由軟體也能在不關 Secure Boot 的前提下開機。本節依信任鏈的順序說明：金鑰層級、第三方模組、自簽 EFI 檔、以及常見故障。

### 4.1 金鑰層級

**為什麼**：金鑰分四層是為了分權：PK 是主機板廠商的「擁有者」金鑰，只用來授權 KEK 變更；KEK 授權更新 db / dbx；db 是允許清單，dbx 是撤銷清單。幾乎所有 PC 的 db 都只有 Microsoft 的兩張憑證（Windows CA 與第三方 UEFI CA），Linux 若要不關 Secure Boot 就能開機，就得有一個被 Microsoft UEFI CA 簽署的檔案——這就是 2012 年 Matthew Garrett 寫的 shim：它極小、幾乎不變、只負責驗證下一階段，內嵌發行版自己的 CA，之後的 GRUB / 核心 / 模組全由發行版簽。MOK 則讓機器擁有者在不能改韌體 db 的情況下（企業筆電、OEM 鎖定）也能加入自己的憑證，shim 同樣信任。dbx 之所以重要，是因為 2020 年 BootHole（GRUB 解析 `grub.cfg` 的緩衝區溢位，簽過的 GRUB 反而成了攻擊入口）與 2023 年 BlackLotus（拿舊版有漏洞但簽章有效的 Windows bootloader 繞過 Secure Boot）證明：光有簽章不夠，還要能撤銷。核心 lockdown 則補上最後一段：若 root 開機後仍能載入任意模組或寫 `/dev/mem`，前面的驗證就毫無意義。

**怎麼做**：信任鏈如下，每一層只信任「由上一層簽署」的下一層：

```
PK（Platform Key，主機板廠商）
 └─ KEK（Key Exchange Key，Microsoft + 廠商）
     ├─ db（允許清單）：Microsoft Windows CA、Microsoft UEFI CA（第三方，簽 shim）
     └─ dbx（撤銷清單）：已知有漏洞的開機程式 hash（BootHole、BlackLotus 相關）

shim（Microsoft UEFI CA 簽署）
 └─ 內嵌發行版憑證：🟠 Canonical CA / 🔵 Fedora Secure Boot CA
     ├─ grubx64.efi（發行版簽署）
     │    └─ vmlinuz（發行版簽署；🟠 linux-image-*-generic 已簽、🔵 kernel-core 已簽）
     │         └─ 核心模組（樹內模組已簽；第三方需 MOK 簽署）
     └─ MOK（Machine Owner Key）：使用者自行登錄的憑證，shim 也信任
```

查目前狀態：Secure Boot 是否開啟、已登錄哪些 MOK、核心是否進入 lockdown，以及韌體 db / dbx 的內容：

```bash
mokutil --sb-state                       # SecureBoot enabled / disabled
mokutil --list-enrolled                  # 已登錄的 MOK
mokutil --list-new                       # 待登錄
sudo dmesg | grep -iE "secure boot|lockdown"   # "Secure boot enabled" / "Kernel is locked down"
cat /sys/kernel/security/lockdown        # [none] integrity confidentiality；Secure Boot 開啟時核心自動 integrity 模式
sudo efi-readvar 2>/dev/null | head      # efitools（🟠 apt install efitools；🔵 dnf install efitools）看 PK/KEK/db/dbx
```

**注意**：核心 **lockdown（integrity）** 的影響：不能載入未簽署模組、不能寫 `/dev/mem`、`kexec` 受限、hibernate 需簽署映像、`/proc/kcore` 關閉。若某工具在 Secure Boot 下失效，多半是這個原因。

### 4.2 第三方模組與 MOK（DKMS / akmods）

**為什麼**：lockdown 下核心只載入「用信任鏈裡某把金鑰簽過」的模組；發行版樹內模組隨核心一起簽好了，但 NVIDIA、VirtualBox、ZFS 這類在本機編譯的模組沒人簽，載入時就會 `Key was rejected by service`。解法不是關 Secure Boot，而是在本機產生一把 MOK、登錄到 shim，之後每次重編都用它簽。兩邊流程不同的原因：Ubuntu 的 `shim-signed` 套件把 MOK 產生與登錄整合進 DKMS hook，裝模組時自動提示；Fedora 的第三方模組來自 RPM Fusion（不在官方套件庫，不能整合進 shim 套件），所以 akmods 需要使用者手動產生並登錄一次金鑰。

**怎麼做**：登錄 MOK 都要經過「設一次性密碼 → 重開機 → 在 MokManager（藍色畫面）輸入密碼」這一步，因為登錄必須在韌體階段由實體在場的人確認，否則惡意軟體就能自己塞金鑰：

```bash
# 🟠 Ubuntu：DKMS 自動處理
#   安裝 dkms 模組（如 nvidia、virtualbox-dkms、zfs-dkms）時會提示設定 MOK 密碼 → 重開機 → MokManager 藍色畫面
#   → Enroll MOK → Continue → 輸入密碼 → 重開機
sudo update-secureboot-policy --enroll-key    # 手動觸發登錄（金鑰在 /var/lib/shim-signed/mok/MOK.der）
sudo update-secureboot-policy --new-key       # 重新產生
mokutil --import /var/lib/shim-signed/mok/MOK.der
# 🔵 Fedora：akmods 需手動一次
sudo dnf install -y akmods                    # 實測 0.6.2；RPM Fusion 的 akmod-nvidia 相依
sudo kmodgenca -a                             # 產生 /etc/pki/akmods/certs/public_key.der（實測目錄 certs/ private/）
sudo mokutil --import /etc/pki/akmods/certs/public_key.der   # 設一次性密碼 → 重開機在 MokManager 登錄
sudo akmods --force && sudo dracut -f         # 之後每次核心更新 akmods 自動用此金鑰簽署
# ⚪ 手動簽署單一模組
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 MOK.priv MOK.der module.ko     # 🟠
sudo /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 /etc/pki/akmods/private/private_key.priv /etc/pki/akmods/certs/public_key.der module.ko   # 🔵
modinfo module.ko | grep -E "sig_key|signer"
```

**注意**：MOK 私鑰（🟠 `/var/lib/shim-signed/mok/MOK.priv`、🔵 `/etc/pki/akmods/private/`）等於「這台機器的 Secure Boot 通行證」，權限務必只有 root 可讀；有人拿到它就能簽任何模組或 EFI 檔繞過整條信任鏈。

### 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot）

**為什麼**：shim 只信任發行版憑證與 MOK，所以任何自己產生的 EFI 檔——自製 UKI、systemd-boot、重編的 GRUB——在 Secure Boot 下都會被拒。既然 §4.2 已經有一把登錄過的 MOK，用同一把簽這些檔案就能讓 shim 放行，不必動韌體。另一條路是把 PK / KEK / db 整個換成自己的金鑰（完全自有信任鏈），適合無 Windows 的自有伺服器，但 Microsoft 簽的東西（Windows、部分 GPU 的 Option ROM、廠商韌體更新 capsule）會一併失效，屬高風險操作。

**怎麼做**：用 `sbsign` 簽、`sbverify` 驗證誰簽的：

```bash
# sbsigntools（🟠 sbsigntool 0.9.4；🔵 sbsigntools 0.9.5）；金鑰即 MOK 或自建 db 金鑰
sudo sbsign --key MOK.priv --cert MOK.pem --output /boot/efi/EFI/Linux/linux.efi linux.efi
sbverify --list /boot/efi/EFI/ubuntu/grubx64.efi        # 看誰簽的
sbverify --cert MOK.pem linux.efi
# pesign（🔵 Fedora 官方用）：pesign -S -i grubx64.efi
# 完全自有金鑰（清空 PK/KEK/db 換成自己的，適合自有伺服器 / 無 Windows）：
#   sbctl（Arch 生態；🟠🔵 24.04 / 44 套件庫皆無，需自行安裝）或 efitools 的 KeyTool；風險高，會讓 Windows / 韌體更新失效
```

### 4.4 Secure Boot 相關故障

**為什麼**：Secure Boot 的錯誤訊息都很短（一行 Security Violation 或模組載入失敗），但原因分屬三種完全不同的層次：檔案沒簽或簽章不被信任、簽章有效但已被 dbx / SBAT 撤銷、以及 MOK 流程沒走完。SBAT 是 BootHole 之後引進的世代號機制——dbx 是 hash 清單，容量有限且每個發行版每個版本都要加一筆，撐不住；SBAT 改成「元件名 + 最低允許世代」，一筆就能撤銷所有舊版 shim / GRUB，但代價是韌體更新 SBAT 政策後，沒跟上的舊 shim 會突然開不了機。

**怎麼做**：依症狀對照：

| 症狀 | 處理 |
|---|---|
| "Verification failed: (0x1A) Security Violation" | 開機檔未簽署或 dbx 撤銷：🟠 重裝 `shim-signed grub-efi-amd64-signed`；🔵 `dnf reinstall shim-x64 grub2-efi-x64`；或 BIOS 暫時關 Secure Boot |
| NVIDIA / VirtualBox 模組載入失敗 `Key was rejected by service` | MOK 未登錄：§4.2 |
| 更新後 dbx 導致舊 shim 被擋（SBAT） | `mokutil --list-sbat-revocations`、`mokutil --set-sbat-policy latest\|automatic`（實測 🔵 mokutil 0.7.2 有此選項，🟠 24.04 的 0.6.0 沒有）；更新 shim 套件 |
| MokManager 沒出現 | 有些韌體需在 30 秒內按任意鍵；或 `mokutil --timeout -1` |
| 想暫時關 lockdown 除錯 | 只能在韌體關 Secure Boot；核心參數 `lockdown=` 在 Secure Boot 下會被忽略 |

---

## 5. 開機載入器：GRUB2 與 systemd-boot

**為什麼**：shim 之後由開機載入器負責找核心與 initramfs、組核心參數、提供選單。GRUB2 什麼都能做（LVM / LUKS / Btrfs / 網路 / BIOS 與 UEFI 通吃），但也因此程式碼龐大，BootHole 就出在它的設定檔解析器；systemd-boot 走另一端：只讀 ESP、沒有腳本語言、攻擊面極小，但要求核心放在 ESP 且只支援 UEFI。兩個發行版預設都是 GRUB2，差在核心項目的管理方式（§5.2）。

### 5.1 GRUB2（兩者預設）

**為什麼**：兩者都用 GRUB2 是因為它是唯一能同時處理 BIOS / UEFI、加密 `/boot`、LVM 與各種檔案系統的載入器，且已有 Microsoft 信任鏈下的簽署流程。重點是「重裝」的方式兩邊不同：Ubuntu 的 `grub-install` 加 `--uefi-secure-boot` 會複製已簽署版本；Fedora 的 `grub2-install` 會現場產生一個**未簽署**的 GRUB，Secure Boot 下直接開不了機，必須改用重裝套件。

**怎麼做**：

```bash
# 🟠
sudo update-grub                                    # /boot/grub/grub.cfg
cat /etc/default/grub                               # 實測 24.04 預設 GRUB_TIMEOUT_STYLE=hidden、GRUB_TIMEOUT=0
ls /etc/grub.d/                                     # 實測含 25_bli、30_uefi-firmware、35_fwupd、10_linux_zfs
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --uefi-secure-boot   # 重裝（會用簽署版）
# 🔵
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo dnf reinstall -y shim-x64 grub2-efi-x64        # 重裝（不要 grub2-install）
sudo grub2-editenv - list; sudo grub2-editenv - set kernelopts="..."   # 舊版 kernelopts；Fedora 36+ 參數直接在 BLS entry
# ⚪ 從 GRUB 選單進 UEFI 設定：選單有 "UEFI Firmware Settings"（30_uefi-firmware）；或
sudo systemctl reboot --firmware-setup
```

**注意**：🟠 24.04 預設隱藏選單且 timeout 0，要進選單得在開機時按住 Shift 或 Esc；改 `/etc/default/grub` 後記得 `update-grub`。

### 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設

**為什麼**：傳統做法是每裝一個核心就重新產生整份 `grub.cfg`，一個腳本出錯就全部核心都開不了；BLS（freedesktop 規範，Fedora 30 起採用）改成每個核心一個獨立的小檔案，安裝 / 移除核心只是新增 / 刪除檔案，`grub.cfg` 本身幾乎不再變動，而且同一組 entry 檔可以被 GRUB、systemd-boot 或 ostree（Silverblue / CoreOS）共用。Ubuntu 沿用 Debian 的 `10_linux` 掃描方式，是兩邊核心項目管理方式不同的根本原因。

**怎麼做**：Fedora 的 GRUB 不把核心寫死在 `grub.cfg`，而是讀 **`/boot/loader/entries/<machine-id>-<version>.conf`**（實測範例）：

```
title Fedora Linux (7.1.10-200.fc44.x86_64) 44 (Server Edition)
version 7.1.10-200.fc44.x86_64
linux /boot/vmlinuz-7.1.10-200.fc44.x86_64
initrd /boot/initramfs-7.1.10-200.fc44.x86_64.img $tuned_initrd
options root=/dev/mapper/fedora-root ro rhgb quiet $tuned_params
grub_users $grub_users
grub_arg --unrestricted
grub_class fedora
```

改核心參數用 `grubby`（會同時改所有 entry），不要手改 `grub.cfg`；entry 由 `kernel-install` 的 plugin 產生：

```bash
sudo grubby --info=ALL                               # 讀寫這些 entry（04 章 §5.2）
sudo grubby --update-kernel=ALL --args="console=ttyS0"
ls /usr/lib/kernel/install.d/                        # 實測：20-grub、50-dracut、90-loaderentry、90-uki-copy、95-set-boot-entry、99-grub-mkconfig
sudo kernel-install add $(uname -r) /lib/modules/$(uname -r)/vmlinuz   # 手動重建 entry + initramfs
grep GRUB_ENABLE_BLSCFG /etc/default/grub            # =true；設 false 回到傳統 grub.cfg 模式
```

**注意**：🟠 Ubuntu 仍用傳統方式（`10_linux` 掃 `/boot/vmlinuz-*` 寫進 `grub.cfg`），但 24.04 有 `25_bli`（Boot Loader Interface，寫 `LoaderEntrySelected` 等 EFI 變數給 systemd 用）。

### 5.3 systemd-boot（極簡替代方案，只支援 UEFI）

**為什麼**：systemd-boot（前身 gummiboot）刻意不做 GRUB 會做的事：不讀 LVM / LUKS、沒有腳本語言、只靠 UEFI 韌體提供的 FAT 驅動讀 ESP，因此程式碼小到可以完整審計，是 BootHole 之後「減少開機階段攻擊面」的主流選擇，也是 UKI（§7）的原生搭檔。代價是核心與 initramfs 必須放在 ESP（或 XBOOTLDR），且它不是 Microsoft 簽署的，Secure Boot 下要自己解決簽章。

**怎麼做**：兩邊套件名不同（🟠 `systemd-boot`、🔵 `systemd-boot-unsigned`），裝好後用 `bootctl` 安裝到 ESP 並建 NVRAM 項：

```bash
# 🟠 24.04 實測套件 systemd-boot 255 + systemd-boot-efi（/usr/lib/systemd/boot/efi/systemd-bootx64.efi、linuxx64.efi.stub）
sudo apt install -y systemd-boot
# 🔵 實測 systemd-boot-unsigned 259（/usr/lib/systemd/boot/efi/systemd-bootx64.efi）；Fedora 未提供已簽署版，Secure Boot 下需自簽或走 shim
sudo dnf install -y systemd-boot-unsigned
# ⚪
sudo bootctl install                 # 複製到 ESP 的 EFI/systemd/ 與 EFI/BOOT/BOOTX64.EFI，並建立 NVRAM 項
sudo bootctl status                  # 顯示 Secure Boot、TPM、目前載入器、entries
sudo bootctl list
sudo bootctl update                  # 升級後更新 ESP 內的載入器
```

設定只有幾行；`editor no` 很重要——允許在選單改核心參數等於讓任何實體接觸者加 `init=/bin/bash` 拿到 root。`/boot/efi/loader/loader.conf`：

```
default  @saved
timeout  5
console-mode max
editor   no          # 禁止在選單改核心參數（安全）
```

entry 就是 BLS Type #1 格式，與 §5.2 的相同。`/boot/efi/loader/entries/ubuntu.conf`（Type #1 entry；核心與 initrd 需在 ESP 或 XBOOTLDR 分割區）：

```
title   Ubuntu 24.04
linux   /ubuntu/vmlinuz
initrd  /ubuntu/initrd.img
options root=UUID=xxxx ro quiet splash
```

**注意**：

- 🟠 Ubuntu 用 systemd-boot 時，`kernel-install` 或 `/etc/kernel/postinst.d/` hook 需自行設定把核心複製到 ESP（ESP 要夠大，建議 1 GB+）。
- 🔵 Fedora：`/etc/kernel/install.conf` 設 `layout=bls` 後 `kernel-install` 會自動把核心放到 `$BOOT/<machine-id>/<version>/` 並寫 entry；配合 `systemd-boot` 直接開機。
- Secure Boot：systemd-boot 本身不是 Microsoft 簽署的，需 **shim + 自簽 systemd-boot + MOK**，或用 UKI（§7）減少要簽的東西。

---

## 6. initramfs 與 UEFI 相關設定

**為什麼**：initramfs 是核心與根檔案系統之間的橋，UEFI 相關的早期需求（讀 efivars、TPM 解鎖 LUKS）都得在這裡就有模組；兩邊工具不同（🟠 initramfs-tools、🔵 dracut），dracut 因為原生支援 `--uefi` 與 TPM2，在 UKI / 量測開機的場景明顯方便。ESP 的掛載選項 `umask=0077` 則是因為 FAT 沒有權限概念，不加的話 ESP 裡的所有檔案（含 `grub.cfg`、UKI 內嵌的核心參數）對所有使用者可讀。

**怎麼做**：

```bash
# 🟠 initramfs-tools：/etc/initramfs-tools/modules 加 efivarfs 之類早期需要的模組；update-initramfs -u
# 🔵 dracut：/etc/dracut.conf.d/*.conf；dracut 支援 --uefi 直接產生 UKI（§7）
# ESP 在 fstab 中：
#   UUID=XXXX-XXXX  /boot/efi  vfat  umask=0077,shortname=winnt  0 2     ← 🟠 24.04 預設
#   UUID=XXXX-XXXX  /boot/efi  vfat  umask=0077,shortname=winnt  0 2     ← 🔵 相同
# 掛載選項 umask=0077 是因為 FAT 無權限，避免 ESP 內容全域可讀（含 grub.cfg、可能的 UKI 內嵌參數）
```

---

## 7. UKI（Unified Kernel Image）

**為什麼**：傳統開機鏈只簽了 GRUB 與 vmlinuz，**initramfs 與核心參數都沒簽也沒量測**——initramfs 是本機產生的、參數是 `grub.cfg` 裡的純文字。這留下一個典型的 evil maid 漏洞：能短暫接觸機器的人改掉 initramfs 裡的解鎖腳本，下次你輸入 LUKS 密碼時就被記下；或在 GRUB 選單加 `init=/bin/bash`。UKI（systemd 在 2022 年推動）把核心、initramfs、參數、os-release 打包成一個 PE 檔一次簽署，任何一段被改都會驗證失敗，且能被 TPM 當成單一單位量測（PCR 11），因此成為不可變系統與雲端映像的標準形式。

**怎麼做**：用 `ukify` 打包並簽署（Ubuntu 的 initrd 路徑不同，見註解），再建 NVRAM 項或放到 `EFI/Linux/` 讓 systemd-boot 自動列出；Fedora 另有 dracut 一行版與官方簽署的 `kernel-uki-virt`：

```bash
# 工具：ukify（🟠 systemd-ukify 255；🔵 systemd-ukify 259，皆已實測存在）
ukify --version
sudo ukify build \
  --linux=/boot/vmlinuz-$(uname -r) \
  --initrd=/boot/initramfs-$(uname -r).img \        # 🟠 /boot/initrd.img-$(uname -r)
  --cmdline="root=UUID=xxxx ro quiet" \
  --os-release=@/etc/os-release \
  --secureboot-private-key=MOK.priv --secureboot-certificate=MOK.pem \
  --output=/boot/efi/EFI/Linux/linux-$(uname -r).efi
sudo efibootmgr -c -d /dev/sda -p 1 -L "Linux UKI" -l '\EFI\Linux\linux-x.efi'
# 或讓 systemd-boot 自動發現：放在 ESP 的 EFI/Linux/*.efi 即會列出（Type #2 entry）
# 🔵 dracut 一行版
sudo dracut --uefi --kernel-cmdline "root=UUID=xxxx ro" -f /boot/efi/EFI/Linux/linux.efi
# 🔵 Fedora 官方 UKI（實測）：kernel-uki-virt 提供 /lib/modules/<ver>/vmlinuz-virt.efi（已簽署，給 VM / 雲端）；
#    uki-direct 提供 kernel-install 的 99-uki-uefi-setup.install，把 UKI 複製到 /boot/efi/EFI/Linux/ 並用 kernel-bootcfg 建 NVRAM 項；
#    /etc/kernel/install.conf 可設 uki_generator=ukify、layout=uki
sudo dnf install -y kernel-uki-virt uki-direct
ls /boot/efi/EFI/Linux/
# 🟠 Ubuntu 24.04 尚無官方簽署 UKI；自製 UKI 需 MOK 簽署（§4.3）。Ubuntu Core / 26.04 逐步導入
# 檢視 UKI 內容
ukify inspect /boot/efi/EFI/Linux/linux.efi
objdump -h linux.efi | grep -E "\.(linux|initrd|cmdline|osrel)"
# 核心參數附加（systemd-stub 支援 ESP 內 *.efi.extra.d/*.addon.efi，需簽署；或 SMBIOS 11 型字串 io.systemd.stub.kernel-cmdline-extra 給 VM）
```

**注意**：UKI 把核心參數固定進映像，代表「改參數」就是「重建並重簽」；需要彈性時用簽過的 addon（`*.addon.efi`），而不是回頭用 GRUB 傳參數，否則就失去 UKI 的意義。每個 UKI 內含完整 initramfs，ESP 要預留足夠空間（每版約 50–100 MB）。

---

## 8. TPM 2.0 與量測開機

**為什麼**：Secure Boot 是「驗證後才執行」，但它不留下紀錄，OS 開起來後無法證明自己是經過哪條路徑開機的；TPM 的量測開機（measured boot）補上這點：每個階段在執行下一階段前，先把它的 hash 「延伸」進 PCR（只能累加、不能改寫），最後 PCR 值就是整條開機路徑的指紋。實際用途是把 LUKS 金鑰封在 TPM 裡並綁定特定 PCR：只有開機路徑與封存時一致，TPM 才吐出金鑰——磁碟被拔到別台機器、bootloader 被換掉、Secure Boot 被關掉，都拿不到金鑰。這是 evil maid 與離線竄改的主要防線；加 PIN 則防「筆電整台被偷，開機直接到登入畫面」與對 TPM 匯流排的硬體嗅探。

**怎麼做**：UEFI 開機時每個階段會把下一階段的 hash「延伸」進 TPM 的 **PCR**（Platform Configuration Register）。選哪些 PCR 綁定是取捨：綁越多越嚴但越容易因正常更新而鎖死；PCR 7 只反映 Secure Boot 狀態與憑證，更新核心不會變，是最常用的選擇：

| PCR | 內容 | 變動時機 |
|---|---|---|
| 0 | 韌體程式碼 | 韌體更新 |
| 1 | 韌體設定 | BIOS 設定改變 |
| 4 | 開機載入器（shim / GRUB / systemd-boot / UKI） | 載入器更新 |
| 5 | GPT 分割表 | 分割變更 |
| 7 | **Secure Boot 狀態與使用的憑證** | Secure Boot 開關、db 變更（最常用來綁 LUKS） |
| 8 / 9 | GRUB 指令 / 核心參數與 initrd（GRUB 量測）；systemd-stub 用 11 | 核心參數變更 |
| 11 | UKI 各區段（systemd-stub / systemd-pcrphase） | 核心更新（可用 PCR policy 簽章預測） |
| 14 | MOK 憑證 | MOK 變更 |
| 15 | systemd-pcrphase（開機階段標記） | — |

先讀 PCR 確認 TPM 可用，再用 `systemd-cryptenroll` 把 LUKS slot 綁到 TPM；**一定**先產生救援金鑰再綁：

```bash
ls /dev/tpm0 /dev/tpmrm0; sudo tpm2_getcap properties-fixed | head       # tpm2-tools（兩者實測 5.6 / 5.7）
sudo tpm2_pcrread sha256:0,1,4,7,11
sudo systemd-analyze pcrs                                                 # systemd 255+：列出 PCR 與用途
# LUKS 綁 TPM（06 章 §6 有基本用法）— 進階：PCR 選擇
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/sda3                 # 只綁 Secure Boot 狀態（更新核心不會鎖死）
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7+11 --tpm2-public-key=/etc/systemd/tpm2-pcr-public-key.pem /dev/sda3   # 綁 UKI 簽章的 PCR policy
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes /dev/sda3            # TPM + PIN（防止實體取得後直接開機）
sudo systemd-cryptenroll --recovery-key /dev/sda3                                    # 務必產生救援金鑰
sudo systemd-cryptenroll /dev/sda3                                                   # 列出 slot
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/sda3                                  # 韌體更新前解除，之後重綁
# /etc/crypttab：luks-xxx UUID=... none tpm2-device=auto,discard
# 🟠 update-initramfs -u（需 initramfs-tools 的 systemd 支援；24.04 建議搭配 dracut 或確認 tpm2 模組已含）；🔵 dracut -f（原生支援）
# 遠端證明 / 完整性：Keylime（🔵 套件庫有 keylime；🟠 需 pip）
```

**注意**：PCR 綁定的另一面是「任何合法變更也會鎖死」。

⚠️ 韌體更新、Secure Boot 設定變更、換開機載入器都會改變 PCR 0/1/4/7 → TPM 解鎖失敗，此時用救援金鑰或密碼開機後重新 enroll。生產環境務必把救援金鑰存到密碼管理器。

---

## 9. 韌體更新：fwupd / LVFS

**為什麼**：韌體漏洞是所有防護的下層：Spectre / Meltdown 需要微碼更新、LogoFAIL（2023）讓惡意開機圖片在 UEFI 階段執行程式碼、BMC 與 SSD 韌體都出過遠端可利用的漏洞，而 Secure Boot 與 TPM 都建立在「韌體本身沒問題」的假設上。以前更新韌體得開 Windows 或做 DOS 開機碟，Linux 伺服器往往多年不更新；2015 年起的 LVFS（Linux Vendor Firmware Service）讓廠商直接上傳簽章過的 capsule，`fwupd` 在 Linux 內就能套用，兩個發行版都預設整合。

**怎麼做**：列出可更新裝置、抓更新、套用（UEFI capsule 會在下次重開機由韌體階段的 `fwupdx64.efi` 執行）；`security` 子指令會給一份 HSI 評分，是檢查機器整體開機安全設定的快速方法：

```bash
sudo apt install -y fwupd    # 🟠 實測 2.0.20     sudo dnf install -y fwupd    # 🔵 實測 2.1.7（Workstation 預設）
fwupdmgr get-devices                    # 支援更新的裝置（UEFI 韌體、SSD、NIC、TPM、Thunderbolt、docking）
fwupdmgr refresh && fwupdmgr get-updates
sudo fwupdmgr update                    # UEFI capsule 會在下次重開機由 fwupd-efi（EFI/<distro>/fwupdx64.efi）套用（實測 🟠 /etc/grub.d/35_fwupd）
fwupdmgr get-history; fwupdmgr get-results
fwupdmgr security                       # HSI（Host Security ID）：Secure Boot、TPM、IOMMU、DMA 保護、韌體寫入保護等評分
# 企業內網：fwupd 可設私有 LVFS mirror（/etc/fwupd/remotes.d/）
# 伺服器韌體多走 BMC / vendor 工具（iDRAC、iLO），fwupd 支援 Dell / Lenovo / HP 部分機型
```

**注意**：韌體更新會改 PCR 0（有時連 PCR 1、7 一起），綁了 TPM 的 LUKS 在更新後解不開是**預期行為**；更新前先 `--wipe-slot=tpm2` 或確認救援金鑰在手（§8）。筆電務必接電源，capsule 套用中斷電可能變磚。

---

## 10. PXE / HTTP Boot 與網路安裝（UEFI 版）

**為什麼**：網路開機在 UEFI 下換了整套檔案：BIOS 的 `pxelinux.0` 是 16-bit 程式，UEFI 韌體不會執行；而且 Secure Boot 開著時，從網路載下來的第一個檔案同樣要有 Microsoft 信任鏈的簽章，所以只能是 shim。HTTP Boot（UEFI 2.5，2015）出現的原因是 TFTP 又慢又沒有認證、無法傳大檔（ISO），HTTP(S) 解決這三個問題，也讓開機伺服器可以放在其他網段甚至雲端。

**怎麼做**：

- UEFI PXE 需要 **`shimx64.efi` + `grubx64.efi`**（非 BIOS 的 `pxelinux.0`），由 DHCP option 67 指定 `shimx64.efi`（同時提供 option 93 / vendor class 判斷 UEFI 或 BIOS 客戶端）。
- 🟠 用 `grubnetx64.efi.signed`（實測 grub-efi-amd64-signed 內含）；🔵 用 `grub2-efi-x64` 的 `grubx64.efi` + `shimx64.efi`，並在 TFTP 根放 `grub.cfg`。
- **UEFI HTTP Boot**（UEFI 2.5+）：DHCP option 67 直接給 `http://boot.example.com/shimx64.efi`，不需 TFTP，支援 HTTPS 與大檔（ISO）；iPXE 亦支援。
- 兩者的 Kickstart / autoinstall（01 章 §5）都能在 UEFI PXE 下運作；GRUB 網路 cfg 中的 `linuxefi` / `initrdefi` 在新版 GRUB 已與 `linux` / `initrd` 等價。

---

## 11. 雙系統與多 ESP

**為什麼**：UEFI 讓多系統共存變容易，但共用 ESP 也共用了幾個坑：Windows 安裝程式建的 ESP 只有 100 MB（夠它自己用），放不下 UKI 或 systemd-boot 要的核心；Windows 更新會重寫 `BootOrder`；`os-prober` 自 GRUB 2.06（2021）起預設停用，因為它會以 root 掛載並解析所有找得到的檔案系統，在 BootHole 之後被認定是不必要的攻擊面。時鐘與 Fast Startup 的問題則是兩個 OS 對硬體的假設不同。

**怎麼做**：

- 與 Windows 共存：共用同一個 ESP（Windows 建的通常只有 100 MB，**GRUB + 兩個核心尚可，UKI 或 systemd-boot 會不夠**；安裝前可用 Windows 磁碟工具或 `gdisk` 把 ESP 擴到 512 MB+，或另建第二個 ESP 給 Linux）。
- Windows 更新有時會把 `BootOrder` 改回 Windows Boot Manager：`efibootmgr -o` 改回，或在韌體設 Linux 優先。
- `os-prober`：🟠 24.04 預設 `GRUB_DISABLE_OS_PROBER=true`（安全考量），雙系統需改 false 再 `update-grub`；🔵 同樣預設停用，`grub2-mkconfig` 時會提示。
- 快速啟動（Windows Fast Startup / hibernation）會讓 NTFS 掛成唯讀並可能鎖住共用 ESP：在 Windows 關閉 Fast Startup。
- 硬體時鐘：Windows 用本地時間、Linux 用 UTC → `timedatectl set-local-rtc 1`（Linux 讓步）或在 Windows 登錄檔設 `RealTimeIsUniversal`。

---

## 12. UEFI 故障排除

**為什麼**：UEFI 開機失敗絕大多數不是磁碟壞了，而是「NVRAM 清單」與「ESP 裡的檔案」對不上：清單沒了、路徑指到不存在的檔、ESP 沒掛上、跳板 `grub.cfg` 找的 UUID 變了、或簽章被拒。排除順序因此固定：先 `efibootmgr -v` 看清單，再對照 ESP 內容，最後才看 GRUB 與核心；下表依這個順序整理。

**怎麼做**：

| 症狀 | 檢查 / 處理 |
|---|---|
| 開機直接進韌體設定 / "No bootable device" | `efibootmgr -v` 無項目 → 從安裝媒體 chroot 後 `efibootmgr -c`（§3）或 🟠 `grub-install`、🔵 `dnf reinstall shim-x64`；確認 ESP 有 `EFI/BOOT/BOOTX64.EFI` 後備 |
| 韌體選單看得到項目但選了沒反應 | 路徑指向不存在的檔（`efibootmgr -v` 對照 `ls /boot/efi/EFI/*`）；ESP 損壞：`fsck.vfat -a /dev/sda1` |
| ESP 掛不起來 / `/boot/efi` 空的 | `blkid` 找 `TYPE="vfat"` 且 `PARTLABEL="EFI System Partition"`；fstab UUID 是否正確 |
| 韌體更新後開不了機 | NVRAM 被清：同第一列；TPM PCR 變動：用救援金鑰（§8） |
| 換主機板 / 搬硬碟到新機 | NVRAM 是主機板的，不跟硬碟走：重建 `Boot####`；🔵 從 `EFI/BOOT` 後備開機會自動重建 |
| 從 BIOS 模式裝的系統改成 UEFI | 需 GPT + ESP：`gdisk` 轉換（`mbr2gpt` 概念）、建 ESP、🟠 `apt install grub-efi-amd64-signed shim-signed && grub-install`；🔵 `dnf install shim-x64 grub2-efi-x64 && grub2-mkconfig`；風險高，先備份 |
| GRUB 找不到 `grub.cfg`（進 `grub>` 提示） | 🔵 確認 `/boot/grub2/grub.cfg` 存在並重跑 `grub2-mkconfig`；🟠 `update-grub`；跳板 `grub.cfg` 的 `search --fs-uuid` 對應 `/boot` UUID 是否變了（換磁碟 / 重做檔案系統後常見） |
| 32-bit UEFI（舊 Atom 平板）| 需 `bootia32.efi`：🟠 `grub-efi-ia32`；🔵 無官方支援 |
| 看不到 UEFI Shell | 部分韌體內建；或把 `edk2` 的 `Shell.efi` 放 ESP 用 `efibootmgr -c -l '\shellx64.efi'` |
| `efibootmgr: EFI variables are not supported on this system` | 系統以 BIOS/CSM 模式開機，或容器 / WSL 內執行（無 efivarfs） |

**注意**：在 Live 環境修復時，chroot 前要把 `/sys/firmware/efi/efivars` 一起 bind mount 進去，否則 `efibootmgr` 與 `grub-install` 都會報 EFI variables not supported。

從 Live 環境修復 UEFI 的完整流程見 [12 章 §3](12-監控與故障排除.md)。

---

## 13. 本章差異總結

兩個發行版的 UEFI 差異幾乎都源自同一件事：Fedora 是 Red Hat 開機工具鏈（shim fallback、BLS、grubby、kernel-install、dracut、官方 UKI）的上游試驗場，新機制先在這裡落地；Ubuntu 延續 Debian 的 GRUB 流程（`update-grub`、`10_linux`、initramfs-tools），並把 MOK 整合進 DKMS 讓專有驅動開箱即用。因此同一個動作——重裝載入器、重建開機項、登錄 MOK——兩邊指令不同，但信任鏈與 ESP 佈局的原理完全一樣。下表集中列出實測差異：

| 項目 | 🟠 Ubuntu 24.04 | 🔵 Fedora 44 |
|---|---|---|
| ESP 目錄 | `EFI/ubuntu/` | `EFI/fedora/` |
| shim 套件 / 版本 | `shim-signed` 15.8 | `shim-x64` 16.1 |
| GRUB EFI 套件 | `grub-efi-amd64-signed`（+ `grub-efi-amd64`） | `grub2-efi-x64`（已簽署）+ `grub2-efi-x64-modules` |
| 真正的 grub.cfg | `/boot/grub/grub.cfg` | `/boot/grub2/grub.cfg`（ESP 內為跳板） |
| 重建設定 | `update-grub` | `grub2-mkconfig -o /boot/grub2/grub.cfg` |
| 重裝載入器 | `grub-install --uefi-secure-boot` | `dnf reinstall shim-x64 grub2-efi-x64`（**勿** `grub2-install`） |
| 核心項目管理 | `grub.cfg` 內（10_linux） | BLS `/boot/loader/entries/*.conf` + `grubby` / `kernel-install` |
| NVRAM 遺失自動修復 | 無（手動 `efibootmgr -c`） | shim fallback（`fbx64.efi` + `BOOTX64.CSV`） |
| MOK 登錄 | DKMS 自動 + `update-secureboot-policy` | `kmodgenca` + `mokutil --import` |
| MOK 金鑰路徑 | `/var/lib/shim-signed/mok/` | `/etc/pki/akmods/{certs,private}/` |
| systemd-boot 套件 | `systemd-boot` + `systemd-boot-efi`（255） | `systemd-boot-unsigned`（259） |
| ukify | `systemd-ukify` 255 | `systemd-ukify` 259 |
| 官方 UKI | 無 | `kernel-uki-virt`（已簽署）、`uki-direct` |
| initramfs 工具 | initramfs-tools（dracut 可選） | dracut（原生 `--uefi`、TPM2 支援） |
| fwupd | 2.0.20 | 2.1.7 |
| os-prober | 預設停用 | 預設停用 |
| 32-bit UEFI | `grub-efi-ia32` | 無 |
| sbctl | 套件庫無 | 套件庫無 |
