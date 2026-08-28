# Linux 系統管理完整手冊（Ubuntu & Fedora 雙發行版）

> 適用版本：**Ubuntu 24.04 LTS（Noble）/ 26.04 LTS** 與 **Fedora 42 以上（Workstation / Server）**。
> 兩者的指令在較新的版本大多向下相容；若有版本差異會在內文特別註明。

本手冊以「一套流程、兩種發行版」的方式撰寫：主要步驟共用，凡 Ubuntu 與 Fedora **做法不同之處**一律以下列標記呈現，方便對照。

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

所有腳本集中在 [`scripts/`](scripts/) 目錄，皆已於 Ubuntu 24.04 與 Fedora 44 實測；完整測試矩陣與實測修正見 [VERIFICATION.md](VERIFICATION.md)。

| 路徑 | 內容 |
|---|---|
| `scripts/bootstrap.sh` | 雙發行版初始化腳本（02 章） |
| `scripts/backup-restic.sh` | restic 備份腳本，含 LVM 快照與資料庫傾印（11 章） |
| `scripts/examples/` | systemd 單元 / timer、HA（keepalived、haproxy）、restic timer、Quadlet、Ansible、Kickstart / autoinstall 範例 |
| `scripts/lab/` | 建立驗證用 systemd 容器的 Dockerfile 與三支自動化測試腳本 |

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

## 閱讀建議

- **初學者**：依序閱讀 01 → 02 → 03 → 04 → 05 → 06 → 07。
- **有 Ubuntu 經驗要接手 Fedora（或反之）**：先讀 [00 差異速查表](00-差異速查表.md)，再視需要查閱各章。
- **要上線的正式主機**：08、09、10、11 為必讀。

## 實驗環境建議

建議在虛擬機（VirtualBox、virt-manager/KVM、VMware、Hyper-V、WSL2）上練習，並在每個重要步驟前建立快照。所有 ⚠️ 標記的操作請勿直接在正式主機執行。
