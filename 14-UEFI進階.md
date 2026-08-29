# 14 - UEFI 進階

本章深入 UEFI 韌體與 Linux 開機的完整鏈：ESP 與 NVRAM 開機項、shim → GRUB / systemd-boot → 核心、Secure Boot 信任鏈與 MOK、BLS 與 UKI、TPM 量測開機、韌體更新，以及 UEFI 特有的故障排除。套件、路徑與工具版本皆於 Ubuntu 24.04 / Fedora 44 實驗機查證；涉及實體韌體（NVRAM、Secure Boot 狀態）的操作在容器中無法執行，指令以官方文件為準並標示。

**本章解決什麼問題**：開機是整個系統唯一「還沒有任何安全機制在跑」的階段——核心尚未載入、SELinux / AppArmor 還不存在、磁碟可能還是加密的。攻擊者只要能改掉這段的任何一個檔案（bootloader、initramfs、核心參數），就能在所有防護啟動前取得控制權，這正是 bootkit 與 evil maid 攻擊的原理。UEFI 的每個機制（Secure Boot、shim / MOK、dbx / SBAT、UKI、TPM 量測）都是對某一次真實攻擊或缺陷的回應，不理解它們在防什麼，就會在「NVIDIA 模組載不進來」「韌體更新後 LUKS 解不開」「重灌後開不了機」時只能盲目關掉 Secure Boot。本章的取捨是：先講每個機制為何存在、它防的是哪種攻擊，再給兩個發行版實測過的操作與差異。

---

## 1. UEFI 與 BIOS 的差異

**名詞與關係**：本章所有名詞都掛在同一條「開機鏈」上，而且有兩個機制從旁作用在鏈的每一個環節：**Secure Boot 驗證**每一層的簽章、**TPM 量測**每一層的 hash。先把整張圖看一遍，之後每一節只是放大其中一段：

```
  ┌─ Secure Boot：每一層執行下一層前先驗它的簽章 ─────────────┐   ┌─ TPM 2.0 量測開機：每一層執行下一層前先把它的 hash 延伸進 PCR ─┐
  │ 韌體 db（Microsoft CA）── 信任 ──▶ shim                     │   │ PCR 0/1 韌體、PCR 4 載入器、PCR 7 Secure Boot 狀態與憑證         │
  │ shim（內嵌發行版 CA + MOK）── 信任 ──▶ 載入器、核心           │   │ PCR 8/9 GRUB 參數、PCR 11 UKI、PCR 14 MOK                          │
  │ 核心（發行版金鑰 + MOK）── 信任 ──▶ 模組                     │   │ → LUKS 金鑰封進 TPM 並綁 PCR：開機路徑不同就拿不到金鑰            │
  └──────────────────────────────────────────────────────────┘   └───────────────────────────────────────────────────────────────┘
                                   ▼ 兩者同時作用在下面每一個箭頭上 ▼

UEFI 韌體 ──依 NVRAM 的 Boot#### / BootOrder──▶ ESP（FAT32，/boot/efi）──▶ shim（shimx64.efi，Microsoft 簽）
                                                                              │
                                                    ┌─────────────────────────┼────────────────────────────┐
                                                    ▼                         ▼                            ▼
                                            GRUB2（grubx64.efi）        systemd-boot               UKI（EFI/Linux/*.efi）
                                            讀 grub.cfg，🔵 再讀        只讀 ESP 的 loader.conf     核心 + initramfs + 核心參數
                                            BLS entries                 + BLS entries               打包成「一個」已簽的 PE 檔
                                                    │                         │                            │
                                                    └────────────┬────────────┘                            │
                                                                 ▼                                         ▼
                                     核心 vmlinuz（發行版簽）＋ initramfs（本機由 dracut / initramfs-tools 產生，未簽）＋ 核心參數（純文字）
                                                                 │
                                                                 ▼
                                     核心模組：樹內模組隨核心簽好；第三方（NVIDIA / ZFS）由 DKMS / akmods 編譯、用 MOK 簽

旁支：MokManager（mmx64.efi）在開機時把 MOK 登錄進 shim；fwupd 把韌體 capsule 放進 ESP，下次開機由 fwupdx64.efi 交給韌體套用（會改 PCR 0/1/7）
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **BIOS（Legacy）** | 1981 年起的 PC 韌體：16-bit、從磁碟第一個磁區（MBR）載入開機碼、不驗證任何東西 | 被 UEFI 取代；CSM 是 UEFI 模擬它的相容層 |
| **UEFI** | 統一可延伸韌體介面，現代主機板韌體標準：開機程式是檔案系統裡的 `.efi` 檔、開機項存在 NVRAM、內建 Secure Boot 與 TPM 介面 | 一切的起點；ESP、efibootmgr、shim、systemd-boot、UKI、fwupd 都只在 UEFI 模式下存在 |
| **CSM / Legacy Boot** | UEFI 內建的 BIOS 相容模式 | 開著它安裝媒體可能以 BIOS 模式啟動，裝出來的系統沒有 ESP，本章的東西全部用不到 |
| **MBR / GPT** | 兩種分割表格式：MBR 是 BIOS 時代的（≤ 2 TB、4 個主分割），GPT 是 UEFI 規範要求的 | UEFI 開機要 GPT + ESP；BIOS 開機碼塞在 MBR 前 440 bytes |
| **ESP** | EFI System Partition：GPT 上一個 FAT32 分割（掛在 `/boot/efi`），韌體只會從這裡找開機檔 | shim、GRUB、systemd-boot、UKI、MokManager、fwupdx64.efi 全放這裡；FAT32 是因為 UEFI 規範只要求韌體會讀 FAT |
| **NVRAM / efivarfs** | 主機板上的非揮發記憶體，存 UEFI 變數（開機項、Secure Boot 金鑰、MOK 請求）；`efivarfs` 是核心把這些變數掛成 `/sys/firmware/efi/efivars` 的檔案介面 | `efibootmgr`、`mokutil`、`bootctl` 都透過 efivarfs 讀寫；容器 / BIOS 模式下沒有它 |
| **Boot#### / BootOrder / BootNext** | NVRAM 中的開機項變數：每個 `Boot####` 指向「哪顆磁碟的 ESP 裡的哪個檔」，`BootOrder` 是嘗試順序，`BootNext` 是下次一次性開機用哪個 | 由 `efibootmgr` 讀寫（§3）；清單在主機板不在硬碟，換板子就沒了 |
| **efibootmgr** | 從 Linux 讀寫 Boot#### / BootOrder 的 CLI | GRUB 套件安裝時會呼叫它建項目；故障排除第一個看的工具 |
| **Secure Boot** | UEFI 的簽章驗證：韌體只執行被 db 內憑證簽過的 `.efi` 檔，之後每一層再驗下一層 | 主機板出廠只信任 Microsoft，所以 Linux 需要 shim；核心進入 lockdown 也是它觸發的 |
| **PK / KEK / db / dbx** | Secure Boot 的四層金鑰：PK 主機板廠商擁有者金鑰 → KEK 授權改 db / dbx → db 允許清單 → dbx 撤銷清單（§4.1） | db 裡幾乎只有 Microsoft 的憑證；dbx 用來撤銷 BootHole / BlackLotus 這類有漏洞但簽章有效的檔案 |
| **SBAT** | BootHole 之後引進的「元件世代號」撤銷機制，一筆就能擋掉所有舊版 shim / GRUB（§4.4） | 補 dbx 容量不足的問題；由 shim 執行檢查 |
| **shim** | 極小、由 Microsoft UEFI CA 簽署的第一階段載入器，內嵌發行版自己的 CA | Secure Boot 信任 shim → shim 信任發行版簽的 GRUB / 核心與使用者登錄的 MOK |
| **MOK / MokManager / mokutil** | Machine Owner Key：機器擁有者自己登錄進 shim 的憑證；MokManager（`mmx64.efi`）是開機時的登錄畫面；`mokutil` 是從 Linux 提出登錄請求與查狀態的 CLI | 讓發行版沒簽的東西（自編模組、自製 UKI、systemd-boot）也能通過 Secure Boot |
| **DKMS / akmods** | 每次核心更新後自動重新編譯第三方模組的機制（🟠 DKMS、🔵 akmods） | 產出的模組沒有發行版簽章，Secure Boot 下必須用 MOK 簽（§4.2） |
| **lockdown** | 核心在 Secure Boot 開啟時自動進入的模式：拒載未簽模組、禁寫 `/dev/mem`、限制 kexec | 讓 Secure Boot 的保護延續到 OS 執行期，否則 root 一開機就能破壞信任鏈 |
| **開機載入器（GRUB2 / systemd-boot）** | shim 之後負責找核心與 initramfs、組核心參數、顯示選單的程式；GRUB2 功能全、systemd-boot 極簡只讀 ESP（§5） | 兩個發行版預設 GRUB2；systemd-boot 是 UKI 的原生搭檔 |
| **grub.cfg / update-grub / grub2-mkconfig** | GRUB 的選單設定檔，與兩邊產生它的指令（🟠 `update-grub`、🔵 `grub2-mkconfig`） | ESP 內只有跳板，真正的 grub.cfg 在 `/boot`（§2） |
| **BLS / loader entries / grubby / kernel-install** | Boot Loader Specification：每個核心一個 `/boot/loader/entries/*.conf`；`grubby` 改這些 entry 的參數，`kernel-install` 在裝核心時產生它們（§5.2） | 🔵 預設；GRUB 與 systemd-boot 都能讀同一組 entry |
| **核心（vmlinuz）/ 核心模組** | 核心映像由發行版簽署；模組是可動態載入的驅動，樹內模組隨核心簽好 | 第三方模組需 MOK 簽才能在 lockdown 下載入 |
| **initramfs / dracut / initramfs-tools** | 核心開機後、真正根檔案系統掛上前用的迷你檔案系統，含驅動與 LUKS 解鎖邏輯；由 🔵 dracut / 🟠 initramfs-tools 在本機產生（§6） | 傳統鏈裡它沒簽也沒量測，是 UKI 要解決的漏洞 |
| **UKI / ukify / systemd-stub** | Unified Kernel Image：把核心、initramfs、核心參數、os-release 打包成一個可簽署的 `.efi`；`ukify` 是打包工具，`systemd-stub` 是包在最前面、負責啟動的 EFI 程式（§7） | 一次簽整包、TPM 以 PCR 11 整包量測；systemd-boot 會自動列出 `EFI/Linux/` 裡的 UKI |
| **TPM 2.0 / PCR / 量測開機** | TPM 是主機板安全晶片；PCR 是它裡面只能「延伸」不能改寫的暫存器；量測開機是每層執行前把下一層 hash 延伸進 PCR（§8） | 與 Secure Boot 互補：一個阻止未簽章的東西執行，一個記錄實際執行了什麼 |
| **LUKS / systemd-cryptenroll** | Linux 全碟加密格式，與把解鎖金鑰封進 TPM（綁 PCR）、加 PIN、產生救援金鑰的工具 | 綁 PCR 後，開機鏈任一層改變（韌體更新、關 Secure Boot）都會解不開 |
| **fwupd / LVFS / capsule** | 韌體更新服務 / 廠商上傳簽過韌體的雲端倉庫 / UEFI 規範的韌體更新封裝格式（§9） | capsule 由韌體在下次開機套用；更新會改 PCR 0/1/7 |
| **PXE / HTTP Boot** | 從網路載入開機檔的兩種機制：PXE 用 DHCP + TFTP，HTTP Boot 用 DHCP + HTTP(S)（§10） | Secure Boot 下網路載下來的第一個檔案仍須是 shim |

本節另外出現的：**bootkit** 是感染開機程式（MBR 或 bootloader）、在 OS 之前執行以躲過所有防護的惡意程式，Mebromi、TDL4 是 2011 年前後的 MBR bootkit 代表，正是 Secure Boot 要防的東西；**EFI** 是 Intel 為 Itanium 設計的原始規範，2005 年移交 **UEFI Forum** 後成為 UEFI；`efivar` 是列出與讀寫 efivarfs 變數的低階工具，`efibootmgr` 就是建在它之上。

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

**名詞與關係**：ESP 裡的檔案分成三類——發行版目錄裡的信任鏈三件套、後備路徑、以及跳板設定；修復時要知道每個檔是誰放的：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`EFI/<發行版>/`** | 每個 OS 在 ESP 裡的私有目錄（🟠 `EFI/ubuntu/`、🔵 `EFI/fedora/`） | NVRAM 的 Boot#### 指向這裡的 `shimx64.efi`；多系統互不覆蓋 |
| **shimx64.efi / grubx64.efi / mmx64.efi** | 三件套：Microsoft 簽的 shim、發行版簽的 GRUB、MokManager | 韌體 → shim → GRUB 依序執行；shim 在需要登錄 MOK 時才叫 mmx64.efi |
| **`EFI/BOOT/BOOTX64.EFI`（後備路徑）** | UEFI 規範定義的「可移除媒體路徑」：韌體找不到任何有效 Boot#### 時會試這個檔 | 兩邊都放 shim 副本；NVRAM 遺失時靠它開機（§3） |
| **fbx64.efi / BOOTX64.CSV** | shim 的 fallback 程式與它讀的清單：從後備路徑開機時，依 CSV 內容重建 NVRAM 開機項 | 🔵 裝進 ESP 所以會自動修復；🟠 套件有但預設不放進 ESP |
| **跳板 grub.cfg** | ESP 內只有幾行的 `grub.cfg`，內容是「去 `/boot` 找真正的 grub.cfg」 | 因為 ESP 是 FAT、不適合放常改的檔案；真正的設定 🟠 在 `/boot/grub/`、🔵 在 `/boot/grub2/` |
| **update-grub / grub2-mkconfig** | 產生真正 grub.cfg 的指令（🟠 `update-grub` 是 `grub-mkconfig -o /boot/grub/grub.cfg` 的包裝） | 改 `/etc/default/grub` 後都要跑一次 |
| **grub-install / grub2-install** | 把 GRUB 執行檔裝進 ESP 並建 NVRAM 項的指令 | 🟠 加 `--uefi-secure-boot` 會複製已簽署版本；🔵 `grub2-install` 會現場產生未簽的 GRUB，Secure Boot 下開不了機，要改用重裝套件 |
| **`dpkg -L` / `rpm -ql`** | 列出某套件安裝了哪些檔案 | 用來反查 ESP 內的檔案來自哪個套件，修復時知道該重裝誰 |

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

**名詞與關係**：NVRAM 裡與開機有關的變數只有幾個，`efibootmgr` 的每個選項都對應其中一個：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **Boot####** | 一個開機項：名稱 + 「哪顆磁碟的哪個 GPT 分割、分割內哪個路徑」（`HD(1,GPT,...)/File(\EFI\...)`） | `efibootmgr -c` 建、`-b XXXX -B` 刪、`-A / -a` 停用 / 啟用 |
| **BootOrder** | 韌體依序嘗試 Boot#### 的清單 | `efibootmgr -o` 改；Windows 更新常把自己排到最前面（§11） |
| **BootCurrent** | 這次實際是從哪個 Boot#### 開起來的 | 確認「現在跑的是 ESP 裡哪份載入器」的最快方法 |
| **BootNext** | 只用一次的「下次開機用這個」，用完自動清除 | `efibootmgr -n`；開救援媒體或另一個 OS 一次而不動 BootOrder |
| **Timeout** | 韌體開機選單等待秒數 | `efibootmgr -t` |
| **可移除媒體路徑** | `EFI/BOOT/BOOTX64.EFI`，規範保證韌體在沒有任何有效 Boot#### 時會嘗試它（§2） | USB 安裝碟就是靠它免設定開機；硬碟上放 shim 副本則是 NVRAM 遺失的保險 |
| **shim fallback（fbx64.efi + BOOTX64.CSV）** | 從後備路徑開機時，shim 轉交給 fbx64.efi，它讀 CSV 自動重建 Boot####（§2） | 🔵 自動修復、🟠 需手動 `efibootmgr -c`，是兩邊在這一節的主要差異 |
| **postinst** | 🟠 Debian 套件安裝後自動執行的腳本 | `grub-efi-amd64-signed` 的 postinst 會跑 `grub-install` 而建開機項，所以重裝套件也能修 NVRAM |

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

**名詞與關係**：Secure Boot 的信任是一層授權一層的階層，韌體端四層、Linux 端兩層，中間靠 shim 接起來；兩個攻擊事件解釋了為什麼還要有撤銷清單：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **PK（Platform Key）** | 主機板廠商的「平台擁有者」金鑰，一台機器只有一把 | 只用來授權 KEK 的變更；換掉 PK 等於接管整條信任鏈（§4.3） |
| **KEK（Key Exchange Key）** | 被 PK 授權、可以更新 db / dbx 的金鑰（通常是 Microsoft 與廠商各一把） | Microsoft 用它推送 dbx 更新 |
| **db（允許清單）** | 韌體信任的憑證與 hash 清單；PC 上幾乎只有 Microsoft Windows CA 與 Microsoft UEFI CA（第三方 CA） | shim 由 Microsoft UEFI CA 簽，所以能被任何出廠 PC 執行 |
| **dbx（撤銷清單）** | 已知有漏洞、即使簽章有效也不准執行的檔案 hash 或憑證清單 | BootHole、BlackLotus 之後大量擴充；容量有限，催生 SBAT（§4.4） |
| **Microsoft UEFI CA** | Microsoft 專門用來簽第三方（非 Windows）開機程式的憑證 | 發行版把 shim 送去簽，拿到的就是這張憑證的簽章 |
| **shim** | 被 Microsoft UEFI CA 簽署、內嵌發行版 CA 的極小載入器（§1） | 是韌體信任鏈與發行版信任鏈之間唯一的接點 |
| **發行版 CA** | 🟠 Canonical CA / 🔵 Fedora Secure Boot CA，用來簽 GRUB、核心與樹內模組 | 內嵌在 shim 裡，所以發行版更新 GRUB 不必每次送 Microsoft 簽 |
| **MOK** | 機器擁有者透過 MokManager 登錄進 shim 的憑證（§1） | shim 把它當成與發行版 CA 同等信任的來源 |
| **lockdown（integrity / confidentiality）** | 核心的自我限制模式：integrity 禁止修改執行中的核心（未簽模組、`/dev/mem`、kexec）；confidentiality 再禁止讀取核心記憶體 | Secure Boot 開啟時自動進 integrity，把韌體的驗證延續到 OS 執行期 |
| **BootHole（2020）** | GRUB 解析 `grub.cfg` 時的緩衝區溢位：簽過的 GRUB 讀一份惡意設定檔就能執行任意碼 | 證明「簽章有效」不等於安全，促成大規模 dbx 更新與 SBAT |
| **BlackLotus（2023）** | 拿舊版有漏洞但簽章仍有效的 Windows bootloader 繞過 Secure Boot 的實戰 bootkit | 證明 dbx 撤銷要跟得上，否則舊檔永遠可用 |
| **efitools / efi-readvar** | 讀取與操作 PK / KEK / db / dbx 的工具組 | 看韌體到底信任誰、dbx 有多少筆 |
| **mokutil** | 從 Linux 查 Secure Boot 狀態、列出 / 提出 MOK 登錄請求的 CLI（§1） | 請求寫進 NVRAM，由下次開機的 MokManager 完成 |

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

**名詞與關係**：這一節是「產生一把 MOK → 登錄進 shim → 每次重編模組都用它簽」三步，兩邊差在哪一步自動化了：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **DKMS** | Dynamic Kernel Module Support：把第三方模組原始碼登記起來，每次裝新核心就自動重編、安裝（🟠 主要機制） | 🟠 `shim-signed` 提供的 hook 會在 DKMS 建模組後自動用 MOK 簽 |
| **akmods** | 🔵 RPM Fusion 的對應機制：`akmod-*` 套件在開機或核心更新時自動編出 `kmod-*` 並簽署 | 因為來自第三方套件庫，無法整合進 Fedora 的 shim 套件，所以金鑰要手動產生登錄一次 |
| **RPM Fusion** | Fedora 的第三方套件庫，NVIDIA、VirtualBox 等專有模組由此提供（13 章 §7） | akmods 的來源 |
| **`kmodgenca`** | akmods 附的工具，產生一對 MOK（`/etc/pki/akmods/certs/public_key.der` + `private/private_key.priv`） | 產生後要 `mokutil --import` 登錄公鑰 |
| **`update-secureboot-policy`** | 🟠 `shim-signed` 附的工具，產生 / 重生 MOK（`/var/lib/shim-signed/mok/`）並觸發登錄 | DKMS 安裝時會自動叫它；手動也可以 |
| **MOK.priv / MOK.der / MOK.pem** | 同一把 MOK 的私鑰 / DER 格式公鑰憑證 / PEM 格式公鑰憑證 | `mokutil --import` 吃 DER；`sbsign`（§4.3）與 `ukify`（§7）吃 PEM |
| **`sign-file`** | 核心原始碼附的簽模組工具，用私鑰對單一 `.ko` 加簽 | DKMS / akmods 背後就是呼叫它；手動簽時直接用 |
| **`modinfo` 的 `sig_key` / `signer`** | 模組內嵌簽章的資訊 | 用來驗證「這個模組確實被我的 MOK 簽過」 |
| **`Key was rejected by service`** | lockdown 核心拒載模組時的錯誤訊息 | 意思是簽章的金鑰不在核心信任清單裡（沒簽、或 MOK 沒登錄成功） |
| **MokManager 登錄流程** | `mokutil --import` 只是把請求與一次性密碼寫進 NVRAM，真正登錄在下次開機的藍色畫面完成 | 密碼是為了證明「發出請求的人就是現在坐在機器前的人」 |

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

**名詞與關係**：簽一個 EFI 檔有兩種工具、兩條信任路線（用 MOK 或換掉整套韌體金鑰），本節的名詞就分這兩組：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **PE 檔** | Portable Executable，Windows 與 UEFI 共用的執行檔格式；所有 `.efi` 都是 PE | Authenticode 簽章就嵌在 PE 檔內，`sbsign` / `pesign` 簽的就是它 |
| **sbsigntools（`sbsign` / `sbverify`）** | 對 PE 檔加簽 / 驗簽的工具組（🟠 套件名 `sbsigntool`、🔵 `sbsigntools`） | 金鑰可以是 MOK（走 shim）或自建 db 金鑰（走韌體） |
| **pesign** | Red Hat 開發的同類工具，支援 NSS 資料庫與硬體簽章模組 | 🔵 官方建置流程用它簽 shim / GRUB / 核心 |
| **sbctl** | Arch 生態的一站式工具：產生自有 PK / KEK / db、登錄進韌體、簽檔並記住要簽哪些檔 | 兩邊套件庫都沒有，需自行安裝；是「完全自有金鑰」路線最省事的工具 |
| **KeyTool** | efitools 附的 EFI 應用程式，在韌體階段替換 PK / KEK / db | sbctl 之外的另一條自有金鑰路線 |
| **Option ROM** | 顯示卡、RAID 卡、網卡上自帶的韌體程式，由 UEFI 在開機時執行 | 多數由 Microsoft UEFI CA 簽；換掉 db 後這些卡可能無法初始化 |
| **capsule** | UEFI 韌體更新封裝（§9） | 廠商 capsule 也靠 Microsoft 信任鏈；自有金鑰後可能套用失敗 |

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

**名詞與關係**：故障表裡的名詞對應三種不同層次的拒絕——簽章不被信任、簽章被撤銷、登錄流程沒走完：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **Security Violation（0x1A）** | UEFI 的 `EFI_SECURITY_VIOLATION` 狀態碼：韌體或 shim 拒絕執行某個檔案 | 原因可能是沒簽、簽章不在 db / MOK、或被 dbx / SBAT 撤銷，訊息本身不區分 |
| **dbx** | hash / 憑證撤銷清單（§4.1） | 一個檔案一筆，容量撐不住每個發行版每版 GRUB 都加 |
| **SBAT** | Secure Boot Advanced Targeting：每個元件在 `.sbat` 區段宣告「名稱 + 世代號」，shim 依 NVRAM 裡的 SBAT 政策拒絕世代號太舊的元件 | 一筆政策就能撤銷所有舊版；副作用是政策更新後未升級的 shim / GRUB 突然被擋 |
| **`mokutil --list-sbat-revocations` / `--set-sbat-policy`** | 查目前 SBAT 撤銷政策 / 設定政策要跟最新還是自動 | 🔵 0.7.2 有、🟠 0.6.0 沒有 |
| **`mokutil --timeout`** | 設 MokManager 畫面的等待秒數（-1 為永遠等） | 有些韌體太快略過 MokManager，登錄一直失敗就是這個 |
| **`lockdown=` 核心參數** | 手動指定 lockdown 等級的參數 | Secure Boot 開啟時被核心忽略，所以除錯只能在韌體關 Secure Boot |

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

**名詞與關係**：GRUB 的設定分「你改的」與「產生出來的」兩層，重裝則分「裝執行檔」與「產生設定」兩件事：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`/etc/default/grub`** | 使用者改的 GRUB 參數檔（timeout、預設核心參數、是否用 BLS） | 改完必須跑 `update-grub` / `grub2-mkconfig` 才會進 grub.cfg |
| **`/etc/grub.d/`** | 一組腳本，`grub-mkconfig` 依序執行它們把輸出串成 grub.cfg：`10_linux` 掃核心、`30_uefi-firmware` 加「進 UEFI 設定」項、`35_fwupd` 加韌體更新項、`25_bli` 寫 Boot Loader Interface 變數 | 🟠 核心項目就是 `10_linux` 產生的；🔵 用 BLS 時 `10_linux` 只輸出 `blscfg` 指令 |
| **`update-grub` / `grub2-mkconfig`** | 產生 grub.cfg 的指令（§2） | 兩邊輸出路徑不同：`/boot/grub/` vs `/boot/grub2/` |
| **`grub-install --uefi-secure-boot`** | 🟠 把已簽署的 `grubx64.efi.signed` 與 shim 複製進 ESP 並建 NVRAM 項 | 不加此選項會裝未簽版本；🔵 沒有對應選項，只能重裝套件 |
| **`grub2-editenv` / grubenv / kernelopts** | `grubenv` 是 GRUB 的小型鍵值檔（記住上次選的核心等）；🔵 舊版把核心參數放在其中的 `kernelopts` | Fedora 36+ 參數改寫在每個 BLS entry 裡，`grubby` 改的就是那裡（§5.2） |
| **`systemctl reboot --firmware-setup`** | 透過 UEFI 變數 `OsIndications` 要求下次重開直接進韌體設定 | 與 GRUB 選單的 `30_uefi-firmware` 項目做的是同一件事 |

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

**名詞與關係**：BLS 讓「核心清單」脫離 grub.cfg 變成一堆小檔案，周邊工具都是在讀寫這些檔案：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **BLS Type #1 entry** | freedesktop 規範的純文字開機項：`title` / `linux` / `initrd` / `options` 各一行，一個核心一個檔 | GRUB（透過 `blscfg` 模組）、systemd-boot、ostree 都能讀同一組檔案 |
| **`/boot/loader/entries/`** | 存放 entry 檔的目錄；檔名為 `<machine-id>-<version>.conf` | machine-id 當前綴是為了多系統共用 `/boot` 時不互撞 |
| **`grubby`** | 🔵 讀寫 BLS entry（與傳統 grub.cfg）的 CLI，改核心參數、設預設核心 | `--update-kernel=ALL --args=` 會同時改所有 entry，比手改安全 |
| **`kernel-install` / `install.d` plugin** | systemd 提供的核心安裝框架：裝核心時依序執行 `/usr/lib/kernel/install.d/` 的 plugin（產 initramfs、寫 entry、建 NVRAM 項等） | 🔵 `kernel-core` 套件的 scriptlet 就是呼叫它；`layout=bls` / `layout=uki` 決定產出 entry 還是 UKI（§5.3、§7） |
| **`GRUB_ENABLE_BLSCFG`** | `/etc/default/grub` 的開關，`true` 時 grub.cfg 只放一行 `blscfg` 去讀 entry 檔 | 設 `false` 就退回 `10_linux` 傳統模式 |
| **ostree（Silverblue / CoreOS）** | 以整個檔案系統樹為單位做原子更新的不可變系統 | 也用 BLS entry 描述每個部署，所以 GRUB 不用改就能開 |
| **Boot Loader Interface / `25_bli`** | systemd 定義的一組 EFI 變數（`LoaderEntrySelected`、`LoaderDevicePartUUID` 等），讓 OS 知道自己是被哪個載入器、哪個 entry 開起來的 | 🟠 24.04 的 `25_bli` 讓 GRUB 也寫這些變數，`bootctl status` 與 `systemd-analyze` 才讀得到 |

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

**名詞與關係**：systemd-boot 的所有設定都在 ESP 裡，名詞就是 ESP 內的幾個檔案與管理它們的一個 CLI：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **systemd-boot（gummiboot）** | systemd 專案的極簡 UEFI 載入器：只讀 ESP、沒有腳本語言、選單來自 entry 檔；前身叫 gummiboot | 不是 Microsoft 簽的，Secure Boot 下要 shim + MOK 自簽或改用 UKI |
| **`bootctl`** | 安裝 / 更新 systemd-boot 到 ESP、建 NVRAM 項、顯示狀態與 entry 的 CLI | `install` 會同時放 `EFI/systemd/` 與後備路徑 `EFI/BOOT/BOOTX64.EFI` |
| **`loader.conf`** | `/boot/efi/loader/loader.conf`，全域設定：預設項、timeout、是否允許編輯 | `editor no` 關掉選單內改參數，否則等於任何人可加 `init=/bin/bash` |
| **Type #1 entry / Type #2 entry** | Type #1 是 `loader/entries/*.conf` 純文字檔（與 BLS 相同）；Type #2 是直接放在 `EFI/Linux/` 的 UKI，不需任何設定檔 | systemd-boot 兩種都會自動列出；GRUB 只讀 Type #1 |
| **XBOOTLDR / `$BOOT`** | Extended Boot Loader Partition：ESP 太小時另建的第二個分割（GPT 類型 `ea00`），規範允許 entry 與核心放這裡；`$BOOT` 是規範對「放核心的分割」的統稱 | 核心必須放在韌體讀得到的 FAT 分割，不能放 `/boot` 的 ext4 / Btrfs，所以才需要 XBOOTLDR 或大 ESP |
| **`systemd-boot-efi` / `systemd-boot-unsigned`** | 提供 `systemd-bootx64.efi` 與 `linuxx64.efi.stub` 的套件（🟠 / 🔵 名稱不同） | 🔵 名稱裡的 unsigned 提醒你它沒簽章 |
| **`linuxx64.efi.stub`** | 即 systemd-stub，做 UKI 時包在最前面的啟動程式（§7） | 與 systemd-boot 同套件出貨，但可獨立使用（UKI 不需要 systemd-boot） |
| **`/etc/kernel/install.conf` 的 `layout=`** | 告訴 `kernel-install` 核心要放哪：`bls` 放 `$BOOT/<machine-id>/<version>/` 並寫 Type #1 entry；`uki` 產 UKI | 🔵 一行就能讓新核心自動進 ESP；🟠 需自寫 `postinst.d` hook |

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

**名詞與關係**：initramfs 只有兩個工具與一個掛載選項需要認識：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **initramfs** | 核心開機後先掛上的記憶體內迷你根檔案系統，含掛真正根檔案系統前需要的驅動、LVM / LUKS / TPM 解鎖邏輯（§1） | 在本機產生、不簽章，除非打包進 UKI |
| **initramfs-tools / `update-initramfs`** | 🟠 Debian 系的 initramfs 產生器：`/etc/initramfs-tools/modules` 列要多放的模組，`update-initramfs -u` 重建 | 對 TPM2 / systemd 解鎖流程支援較弱，24.04 常改裝 dracut |
| **dracut / `dracut.conf.d/`** | 🔵 預設的產生器（🟠 亦可裝），模組化、原生支援 systemd、TPM2 與 `--uefi` 直接輸出 UKI | `kernel-install` 的 `50-dracut` plugin 就是呼叫它 |
| **`efivarfs` 模組** | 把 NVRAM 變數掛成 `/sys/firmware/efi/efivars` 的核心模組（§1） | 需要在 initramfs 階段讀 UEFI 變數（例如 `LoaderDevicePartUUID` 找 ESP）時才要加進去 |
| **`umask=0077` / `shortname=winnt`** | vfat 掛載選項：前者讓 FAT 上所有檔案只有 root 可讀，後者決定 8.3 短檔名的大小寫呈現 | FAT 沒有 Unix 權限，全靠掛載選項決定；不加 umask 則 ESP 內容全域可讀 |

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

**名詞與關係**：UKI 是「把原本分開的四個東西打成一個可簽的檔」，名詞分成打包工具、檔內結構、以及怎麼被開機與量測：

```
ukify build ──▶ linux.efi（PE 檔）
                 ├─ systemd-stub（linuxx64.efi.stub）：最前面的啟動程式，負責把後面三段交給核心
                 ├─ .linux    ← vmlinuz
                 ├─ .initrd   ← initramfs
                 ├─ .cmdline  ← 核心參數（固定進映像）
                 └─ .osrel    ← /etc/os-release（systemd-boot 用來顯示選單名稱）
        整包用 MOK 簽一次（--secureboot-*）→ Secure Boot 驗整包；TPM 以 PCR 11 量測整包
        放進 ESP 的 EFI/Linux/ → systemd-boot 自動列出（Type #2）；或 efibootmgr 直接建項目指向它
        要臨時加參數：另做已簽的 *.addon.efi 放在 <uki>.extra.d/，stub 開機時合併
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **UKI** | 核心 + initramfs + 核心參數 + os-release 打包成一個 PE 檔的開機映像（§1） | 一次簽署、一次量測；是 systemd-boot Type #2 entry 的實體 |
| **systemd-stub** | UKI 最前面的 EFI 程式，被韌體 / 載入器執行後解開各區段、把 initramfs 與參數交給核心 | 由 `systemd-boot-efi` / `systemd-boot-unsigned` 提供（§5.3）；也負責讀 addon 與量測 PCR 11 |
| **`ukify`** | systemd 的 UKI 打包工具，可同時用 `--secureboot-*` 簽章、`inspect` 檢視內容 | 🟠 / 🔵 套件都叫 `systemd-ukify` |
| **`.linux` / `.initrd` / `.cmdline` / `.osrel` 區段** | PE 檔內的四個區段，各放一樣東西 | `objdump -h` 看得到；`ukify inspect` 直接解讀 |
| **Type #2 entry / `EFI/Linux/`** | systemd-boot 規範：放在 ESP `EFI/Linux/` 的 UKI 不需 entry 檔就會被列出 | 與 §5.3 的 Type #1 對照 |
| **addon（`*.addon.efi` / `*.efi.extra.d/`）** | 只含 `.cmdline`（或 devicetree）區段的小 PE 檔，簽過後放在 UKI 同名的 `.extra.d/` 目錄，stub 開機時合併進參數 | 讓「改參數」不必重建 UKI，又不失去簽章保護 |
| **`kernel-uki-virt` / `uki-direct` / `kernel-bootcfg`** | 🔵 官方已簽署的 UKI 套件（給 VM / 雲端）/ 讓 `kernel-install` 直接把 UKI 放進 ESP 的套件 / 後者用來建 NVRAM 項的工具 | 三者合起來就是 Fedora 的「免 GRUB 開機」路線 |
| **SMBIOS Type 11 字串** | 主機板（或 hypervisor）透過 SMBIOS 表傳給 OS 的 OEM 字串；stub 會讀 `io.systemd.stub.kernel-cmdline-extra` 當額外參數 | 給 VM 用：從 libvirt XML 傳參數而不用重建 UKI |
| **PCR 11** | systemd-stub 量測 UKI 各區段用的 PCR（§8） | 因為每個 UKI 內容固定，PCR 11 值可預先計算並簽章，讓 LUKS 綁定不會因核心更新而鎖死 |
| **evil maid** | 能短暫實體接觸機器、竄改開機檔（如 initramfs）再放回去的攻擊 | 傳統鏈中 initramfs 與參數不簽不量測，正是它的下手處；UKI 補上這個洞 |

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

**名詞與關係**：TPM 一節的名詞圍繞「量測進 PCR → 金鑰綁 PCR → 綁錯了怎麼救」三段：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **TPM 2.0** | 主機板上（或 CPU 內建的 fTPM）的安全晶片，能做量測紀錄、保管金鑰、依條件放行金鑰（§1） | `/dev/tpm0` 是獨佔存取，`/dev/tpmrm0` 是核心的資源管理器讓多程式共用 |
| **PCR** | Platform Configuration Register，TPM 內一組只能「延伸」（新值 = hash(舊值 ‖ 新資料)）不能寫入的暫存器，24 個各有約定用途 | 值代表整段開機歷史；表中列出哪層寫哪個 PCR |
| **量測 / 延伸（measure / extend）** | 每層在執行下一層前，先算它的 hash 並延伸進對應 PCR | 由韌體、shim、GRUB、systemd-stub、systemd-pcrphase 各自完成 |
| **量測開機（measured boot）** | 上述機制的總稱：不阻止任何東西執行，只留下不可竄改的紀錄 | 與 Secure Boot 互補；靠 PCR 綁定才產生實際效果 |
| **`systemd-cryptenroll`** | 把 LUKS 的一個 keyslot 交由 TPM 保管、綁定指定 PCR / PIN，或產生救援金鑰的工具 | 開機時由 initramfs 內的 systemd-cryptsetup 依 `/etc/crypttab` 的 `tpm2-device=auto` 向 TPM 要金鑰 |
| **LUKS keyslot** | LUKS header 裡的金鑰槽，每槽可用不同方式（密碼、TPM、救援金鑰）解出同一把主金鑰 | TPM 只佔一槽，密碼槽仍在，所以 TPM 失效還能輸密碼 |
| **PIN** | 綁 TPM 之外再要求輸入的短密碼，TPM 內部驗證、有錯誤次數鎖定 | 防「整台被偷直接開到登入畫面」與對 TPM 匯流排的硬體嗅探 |
| **救援金鑰（recovery key）** | `systemd-cryptenroll --recovery-key` 產生的隨機長密碼，佔一個 keyslot | PCR 變動後唯一不用重灌的解法；一定先產生再綁 TPM |
| **PCR policy / `--tpm2-public-key`** | 不綁 PCR 的固定值，而是綁「用這把公鑰簽過的 PCR 11 預期值」 | 核心更新時發行版一併簽新的預期值，LUKS 不會鎖死；只對 UKI 有意義 |
| **`systemd-pcrphase`** | systemd 在開機各階段（initrd 結束、進入 sysinit 等）往 PCR 11 / 15 延伸標記的服務 | 讓「金鑰只能在 initrd 階段解出，開機完成後就拿不到」成為可能 |
| **tpm2-tools（`tpm2_pcrread` 等）** | 直接操作 TPM 的低階 CLI | 用來確認 TPM 可用、讀目前 PCR 值 |
| **`systemd-analyze pcrs`** | 列出每個 PCR 的用途與目前值（systemd 255+） | 比 `tpm2_pcrread` 好讀 |
| **Keylime / 遠端證明** | 讓伺服器把 TPM 簽過的 PCR 值送到中央驗證，證明自己的開機路徑未被竄改 | 量測開機在資料中心規模的用法 |

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

**名詞與關係**：韌體更新在 Linux 上是「服務 + 倉庫 + 封裝格式」三件事組成的一條路：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **fwupd / `fwupdmgr`** | 韌體更新 daemon 與其 CLI（§1）；GNOME Software 也是它的前端 | 從 LVFS 下載 capsule，交給 fwupd-efi 在下次開機套用 |
| **LVFS** | Linux Vendor Firmware Service，廠商上傳簽章過韌體的公開倉庫 | fwupd 預設的 remote；企業可設私有 mirror |
| **capsule（UEFI Capsule）** | UEFI 規範的韌體更新封裝：OS 把它放進 ESP 並設變數，韌體在下次開機時讀取並刷寫 | 主機板 UEFI 韌體走這條路；SSD、NIC、docking 等裝置則由 fwupd 直接透過各自協定更新 |
| **fwupd-efi / `fwupdx64.efi`** | 放在 ESP `EFI/<distro>/` 的 EFI 應用程式，負責在韌體階段把 capsule 交給韌體 | 🟠 GRUB 的 `35_fwupd` 會為它加選單項 |
| **HSI（Host Security ID）** | fwupd 對機器開機安全設定的分級評分：Secure Boot、TPM、IOMMU、DMA 保護、韌體寫保護等 | `fwupdmgr security` 一次檢查本章各節設定是否到位 |
| **微碼（microcode）** | CPU 內部的可更新指令實作，Spectre / Meltdown 緩解靠它 | 由發行版套件（`intel-microcode` / `microcode_ctl`）在開機早期載入，不經 fwupd |
| **LogoFAIL（2023）** | UEFI 韌體解析開機 logo 圖片的漏洞，惡意圖片可在 Secure Boot 之前執行程式碼 | 證明韌體本身也要更新，Secure Boot 救不了韌體層的洞 |
| **BMC / iDRAC / iLO** | 伺服器的獨立管理控制器（Dell iDRAC、HPE iLO 都是 BMC 實作） | 伺服器韌體更新多走這裡；fwupd 只支援部分機型 |
| **`/etc/fwupd/remotes.d/`** | fwupd 的更新來源設定 | 設私有 LVFS mirror 或關閉外部來源 |

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

**名詞與關係**：網路開機是「DHCP 告訴客戶端去哪拿檔 → 用某個協定拿到第一個 `.efi` → 它再拿後面的東西」，名詞對應每一步：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **PXE** | Preboot Execution Environment：網卡韌體用 DHCP 取得 IP 與開機檔位置，再用 TFTP 下載並執行 | BIOS 與 UEFI 都支援，但要的檔案格式不同 |
| **TFTP** | 極簡、無認證、UDP 的檔案傳輸協定 | PXE 的預設傳輸；慢且不適合大檔，是 HTTP Boot 出現的原因 |
| **DHCP option 67 / option 93** | 67 是「開機檔名」；93 是客戶端回報的架構（BIOS 或 x64 UEFI 等） | DHCP 伺服器依 93 決定 67 要給 `pxelinux.0` 還是 `shimx64.efi` |
| **`pxelinux.0`** | syslinux 的 BIOS 版網路開機程式 | UEFI 韌體不會執行它 |
| **`grubnetx64.efi.signed`** | 🟠 內建網路模組的 GRUB EFI 版，已簽署 | 由 shim 載入後直接從 TFTP / HTTP 抓 grub.cfg 與核心 |
| **HTTP Boot** | UEFI 2.5 起內建的機制：DHCP 直接給一個 `http(s)://` URL，韌體用內建 HTTP 客戶端下載開機檔 | 取代 TFTP；支援 HTTPS 與跨網段 |
| **iPXE** | 開源的加強版網路開機韌體 / 程式，支援 HTTP、iSCSI、腳本 | 可鏈式載入：PXE 先抓 iPXE，再由 iPXE 走 HTTP |
| **`linuxefi` / `initrdefi`** | 舊版 GRUB 在 UEFI 下載入核心 / initrd 的專用指令 | 新版已與 `linux` / `initrd` 等價，網路 cfg 兩種寫法都可 |
| **Kickstart / autoinstall** | 🔵 / 🟠 的無人值守安裝描述檔（01 章 §5） | 由核心參數（`inst.ks=`、`autoinstall ds=`）指向網路上的檔案 |

**為什麼**：網路開機在 UEFI 下換了整套檔案：BIOS 的 `pxelinux.0` 是 16-bit 程式，UEFI 韌體不會執行；而且 Secure Boot 開著時，從網路載下來的第一個檔案同樣要有 Microsoft 信任鏈的簽章，所以只能是 shim。HTTP Boot（UEFI 2.5，2015）出現的原因是 TFTP 又慢又沒有認證、無法傳大檔（ISO），HTTP(S) 解決這三個問題，也讓開機伺服器可以放在其他網段甚至雲端。

**怎麼做**：

- UEFI PXE 需要 **`shimx64.efi` + `grubx64.efi`**（非 BIOS 的 `pxelinux.0`），由 DHCP option 67 指定 `shimx64.efi`（同時提供 option 93 / vendor class 判斷 UEFI 或 BIOS 客戶端）。
- 🟠 用 `grubnetx64.efi.signed`（實測 grub-efi-amd64-signed 內含）；🔵 用 `grub2-efi-x64` 的 `grubx64.efi` + `shimx64.efi`，並在 TFTP 根放 `grub.cfg`。
- **UEFI HTTP Boot**（UEFI 2.5+）：DHCP option 67 直接給 `http://boot.example.com/shimx64.efi`，不需 TFTP，支援 HTTPS 與大檔（ISO）；iPXE 亦支援。
- 兩者的 Kickstart / autoinstall（01 章 §5）都能在 UEFI PXE 下運作；GRUB 網路 cfg 中的 `linuxefi` / `initrdefi` 在新版 GRUB 已與 `linux` / `initrd` 等價。

---

## 11. 雙系統與多 ESP

**名詞與關係**：雙系統的坑來自「兩個 OS 共用 ESP、NVRAM 與硬體時鐘」，名詞就是這三樣共用資源與各自的處理工具：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **Windows Boot Manager** | Windows 的 UEFI 載入器（`EFI/Microsoft/Boot/bootmgfw.efi`）與其 NVRAM 項 | Windows 更新時常把它排回 BootOrder 第一位 |
| **`os-prober`** | GRUB 的輔助程式，掛載並掃描所有分割區找其他 OS，產生對應選單項 | 2.06 起預設停用（安全考量）；`GRUB_DISABLE_OS_PROBER=false` 重新啟用 |
| **多 ESP** | 一顆磁碟或一台機器上有多個 EFI System Partition | 規範允許；Linux 用自己的 ESP 可避開 Windows 建的 100 MB 太小的問題 |
| **`gdisk`** | GPT 分割表編輯工具 | 擴 ESP、建第二個 ESP、MBR 轉 GPT 都用它 |
| **Fast Startup** | Windows 的「關機其實是休眠核心」功能，關機後 NTFS 與 ESP 仍處於被鎖定的髒狀態 | Linux 看到的 NTFS 變唯讀、ESP 可能損壞；在 Windows 關閉它 |
| **RTC / 硬體時鐘** | 主機板上的即時時鐘；Linux 預設視它為 UTC，Windows 視它為本地時間 | 兩邊各自「修正」導致每次切換系統時間差 8 小時；`timedatectl set-local-rtc 1` 或 Windows 登錄 `RealTimeIsUniversal` 二選一 |

**為什麼**：UEFI 讓多系統共存變容易，但共用 ESP 也共用了幾個坑：Windows 安裝程式建的 ESP 只有 100 MB（夠它自己用），放不下 UKI 或 systemd-boot 要的核心；Windows 更新會重寫 `BootOrder`；`os-prober` 自 GRUB 2.06（2021）起預設停用，因為它會以 root 掛載並解析所有找得到的檔案系統，在 BootHole 之後被認定是不必要的攻擊面。時鐘與 Fast Startup 的問題則是兩個 OS 對硬體的假設不同。

**怎麼做**：

- 與 Windows 共存：共用同一個 ESP（Windows 建的通常只有 100 MB，**GRUB + 兩個核心尚可，UKI 或 systemd-boot 會不夠**；安裝前可用 Windows 磁碟工具或 `gdisk` 把 ESP 擴到 512 MB+，或另建第二個 ESP 給 Linux）。
- Windows 更新有時會把 `BootOrder` 改回 Windows Boot Manager：`efibootmgr -o` 改回，或在韌體設 Linux 優先。
- `os-prober`：🟠 24.04 預設 `GRUB_DISABLE_OS_PROBER=true`（安全考量），雙系統需改 false 再 `update-grub`；🔵 同樣預設停用，`grub2-mkconfig` 時會提示。
- 快速啟動（Windows Fast Startup / hibernation）會讓 NTFS 掛成唯讀並可能鎖住共用 ESP：在 Windows 關閉 Fast Startup。
- 硬體時鐘：Windows 用本地時間、Linux 用 UTC → `timedatectl set-local-rtc 1`（Linux 讓步）或在 Windows 登錄檔設 `RealTimeIsUniversal`。

---

## 12. UEFI 故障排除

**名詞與關係**：修復時會用到的名詞多數前面已定義，這裡補救援環境相關的幾個：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **chroot** | 從 Live 環境把根目錄切換到硬碟上的系統，讓 `grub-install`、`dnf reinstall` 等在「原系統」內執行 | 要先把 `/dev`、`/proc`、`/sys` 與 efivars bind mount 進去，工具才看得到硬體與 NVRAM |
| **bind mount efivars** | `mount --bind /sys/firmware/efi/efivars` 到 chroot 內同路徑 | 少了它 `efibootmgr` 報 EFI variables not supported |
| **`fsck.vfat`** | FAT 檔案系統檢查修復工具 | ESP 損壞（非正常斷電、Fast Startup）時用 |
| **`blkid` / PARTLABEL** | 列出分割的檔案系統類型、UUID、GPT 分割名稱 | 找回 ESP 的 UUID 以修 fstab |
| **`mbr2gpt`** | Windows 內建的 MBR → GPT 無損轉換工具 | Linux 用 `gdisk` 做同一件事；轉完還要建 ESP 並重裝載入器 |
| **`bootia32.efi` / 32-bit UEFI** | 32-bit UEFI 韌體（舊 Atom 平板）要的 IA32 版載入器 | 🟠 `grub-efi-ia32` 提供；🔵 無官方支援 |
| **UEFI Shell / edk2** | UEFI 的命令列環境，可手動執行 `.efi`、看變數；edk2 是 UEFI 參考實作，提供 `Shell.efi` | 部分韌體內建；沒有就放進 ESP 建開機項 |
| **WSL / 容器** | 沒有真實韌體的環境 | efivarfs 不存在，所有 NVRAM 相關指令必然失敗，不是設定問題 |

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
