# Linux 系統管理完整手冊（Ubuntu & Fedora 雙發行版）

> 適用版本：**Ubuntu 24.04 LTS（Noble）/ 26.04 LTS** 與 **Fedora 42 以上（Workstation / Server）**。
> 兩者的指令在較新的版本大多向下相容；若有版本差異會在內文特別註明。

本手冊以「一套流程、兩種發行版」的方式撰寫：主要步驟共用，凡 Ubuntu 與 Fedora **做法不同之處**一律以下列標記呈現，方便對照。

## 建立實驗環境（建議先做）

**為什麼**：這份手冊的每一條指令都在實驗機上跑過，讀者也應該邊讀邊做——尤其是 17 章的故障情境，光讀沒有用。實驗環境有兩種，**所有準備方式都集中在這一節與 [`scripts/lab/`](scripts/lab/README.md)**，各章不再各自說明：

| | 方式 A：容器（預設） | 方式 B：虛擬機 |
|---|---|---|
| 建立時間 | 第一次 3 分鐘，之後 20 秒 | 首次下載映像 + 2～3 分鐘 |
| 需求 | Docker 或 Podman；Linux / WSL2 / macOS | Linux 主機 + KVM（或 Multipass / VirtualBox） |
| 能練習的章節 | 02～13、15、17 的絕大多數內容（systemd、apt/dnf、防火牆、LVM、備份、HA 設定、故障情境） | 全部，**特別是** 01 安裝與分割、12 開機救援、14 UEFI / Secure Boot / TPM、16 SELinux enforcing |
| 限制 | 共用主機核心：無 udev、無真實開機、SELinux disabled（容器內的差異與處理見 [`scripts/lab/README.md`](scripts/lab/README.md)） | 較耗資源；需要虛擬化權限 |

### 方式 A：容器（`setup-lab.sh`）

```bash
git clone git@github.com:ChunPingWang/linux-tutorial.git && cd linux-tutorial
bash scripts/lab/setup-lab.sh up             # 建映像、啟動 lab-ubuntu（24.04）與 lab-fedora（44）、部署 04 章範例服務 myapp
bash scripts/lab/setup-lab.sh status         # lab-ubuntu running systemd=running myapp=active ...
bash scripts/lab/setup-lab.sh shell ubuntu   # 進入（或 fedora）；手冊掛在 /manual，腳本已複製到 /root
```

進入容器後可以直接做的事：

```bash
apt update && apt install -y nginx          # 🟠 照著章節敲指令   /   dnf install -y nginx   # 🔵
bash /root/scen/01-disk-full.sh inject      # 17 章故障情境：注入 → 自己排查 → status 對照 → solve 還原
bash /root/lab-storage-test.sh              # 06 / 15 章儲存實驗（LVM、RAID、LUKS、Btrfs；setup-lab.sh up 會嘗試載入模組）
bash /root/lab-backup-test.sh               # 11 章備份實驗
```

```bash
bash scripts/lab/setup-lab.sh test          # 一次跑完 systemd / storage / backup 三支測試（約 5～10 分鐘）
bash scripts/lab/setup-lab.sh down          # 移除容器（映像保留）
```

### 方式 B：虛擬機

**B1. KVM / libvirt + 官方雲端映像（`setup-vm.sh`，Linux 主機）**：用 01 章 §6 的雲端映像與 cloud-init 自動建好兩台可 SSH 的 VM，UEFI 開機、有序列主控台，可練習 GRUB / 救援模式 / Secure Boot / SELinux enforcing。

```bash
# 主機準備（只做一次）。下面兩行擇一：看你的「主機」是哪個發行版——
#   🟠 主機是 Ubuntu / Debian 系 → 只執行第 1 行；🔵 主機是 Fedora / RHEL 系 → 只執行第 2 行
sudo apt install -y qemu-system-x86 libvirt-daemon-system virtinst cloud-image-utils ovmf      # 🟠 Ubuntu 主機
sudo dnf install -y @virtualization virt-install cloud-utils edk2-ovmf                          # 🔵 Fedora 主機
[ -f ~/.ssh/id_ed25519.pub ] || ssh-keygen -t ed25519      # 兩者都要：VM 用這把金鑰登入（使用者 sysop）
# 之後的步驟兩種主機相同。setup-vm.sh up 會自動：啟動 libvirt daemon、把你加入 libvirt 群組、啟動 default 網路
# 建立與使用
bash scripts/lab/setup-vm.sh up                 # 下載 Ubuntu 24.04 與 Fedora 44 雲端映像、建 seed ISO、virt-install（UEFI）
bash scripts/lab/setup-vm.sh ssh ubuntu         # 或 fedora
bash scripts/lab/setup-vm.sh console fedora     # 序列主控台：看 GRUB 選單、進 rescue.target / rd.break（Ctrl+] 離開）
bash scripts/lab/setup-vm.sh snapshot ubuntu before-upgrade   # 危險操作前先快照；還原：virsh snapshot-revert lab-vm-ubuntu before-upgrade
bash scripts/lab/setup-vm.sh status ; bash scripts/lab/setup-vm.sh down
```

VM 內把手冊的腳本帶進去：`scp -r scripts admin@<ip>:` 後同樣執行 `scripts/lab/scenarios/*.sh` 與 `lab-*-test.sh`（VM 有 udev 與真實核心，不需要容器的那些變通）。

**B2. 從安裝媒體互動安裝（練習 01 章）**：下載 ISO（01 章 §1.1），用 `virt-install --cdrom <iso> --boot uefi --disk size=40 --memory 4096 --os-variant ubuntu24.04|fedora-rawhide` 或 virt-manager / VirtualBox / Hyper-V 新建 VM，照 01 章 §3～§4 走安裝程式；無人值守版用 01 章 §5 的 autoinstall / Kickstart 搭配 `--cdrom` 與 seed ISO。

**B3. 沒有 Linux 主機時**：
- Windows / macOS：**Multipass**（Ubuntu 專用，`multipass launch 24.04 --name lab-ubuntu --cloud-init scripts/examples/unattended/…` 或直接 `multipass shell`）；Fedora 用 VirtualBox / VMware 開 ISO。
- **WSL2 也能跑方式 B**：Windows 11 的 WSL2 預設開啟巢狀虛擬化（`/dev/kvm` 存在），在 WSL 發行版內裝 libvirt 後 `setup-vm.sh` 可直接用（本手冊即在 Fedora 44 WSL2 上實測建立兩台 UEFI VM）；限制是 VM 無法橋接到實體 LAN、記憶體受 `.wslconfig` 上限。01 章 §7 的 WSL 發行版本身不是完整環境（無 SELinux、無真實開機），要練那些章節請開 VM。

**注意**：`setup-vm.sh` 已在 Fedora 44 WSL2 主機實測（兩台 UEFI VM、Fedora VM 為 SELinux enforcing、SSH 金鑰登入）。腳本會自動處理實測時踩到的三個問題：🔵 libvirt 模組化 daemon 裝完沒啟動（`virtqemud.socket` 等）、映像放家目錄時 qemu 使用者無法存取（改放 `/var/lib/libvirt/images/lab-vm`）、Ubuntu 雲端映像已有 `admin` 群組導致 `useradd admin` 失敗（使用者改叫 `sysop`）。仍需手動處理的：`default` 網路不存在時 `virsh net-define /usr/share/libvirt/networks/default.xml`。

## 寫作慣例：先定義名詞與關係，再說「為什麼」，最後「怎麼做」

每個重點都依 **名詞與關係 → 為什麼（Why）→ 怎麼做（How）→ 注意（陷阱）** 的順序撰寫：小節若出現多個專有名詞，先用一句話定義每個名詞，並以關係圖或三欄表說明它們彼此的關係（誰依賴誰、先後、取代或互補），避免「為什麼」段落丟出讀者不認識的名詞；接著先講這個設定解決什麼問題、不做會怎樣、為什麼選這個做法，再給指令。目的是讓讀者理解決策脈絡，而不是只照抄指令。對照表前也會先解釋兩個發行版為什麼會不同（設計哲學、上游差異）。編修規範與範例見 [STYLE.md](STYLE.md)。

## 標記慣例

| 標記 | 意義 |
|---|---|
| 🟠 **Ubuntu** | 僅適用於 Ubuntu（Debian 系）的做法 |
| 🔵 **Fedora** | 僅適用於 Fedora（RHEL 系）的做法 |
| ⚪ **共通** | 兩者相同（預設情況，通常不特別標示） |
| ⚠️ | 危險操作或容易踩雷之處 |
| 💡 | 實務建議 |

指令區塊中若同一步驟需要兩種寫法，會並排呈現：

```bash
# 🟠 Ubuntu
sudo apt install nginx
# 🔵 Fedora
sudo dnf install nginx
```

## 章節目錄

| 章節 | 內容 |
|---|---|
| [00 - 差異速查表](00-差異速查表.md) | 一頁看完 Ubuntu 與 Fedora 的所有關鍵差異 |
| [00b - 設計階段的需求考量](00b-設計階段的需求考量.md) | 設計決策流程圖（G0～G4 關卡）、設計前的決策條件與框架決策（自建 / 託管、實體 / 雲端、發行版家族、單向門清單、加權評分、決策關卡）、十個需求問題、需求 → 決策推導表（Tier / RPO / 生命週期 / 合規 / 工作負載 / 部署位置）、SLA / SLO / SLI 與可用性計算（串聯相乘、並聯冗餘、MTBF/MTTR、錯誤預算）、容量規劃與隱性用量、環境與網路規劃、維運模型、設計決策紀錄範本與上線前檢查清單 |
| [01 - 系統安裝](01-系統安裝.md) | 安裝媒體、分割區、LVM/加密、無人值守安裝（autoinstall / Kickstart）、雲端映像、WSL2 |
| [02 - 初始設定](02-初始設定.md) | 主機名、時區、使用者與 sudo、SSH、MAC 基礎、通用初始化腳本 |
| [03 - 套件與軟體安裝](03-套件與軟體安裝.md) | apt / dnf、PPA / COPR、Snap / Flatpak、第三方套件庫、原始碼編譯、語言套件管理 |
| [04 - 系統管理](04-系統管理.md) | systemd 服務與 timer、使用者與權限、程序管理、排程、核心與開機管理 |
| [05 - 網路與防火牆](05-網路與防火牆.md) | Netplan / NetworkManager、DNS、Bonding / VLAN / Bridge、ufw / firewalld / nftables、路由與 NAT、網路除錯 |
| [06 - 檔案系統與儲存](06-檔案系統與儲存.md) | 分割區、LVM、ext4 / XFS / Btrfs / ZFS、RAID、LUKS、NFS / Samba / iSCSI、配額、SMART |
| [07 - 日誌管理](07-日誌管理.md) | journald、rsyslog、logrotate、auditd、集中式日誌 |
| [08 - 安全強化](08-安全強化.md) | 自動更新、SSH、Fail2ban、AppArmor / SELinux 進階、CIS 基準、憑證與 TLS |
| [09 - 性能調校](09-性能調校.md) | 觀測工具、CPU / 記憶體 / I/O / 網路調校、sysctl、tuned、cgroup |
| [10 - 高可用設計](10-高可用設計.md) | Keepalived、HAProxy、Pacemaker / Corosync、DRBD、資料庫 HA、架構模式 |
| [11 - 備份與災難復原](11-備份與災難復原.md) | 3-2-1 原則、rsync / restic / borg、LVM & Btrfs 快照、系統映像、DR 演練 |
| [12 - 監控與故障排除](12-監控與故障排除.md) | Prometheus / Grafana、開機失敗、救援模式、磁碟爆滿、核心崩潰分析 |
| [13 - 自動化與其他管理議題](13-自動化與其他管理議題.md) | Ansible、cloud-init、容器、虛擬化、系統升級、Cockpit |
| [14 - UEFI 進階](14-UEFI進階.md) | ESP / NVRAM 開機項、Secure Boot 信任鏈與 MOK、shim / GRUB / systemd-boot、BLS、UKI、TPM 量測開機、fwupd、UEFI 故障排除 |
| [15 - LVM 進階](15-LVM進階.md) | 內部結構、RAID LV、Thin Provisioning、快取、pvmove / vgsplit / vgexport、metadata 還原、devices file、災難修復 |
| [16 - SELinux 進階](16-SELinux進階.md) | 標籤模型、targeted 政策結構、sesearch / seinfo 查詢、AVC 除錯流程、自訂模組（.te / CIL / refpolicy 巨集）、sepolicy generate、容器與 MCS、confined users、標籤進階、運維 |
| [17 - 故障排查情境演練](17-故障排查情境演練.md) | 20 個從告警 / 回報出發的情境：排查思路與順序、實測輸出、根因、修復、預防；15 個附可注入故障的練習腳本 |
| [附錄 A - 常用指令與語法說明](A-常用指令與語法說明.md) | `tee` 與 `sudo tee`、heredoc（`<<'EOF'`）、重新導向、`$( )`、`\|\| true`、`install`、`sed` 等手冊常用寫法 |
| [附錄 B - 名詞總表](B-名詞總表.md) | 全書「名詞與關係」定義的自動彙整索引（名詞 → 一句話定義 → 定義與關係所在章節） |

所有腳本集中在 [`scripts/`](scripts/) 目錄，皆已於 Ubuntu 24.04 與 Fedora 44 實測；完整測試矩陣與實測修正見 [VERIFICATION.md](VERIFICATION.md)。

| 路徑 | 內容 |
|---|---|
| `scripts/bootstrap.sh` | 雙發行版初始化腳本（02 章） |
| `scripts/backup-restic.sh` | restic 備份腳本，含 LVM 快照與資料庫傾印（11 章） |
| `scripts/examples/` | 設計決策紀錄範本、systemd 單元 / timer、HA（keepalived、haproxy）、restic timer、Quadlet、Ansible、Kickstart / autoinstall、SELinux 政策範例 |
| `scripts/lab/` | 實驗環境：`setup-lab.sh`（容器）、`setup-vm.sh`（KVM 虛擬機）、Dockerfile、四支自動化測試腳本、`scenarios/` 故障注入腳本 |

## 驗證矩陣

驗證環境：Ubuntu 24.04.4 LTS 與 Fedora Linux 44（dnf5），以 systemd privileged 容器執行（建法見 [`scripts/lab/README.md`](scripts/lab/README.md)）；實測後修正的原稿錯誤清單見 [VERIFICATION.md](VERIFICATION.md)。

| 章節 | 驗證項目 | Ubuntu | Fedora |
|---|---|---|---|
| 01 | Kickstart `ksvalidator -v F44` | — | ✅ |
| 01 | autoinstall `cloud-init schema` + Subiquity JSON schema | ✅ | — |
| 02 | `scripts/bootstrap.sh`（更新、工具、時區、管理員、SSH 強化、防火牆、自動更新、chrony） | ✅ | ✅ |
| 02 | sshd drop-in 生效（`sshd -T`）、`ssh.socket` / `sshd.service` 差異 | ✅ | ✅ |
| 03 | deb822 第三方 repo（Docker）、`apt-mark hold`、`apt-file`、本機 .deb、`needrestart` | ✅ | — |
| 03 | `dnf config-manager addrepo`、RPM Fusion、COPR、`versionlock`、本機 .rpm、`history`、`needs-restarting`、Flatpak | — | ✅ |
| 04 | `myapp.service`（安全強化選項、cgroup 限制）、`backup.timer`、`systemd-run`、`systemd-analyze` | ✅ | ✅ |
| 04 | `useradd` 預設差異、umask、cron 套件 / 服務名、sysctl.d 預設 | ✅ | ✅ |
| 05 | Netplan bond / VLAN / bridge `netplan generate`；ufw 進階規則 | ✅ | — |
| 05 | `nmcli --offline` 靜態 / bond / VLAN / bridge；firewalld zone / rich rule / forward / 自訂 service / policy | — | ✅ |
| 06 | `scripts/lab/lab-storage-test.sh`：LVM 擴充 + 快照合併還原、ext4 縮放、RAID1、LUKS2、Btrfs、配額 | ✅ | ✅ |
| 06 | XFS 最小 300 MB、mdadm timer 名稱、smartd / mdadm 設定檔路徑 | ✅ | ✅ |
| 07 | journald drop-in、`vacuum`、rsyslog 自訂規則（含 Ubuntu `syslog` 使用者權限）、logrotate 設定與強制輪替 | ✅ | ✅ |
| 08 | fail2ban（systemd backend）、crypto-policies 子策略、faillock / pwquality 檔、certbot / AIDE timer、SCAP 內容、`grub2-setpassword`、`authselect` | ✅ | ✅ |
| 09 | tuned 安裝與 profile、THP / qdisc / max_map_count 預設、perf / bcc 套件名、I/O 排程器 udev 規則 | ✅ | ✅ |
| 10 | `haproxy -c`、`keepalived --config-test`（`scripts/examples/ha/`） | ✅ | ✅ |
| 11 | `scripts/backup-restic.sh` 備份 / 保留 / 抽樣檢查 / 還原比對；`restic-backup.timer` | ✅ | ✅ |
| 12 | `promtool check rules`、node_exporter / kdump / sos / lm_sensors 套件與 unit 名稱 | ✅ | ✅ |
| 13 | Ansible 跨發行版 playbook `--syntax-check` 與本機 `--check`（failed=0）；Quadlet `-dryrun`；虛擬化套件名 | ✅ | ✅ |
| 14 | shim / GRUB / systemd-boot / ukify / mokutil / efibootmgr / fwupd 套件、ESP 檔案路徑、BLS entry、`kernel-install` hook、UKI 套件（NVRAM 與 Secure Boot 狀態需實體韌體，未於容器驗證） | ✅ | ✅ |
| 15 | `scripts/lab/lab-lvm-advanced-test.sh`：striped、thin pool / thin 快照 / pool 擴充、pvmove、vgsplit / vgexport / vgimport / vgmerge、RAID1 LV、metadata 備份還原（含 thin `--force`）、devices file 差異（dm-cache 缺模組未測） | ✅ | ✅ |
| 16 | 政策查詢（`seinfo` / `sesearch` / `sepolicy` / `matchpathcon`）、`semanage` 離線修改、`audit2allow` / `audit2why -p`、`.te` 與 CIL 模組編譯 + `semodule` 安裝、refpolicy 巨集自訂 port type、`sepolicy generate` 骨架（enforcing 行為需真實核心，未於容器驗證） | —（AppArmor） | ✅ |
| 17 | `scripts/lab/scenarios/*.sh`：15 個情境 inject → status → solve 全流程（磁碟滿 / 埠衝突 / nginx 語法 / SSH 鎖死 / DNS / 綁定與防火牆 / cron / timer / OOM / 高負載 / 壞 repo / thin pool / sudo / journal 暴增 / fstab） | ✅ | ✅ |

## 閱讀建議

- **初學者**：依序閱讀 01 → 02 → 03 → 04 → 05 → 06 → 07。
- **要規劃一台新主機**：先讀 [00b 設計階段的需求考量](00b-設計階段的需求考量.md)，填好 `scripts/examples/design-record.md`，再依決策表跳到對應章節。
- **有 Ubuntu 經驗要接手 Fedora（或反之）**：先讀 [00 差異速查表](00-差異速查表.md)，再視需要查閱各章。
- **要上線的正式主機**：08、09、10、11 為必讀。

## 實驗環境建議

容器與虛擬機的準備方式統一見上方「建立實驗環境」。做危險操作前先快照（`setup-vm.sh snapshot`）；所有 ⚠️ 標記的操作請勿直接在正式主機執行。
