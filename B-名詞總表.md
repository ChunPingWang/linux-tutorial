# 附錄 B - 名詞總表

本表由各章「**名詞與關係**」段落中的定義自動彙整（依首次定義處收錄，同一名詞只列一次），按英文字母 / 中文排序。每列的「出處」連到定義該名詞、並說明它與相關名詞關係的章節；要理解名詞之間的關係，請點進出處看該節的關係圖與三欄表。

共 2016 個名詞。

| 名詞 | 一句話定義 | 出處 |
|---|---|---|
| `$EUID` / `>&2` | 有效使用者 ID（root 為 0）/ 把 stdout 改接到 stderr | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| `$fromhost-ip` | 訊息來源主機 IP 的屬性 | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| `$PrivDropToUser` | rsyslog 啟動後降權執行的設定（§1 的 PrivDrop） | [07-日誌管理](07-日誌管理.md) · 3.2 自訂規則範例 |
| `$releasever` | 🔵 dnf 的變數，展開為目前 Fedora 版本號，`.repo` 檔的 URL 用它組路徑 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🔵 Fedora：`dnf system-upgrade` |
| `$SSH_ORIGINAL_COMMAND` | 被 `command=` 強制執行的腳本內可讀到「客戶端原本要求的指令」的環境變數 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `-` 前綴 | 目的檔案前的 `-` 表示非同步寫入（不每筆 fsync） | [07-日誌管理](07-日誌管理.md) · 3.1 安裝與預設 |
| `--activationmode partial` | 允許在缺 PV 的情況下啟用 LV | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| `--allowerasing` / `--disablerepo` | 前者允許 dnf 移除阻礙交易的套件；後者本次不讀某個 repo | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🔵 Fedora：`dnf system-upgrade` |
| `--atomic` | 多顆磁碟的快照要嘛全部成功要嘛全部不做 | [11-備份與災難復原](11-備份與災難復原.md) · 6.4 虛擬機 / 雲端快照 |
| --batch / --clean | 不互動直接跑 / 遮蔽主機名、IP、密碼等敏感資訊 | [12-監控與故障排除](12-監控與故障排除.md) · 10. 收集診斷資訊給支援 / 事後分析 |
| `--bwlimit` / QoS | rclone 的頻寬上限 / 網路層的流量優先權 | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| `--delete` | 來源刪掉的檔案在目標也刪掉，讓目標與來源完全一致 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| `--devicesfile ""` | 單次指令忽略 devices file | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| `--extract` | 從政策庫把已安裝模組取回成 `.pp` | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `--nogpgcheck` | 🔵 本次交易略過金鑰驗簽 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| `--numeric-ids` | 以 UID / GID 數字而非名稱比對擁有者 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| `--privileged` | Podman / Docker 旗標：關掉 SELinux 標籤、capability、seccomp、裝置等全部隔離 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| `--reload` | 丟棄 runtime、從 permanent 重新載入 | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| `--restorefile` | 告訴 `pvcreate` 依這份 metadata 的 PE 佈局來設 `pe_start` | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| `--syncaction check / repair` | 讀所有副本比對（check）/ 不一致時修正（repair） | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| `--uncache` / `--splitcache` | 移除快取並丟棄 lv_fast / 分離但保留 lv_fast | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| `--vacuum-*` / `--rotate` | 立刻依大小 / 時間 / 檔數刪除舊 journal 檔 / 立刻切檔 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| `-a` / `-H` / `-A` / `-X` | `-a` 保留權限、時間、擁有者等基本屬性；`-H` 保留 hardlink；`-A` 保留 ACL；`-X` 保留擴充屬性（xattr） | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| `-d` / `-e` / `-r` | 停用（保留檔案）/ 啟用 / 移除 | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `-d`（devel release） | 允許升到開發中版本、或尚未開放提示的版本 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🟠 Ubuntu：`do-release-upgrade` |
| `-e 2` / `-b` / `-f` | 鎖定規則（改需重開機）/ 核心事件佇列大小 / 佇列滿時的行為（1 印警告、2 panic） | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| `-i`（stripes） | 資料條帶數 | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| `-m`（mirrors） | 額外副本數：`-m 1` = 總共兩份 | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| `-n` / `-B` | `-n` 只寫進政策庫不重建；`-B` 重建並載入 policy.35 | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `-p policy.35` | 指定要查的政策檔，而不是目前核心載入的那份 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| `-p`（parent，增量） | 只送與父快照之間的差異 | [11-備份與災難復原](11-備份與災難復原.md) · 6.2 Btrfs 快照（🔵 Fedora Workstation 預設） |
| `-x` | 不跨越檔案系統邊界 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| `.` / `source` | 在**目前** shell 內逐行執行檔案，不開子 shell | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| `./configure --prefix` / `make install` | autotools 的標準三步：`configure` 檢查環境並產生 Makefile，`--prefix` 決定安裝根目錄；`make` 編譯；`make install` 把成品複製到 prefix 下 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| `.1` 點釋出 | 🟠 LTS 首版發布約 3～4 個月後的第一次整合更新（如 24.04.1） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 9. 發行版大版本升級 |
| `.container` 檔 | 放在 `/etc/containers/systemd/`（rootless 為 `~/.config/containers/systemd/`）的 ini 檔，`[Container]` 段描述映像、埠、volume，其餘段落就是一般 systemd unit | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.2 Quadlet（Podman 4.4+，兩者皆可） |
| `.deb` / `.rpm` | 兩家族的套件檔格式：一個壓縮檔加上 metadata（名稱、版本、相依、安裝腳本） | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| `.dpkg-dist` / `.dpkg-old` | 🟠 dpkg 遇到「你改過、新版也改了」的設定檔時，保留你的版本、把新版存成 `.dpkg-dist`；反之則舊版存成 `.dpkg-old` | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| `.fc` | File Contexts：本模組的「路徑 regex → 標籤」表 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `.if` | Interface：本模組對外提供的巨集（例如 `myapp_read_config()`），讓別的模組引用 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `.linux` / `.initrd` / `.cmdline` / `.osrel` 區段 | PE 檔內的四個區段，各放一樣東西 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| `.mod` / `.pp` | `.mod` 是 checkmodule 編出的中間物；`.pp`（Policy Package）把 `.mod` 與 `.fc` 打包成單一可安裝檔 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `.repo` INI | 🔵 `/etc/yum.repos.d/` 下、以 `[repoid]` 開頭再列 `name= / baseurl= / metalink= / enabled= / gpgcheck= / gpgkey=` 的定義檔，一個檔可含多個 repo | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| `.rpmnew` / `.rpmsave` | 升級時若設定檔曾被管理員改過：rpm 通常把新版另存為 `.rpmnew`、保留你的；若套件要求必須用新版，則把你的改名 `.rpmsave` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🔵 Fedora：`dnf system-upgrade` |
| `.rpmnew` / `.rpmsave`、`rpmconf` | 🔵 rpm 的同一機制：新版存 `.rpmnew`、舊版存 `.rpmsave`；`rpmconf -a` 逐一互動合併 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| `.rpmsave` | 🔵 rpm 在移除或升級套件、發現設定檔曾被管理員修改時，把舊檔改名保留的副檔名 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| `.spec` / rpmbuild | 🔵 `.spec` 是描述「怎麼取得原始碼、編譯、安裝、列出檔案」的 RPM 打包腳本；`rpmbuild -ba` 依它產出 `.rpm`；`rpmdev-setuptree` 建立 `~/rpmbuild/` 的標準目錄 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| `.te` | Type Enforcement 原始碼：宣告 type、寫 allow / 轉換規則 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `.te` / `.fc` / `.if` / `.sh` / `.spec` | 規則 / 路徑標籤 / 介面 / 一鍵編譯安裝腳本 / RPM 打包規格 | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| `/.autorelabel` | 🔵 SELinux 的旗標檔：存在時下次開機重新標記整個檔案系統 | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `/.autorelabel` / `fixfiles -F onboot` | 全盤重標的兩種觸發方式（效果相同） | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| `/boot` | 存放 `vmlinuz`、initramfs、GRUB 檔案的分割區或目錄，常只有 1 GB | [04-系統管理](04-系統管理.md) · 5.1 核心版本與套件 |
| `/boot/loader/entries/` | 存放 entry 檔的目錄；檔名為 `<machine-id>-<version>.conf` | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| `/dev/mem` | 直接映射實體記憶體的裝置檔 | [08-安全強化](08-安全強化.md) · 6.4 開機安全 |
| `/dev/null` | 寫入即丟棄、讀取即立刻結束（EOF）的特殊裝置檔 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 2. 重新導向與管線 |
| `/etc/aliases` | 本機帳號到實際信箱的轉寄表（例如 `root: ops@example.com`） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| `/etc/apt/keyrings/` | 🟠 24.04 慣例存放第三方金鑰檔（`.asc` / `.gpg`）的目錄，只有被 `.sources` 的 `Signed-By` 指到的才會被用 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.2 新增第三方套件庫（以 Docker 為例，已實測） |
| `/etc/cron.d/` | 套件放自己排程的目錄，格式同 `/etc/crontab`（含使用者欄） | [04-系統管理](04-系統管理.md) · 4.1 cron |
| `/etc/cron.{hourly,…}/` 與 `run-parts` | 把腳本丟進目錄就按週期執行；`run-parts` 負責逐一執行且忽略含 `.` 的檔名 | [04-系統管理](04-系統管理.md) · 4.1 cron |
| `/etc/crypttab` | 開機時要解鎖哪些 LUKS 裝置的清單（名稱、UUID、金鑰來源、選項） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| `/etc/default/` / `/etc/sysconfig/` | 服務啟動時讀取的環境變數檔目錄（家族慣例） | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `/etc/default/grub` | 產生 GRUB 設定的「來源」變數檔 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `/etc/default/useradd` | `useradd` 的預設 shell、家目錄根、到期日 | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| `/etc/exports` | 伺服器端「哪個目錄分享給哪些網段、什麼選項」的清單 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| `/etc/fstab` | 開機時要掛哪些檔案系統、掛哪裡、用什麼選項的清單 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| `/etc/fwupd/remotes.d/` | fwupd 的更新來源設定 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| `/etc/grub.d/` | 一組腳本，`grub-mkconfig` 依序執行它們把輸出串成 grub.cfg：`10_linux` 掃核心、`30_uefi-firmware` 加「進 UEFI 設定」項、`35_fwupd` 加韌體更新項、`25_bli` 寫 Boot Loader Interface 變數 | [14-UEFI進階](14-UEFI進階.md) · 5.1 GRUB2（兩者預設） |
| `/etc/hostname` | 靜態主機名的存放檔，開機時由 systemd 讀入核心 | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| `/etc/hosts` | 本機的靜態「名稱 → IP」對照表；解析順序（`/etc/nsswitch.conf` 的 `hosts: files dns`）排在 DNS 之前 | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| `/etc/kernel/install.conf` 的 `layout=` | 告訴 `kernel-install` 核心要放哪：`bls` 放 `$BOOT/<machine-id>/<version>/` 並寫 Type #1 entry；`uki` 產 UKI | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| `/etc/login.defs` | shadow-utils 的帳號預設值檔（`PASS_MAX_DAYS`、`PASS_WARN_AGE`、UID 範圍等） | [02-初始設定](02-初始設定.md) · 3.4 密碼與帳號政策 |
| /etc/login.defs、chage | 前者是新帳號的密碼到期預設（`PASS_MAX_DAYS` 等），後者修改既有帳號 | [08-安全強化](08-安全強化.md) · 2.1 密碼政策 |
| `/etc/lvm/archive/<vg>_NNNNN-*.vg` | 每次變更「前」的 metadata 副本，帶流水號與描述 | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| `/etc/lvm/archive/`、`/etc/lvm/backup/` | LVM 在每次變更 metadata 前 / 後自動存下的副本 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.6 其他 |
| `/etc/lvm/backup/<vg>` | 每次變更「後」最新的 metadata 副本 | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| `/etc/lvm/lvmlocal.conf` | 本機覆寫設定檔 | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| `/etc/modprobe.d/` | 核心模組載入參數與黑名單（blacklist）設定目錄 | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| `/etc/modprobe.d/` 與 `install <模組> /bin/false` | modprobe 的設定目錄；`install` 行把「載入某模組」替換成執行指定指令 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| `/etc/modprobe.d/`：`blacklist` | 禁止 udev 依硬體 ID 自動載入某模組 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| `/etc/modprobe.d/`：`options` | 載入模組時附帶的參數 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| `/etc/modules-load.d/` | 開機時「一定要載入」的模組清單，由 `systemd-modules-load.service` 處理 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| `/etc/motd`、`/etc/motd.d/` | 靜態 MOTD 檔，內容原樣顯示（⚪ 兩邊都支援；🔵 Fedora 只有這種） | [02-初始設定](02-初始設定.md) · 9.2 登入橫幅與 MOTD |
| `/etc/os-release` | systemd 定義的發行版識別檔（`ID`、`VERSION_ID`、`VERSION_CODENAME`） | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| `/etc/pki/` | Red Hat 家族集中放憑證與金鑰（Public Key Infrastructure）的目錄 | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| `/etc/profile.d/` | 登入 shell 啟動時逐一讀取的腳本目錄 | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| `/etc/profile.d/*.sh` | `/etc/profile` 末尾會逐一 source 的目錄，兩邊路徑相同 | [02-初始設定](02-初始設定.md) · 9.4 Shell 環境 |
| `/etc/rsyslog.conf` vs `/etc/rsyslog.d/` | 主檔與擴充目錄；主檔用 `include()` / `$IncludeConfig` 依檔名序載入目錄 | [07-日誌管理](07-日誌管理.md) · 3.1 安裝與預設 |
| `/etc/selinux/config` | 開機時讀的總開關：`SELINUX=` 決定 enforcing / permissive / disabled，`SELINUXTYPE=` 決定載入 targeted 還是 mls 政策 | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| `/etc/skel` | 新帳號家目錄的範本目錄（`.bashrc`、`.profile` 等） | [02-初始設定](02-初始設定.md) · 3.1 建立管理員帳號 |
| `/etc/skel/` | 新帳號家目錄的範本（`.bashrc`、`.profile`） | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| `/etc/sudoers.d/` | 主檔以 `@includedir` 載入的目錄，每個檔案是一段獨立規則；檔名含 `.` 或 `~` 的會被忽略 | [02-初始設定](02-初始設定.md) · 3.2 sudo 規則 |
| `/etc/sysctl.d/`、`/usr/lib/sysctl.d/`、`/run/sysctl.d/` | 永久設定的三層目錄：管理員 / 發行版 / 執行期，同檔名時 `/etc` 優先，再依檔名字母序套用 | [04-系統管理](04-系統管理.md) · 5.5 sysctl 核心參數 |
| `/etc/update-motd.d/` | 🟠 Ubuntu 的動態 MOTD：目錄內每個可執行腳本的輸出串接成 MOTD，登入時即時產生 | [02-初始設定](02-初始設定.md) · 9.2 登入橫幅與 MOTD |
| `/forcefsck` / `fsck.mode=force` | 強制下次開機做完整 fsck 的旗標檔 / 核心參數 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.3 檢查與修復 |
| /healthz（存活） | 只回答「程序還活著嗎」，不檢查外部依賴 | [10-高可用設計](10-高可用設計.md) · 7.1 應用無狀態化 |
| /metrics 與 scrape | `/metrics` 是 exporter 的純文字輸出端點；scrape 是 Prometheus 依 `scrape_interval` 抓一次的動作 | [12-監控與故障排除](12-監控與故障排除.md) · 1.1 node_exporter（主機指標） |
| `/opt` 與 `/usr/local` | FHS（檔案系統階層標準）保留給「非套件管理員管理」軟體的目錄：`/opt/<軟體名>` 放整包自含軟體，`/usr/local/bin` 放要進 PATH 的連結或自編程式 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| `/proc/cmdline` | 核心實際收到的參數 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `/proc/PID/` | 核心以虛擬檔案系統形式暴露的每個程序資訊 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| `/proc/sys/` | 核心參數的檔案介面，`net.ipv4.ip_forward` 對應 `/proc/sys/net/ipv4/ip_forward` | [04-系統管理](04-系統管理.md) · 5.5 sysctl 核心參數 |
| `/proc`、`/sys` | 核心以「假檔案」形式露出的執行期參數與狀態，寫入即生效、重開機即消失 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 1.4 tee 的其他實用場景 |
| /readyz（就緒） | 回答「現在能不能接請求」，可含依賴檢查 | [10-高可用設計](10-高可用設計.md) · 7.1 應用無狀態化 |
| `/root/anaconda-ks.cfg` | Anaconda 在每台裝好的機器上留下的「實際套用的 Kickstart」 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| `/var/backups/dpkg.status.*` | 🟠 每天自動備份的 dpkg 資料庫副本 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| `/var/log/syslog`、`auth.log` / `/var/log/messages`、`secure` | rsyslog 產生的文字日誌檔，兩家族命名不同 | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| `/var/run/reboot-required` | 🟠 套件的安裝腳本在升級 kernel 等關鍵套件後建立的旗標檔，`.pkgs` 列出是哪些套件觸發 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.2 判斷是否需要重開機 |
| `127.0.1.1` | Debian 系保留給「本機主機名」用的 loopback 位址，與 `127.0.0.1 localhost` 分開 | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| 169.254.x.x（link-local） | DHCP 拿不到位址時系統自動配的保底位址（APIPA） | [05-網路與防火牆](05-網路與防火牆.md) · 10. 網路除錯流程 |
| `20-ufw.conf` | 🟠 ufw 套件放的規則：把防火牆訊息分到 `/var/log/ufw.log` 並 `stop` | [07-日誌管理](07-日誌管理.md) · 3.1 安裝與預設 |
| `2>&1` | 「把 fd 2 複製成 fd 1 目前指向的目標」——複製的是當下的目標，不是綁定 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 2. 重新導向與管線 |
| 2FA / 雙因子 | 登入要同時提供兩種不同類別的證明：你知道的（密碼）、你擁有的（金鑰、手機）、你本身（生物特徵） | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| 3-2-1-1-0 | 「3 份、2 種媒體、1 份異地、1 份離線或不可變、0 還原錯誤」的備份守則 | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| 4Kn | 實體與邏輯磁區都是 4 KiB 的新式磁碟（相對於對外模擬 512 位元組的 512e） | [15-LVM進階](15-LVM進階.md) · 1.1 PE 大小與對齊 |
| `50-cloud-init.conf` | 🟠 雲端映像由 cloud-init 產生的 drop-in，常內含 `PasswordAuthentication yes` | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| 514 / 6514 | syslog 的標準埠：514 明文（UDP / TCP）、6514 syslog over TLS | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| 802.3ad ／ LACP | IEEE 標準的鏈路聚合協定：兩端協商後同時使用所有成員線，頻寬相加 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| 802.3ad（LACP）/ active-backup | bonding 的兩種模式：LACP 兩條線同時用但需交換器支援；active-backup 一用一備，任何交換器都行 | [10-高可用設計](10-高可用設計.md) · 7.3 網路層冗餘 |
| 9090 / firewalld 的 `cockpit` service | Cockpit 的預設 HTTPS 埠；firewalld 內建同名 service 定義（§6） | [02-初始設定](02-初始設定.md) · 9.3 Cockpit 網頁管理介面 |
| `_netdev` | 掛載選項：標記為網路裝置，等網路就緒才掛、關機時先卸 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| `_rimage_N` / `_rmeta_N` | RAID LV 的內部子 LV：第 N 個資料副本（image）/ 它的 RAID superblock（metadata） | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| `_TRANSPORT` | 訊息進入 journald 的途徑：`stdout`、`syslog`、`journal`、`kernel`、`audit` | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| `aa-genprof` | 互動式為新程式從零產生 profile | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| aa-genprof / aa-logprof | 互動式產生新 profile / 依日誌中的 DENIED 逐條問你要不要加進 profile | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| `aa-logprof` | AppArmor 的互動式工具：讀 `DENIED` 紀錄，逐條問你要不要加進 profile | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| `aa-status` | 🟠 顯示 AppArmor 已載入的 profile 與其模式 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| ab / wrk | HTTP 壓測工具：`ab` 單執行緒簡單，`wrk` 多執行緒可壓更高併發 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| abrt | 🔵 對應的 crash 攔截與回報工具 | [12-監控與故障排除](12-監控與故障排除.md) · 10. 收集診斷資訊給支援 / 事後分析 |
| abstractions / tunables / abi | 可 include 的共用規則片段（`base`、`nameservice` 等）/ 變數定義（`@{HOME}`）/ profile 語法版本宣告 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| ACL | 允許哪些 initiator IQN 登入的清單 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| ACL（Access Control List） | 在 ugo 之外，對「指定使用者 / 群組」逐一授權的擴充權限，存在檔案系統的擴充屬性裡 | [04-系統管理](04-系統管理.md) · 2.3 ACL（細緻權限） |
| ACME | Automatic Certificate Management Environment（RFC 8555）：自動申請憑證的協定 | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| action / banaction | action 是封鎖時要做的整套動作（封 + 寄信…），banaction 是其中「呼叫哪個防火牆」的那一項 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| `action(type="omfile" …)` | 用 omfile 模組把訊息寫到指定檔案的動作 | [07-日誌管理](07-日誌管理.md) · 3.2 自訂規則範例 |
| activation skip（`-K` / `--setactivationskip`） | LV 層級旗標：`vgchange -ay` 也跳過它，必須 `-K` 明確啟用 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| active-backup | bonding 的另一種 `mode`：同一時間只用一條線，斷線才切換 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| `add-apt-repository` | 🟠 把 PPA 的 `.sources` 檔與金鑰一次寫好並執行 `apt update` 的工具 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.3 社群套件庫：PPA vs COPR |
| `add_drivers+=` / `/etc/initramfs-tools/modules` | 兩邊「強制把某模組塞進 initramfs」的設定 | [04-系統管理](04-系統管理.md) · 5.3 initramfs |
| addon（`*.addon.efi` / `*.efi.extra.d/`） | 只含 `.cmdline`（或 devicetree）區段的小 PE 檔，簽過後放在 UKI 同名的 `.extra.d/` 目錄，stub 開機時合併進參數 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| adduser | 🟠 Debian 系的互動式包裝腳本：自動建家目錄、複製 `/etc/skel`、問密碼與姓名 | [02-初始設定](02-初始設定.md) · 3.1 建立管理員帳號 |
| `adduser` / `deluser` | 🟠 Debian 用 Perl 寫的互動式包裝，會問密碼、姓名並建家目錄 | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| advert_int | MASTER 送 VRRP 通告的間隔（秒） | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| agent forwarding（`ssh -A`） | 把本機 agent 的 socket 轉發到遠端主機，讓遠端的 `ssh` 也能請你的 agent 簽名 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| AIDE | Advanced Intrusion Detection Environment：把每個檔案的雜湊、權限、擁有者、inode 等記進資料庫，之後比對差異 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| air-gap（離線） | 平常物理上不連線的副本：拔掉的外接碟、磁帶、離線保管的媒體 | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| akmod / `ubuntu-drivers` | 🔵 akmods 在每次核心升級後自動重編第三方模組；🟠 `ubuntu-drivers` 偵測硬體並安裝 Canonical 打包好的驅動 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| akmods | 🔵 RPM Fusion 的對應機制：`akmod-*` 套件在開機或核心更新時自動編出 `kmod-*` 並簽署 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| akmods / DKMS | 🔵 / 🟠 在核心更新後自動重編第三方模組的機制 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| Alertmanager | 接收 Prometheus 送來的告警，做去重、分組、靜音與路由到通知管道 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| `allow` | chrony.conf 指令，開放哪些網段可以向本機查詢時間 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 5. 時間服務：當 NTP 伺服器 |
| `allow-pw: false` | 把裝好的 sshd 直接設為拒絕密碼登入 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| AllowedIPs | 該 peer 「允許」的 IP 範圍：出站時當路由表（去這些位址就走這個 peer），入站時當過濾器（來源不在範圍就丟） | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| AllowGroups / Match | 白名單群組；條件式覆寫 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| alternatives | 🟠 `update-alternatives` / 🔵 `alternatives`：以符號連結管理「同一個指令名有多個實作」的機制（`/usr/bin/java` → `/etc/alternatives/java` → 實際版本） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| Anaconda | Fedora / RHEL 的安裝程式（§1.1）：Server 為傳統 GTK 介面，Workstation 42 起改為 Web UI | [01-系統安裝](01-系統安裝.md) · 4. 🔵 Fedora 44 互動式安裝（Anaconda） |
| Anaconda Security Profile | 🔵 Fedora / RHEL 安裝程式內建的選項（Kickstart `%addon org_fedora_oscap`），安裝時就套用一個 SSG profile | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| Anaconda Web UI | Anaconda 的新前端：用瀏覽器技術（與 Cockpit 同一套元件）實作的精靈式流程 | [01-系統安裝](01-系統安裝.md) · 4.2 🔵 Fedora Workstation |
| anacron | cron 的補跑機制：機器沒開時錯過的每日 / 每週工作在開機後補跑 | [04-系統管理](04-系統管理.md) · 4. 排程：cron、at 與 timer |
| anacron / `/etc/anacrontab` | 以「天」為單位的排程器，記錄上次執行日期，開機後補跑錯過的 | [04-系統管理](04-系統管理.md) · 4.1 cron |
| Ansible | 以 SSH 推送設定的自動化工具（13 章） | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| Ansible / ansible-core | Red Hat 維護的設定管理工具；`ansible-core` 是執行引擎加內建 module，`ansible` 套件則是 core 再加一大包 collection | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| Ansible `ansible.posix.selinux` / `seboolean` / `community.general.sefcontext` / `seport` / `selogin` | 分別對應 config 模式 / setsebool / semanage fcontext / semanage port / semanage login 的模組 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| Ansible playbook | 以 YAML 描述整台機器該有的狀態並自動套用（13 章） | [11-備份與災難復原](11-備份與災難復原.md) · 8.3 手動重建流程（無映像時） |
| AppArmor | 🟠 Ubuntu / SUSE 採用的 MAC，以路徑為單位（path-based） | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| AppArmor / profile | 🟠 以**程式路徑**為單位的 MAC；每個受管程式一個 profile，寫明它能存取哪些路徑、能力 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| AppArmor profile / enforce / complain | 以「程式路徑」為單位的規則檔（`/etc/apparmor.d/`）；enforce 擋、complain 只記錄 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| AppArmor vs SELinux | 🟠 / 🔵 各自的強制存取控制系統：AppArmor 依路徑寫規則，SELinux 依標籤 | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| apparmor-utils / apparmor-profiles(-extra) | 前者是 `aa-*` 管理工具套件，後者是社群維護的現成 profile 集（nginx、php-fpm、dovecot…） | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| apparmor_parser | 把 profile 文字編譯並載入核心的底層工具 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| AppImage | 把應用與所有函式庫打成單一可執行檔的格式，執行時用 FUSE 把自身掛載成檔案系統 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| application profile | `/etc/ufw/applications.d/` 內的服務定義（名稱 → 埠與協定），如 `OpenSSH` | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| apport / ubuntu-bug | 🟠 桌面 crash 攔截器（寫 `/var/crash/*.crash`）/ 向 Launchpad 回報的指令 | [12-監控與故障排除](12-監控與故障排除.md) · 10. 收集診斷資訊給支援 / 事後分析 |
| `apt` / `dnf` | 高階工具：讀套件庫索引、計算相依、下載後交給低階工具 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| `apt autoremove --purge` / `apt-mark hold` | 前者移除不再需要的套件（含舊核心，保留目前與前一版）；後者鎖住某套件不被移除或升級 | [04-系統管理](04-系統管理.md) · 5.1 核心版本與套件 |
| `apt full-upgrade` | 更新所有套件，且允許為了解決相依而移除或新增套件（`apt upgrade` 不會） | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| `apt-cache madison` / `dnf list --showduplicates` | 列出套件庫索引（§1 的 metadata）裡該套件所有可安裝版本的查詢指令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.6 只安裝特定版本 |
| apt-daily.timer / apt-daily-upgrade.timer | 🟠 兩個 systemd timer：前者下載套件清單與更新檔，後者實際安裝 | [08-安全強化](08-安全強化.md) · 1.1 自動安全更新 |
| `apt-key` | 🟠 舊的金鑰管理指令，把金鑰加進 `/etc/apt/trusted.gpg`——所有來源共用的「全域信任」keyring | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.2 新增第三方套件庫（以 Docker 為例，已實測） |
| apt-mark hold / dnf versionlock | 鎖住套件版本不讓它升級 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| `archive { retain_days / retain_min }` | lvm.conf：archive 保留天數 / 最少份數 | [15-LVM進階](15-LVM進階.md) · 9. 監控、效能與 dmeventd |
| archive（封存，`::name`） | 一次 `create` 產生的時間點，相當於 restic 的 snapshot | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| `ashift` | pool 建立時固定的實體區塊大小指數（12 = 4 KiB） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.5 ZFS（🟠 Ubuntu 原生支援） |
| at | 一次性排程：在某個時間點跑一次就丟 | [04-系統管理](04-系統管理.md) · 4. 排程：cron、at 與 timer |
| attribute | 一群 type 的集合名（`domain`、`httpdcontent`、`port_type`…），規則寫在 attribute 上即一次套用給所有成員 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| attribute `port_type` | 所有埠 type 的集合 | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| `audispd-plugins` | auditd 的事件分派外掛，可把事件同步轉給 syslog、遠端 auditd 或 IDS | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| audit backlog / `-b` / `audit_backlog_limit=` | 核心暫存尚未被 auditd 取走的事件佇列 / 規則檔的設定 / 開機參數版（在 auditd 啟動前就生效） | [07-日誌管理](07-日誌管理.md) · 9. 日誌相關故障排除 |
| audit 子系統 | 核心內建的事件記錄機制，掛在系統呼叫與檔案存取路徑上 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| audit 規則 | `-w 路徑 -p 權限`：監看檔案（watch）；`-a always,exit -S 系統呼叫`：監看系統呼叫；`-k` 給規則一個 key 方便查詢 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| `audit2allow -M x && semodule -i x.pp` 全裝 | 可能放行攻擊、開過大權限 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| `audit2allow -R` | 產生規則時優先翻成 refpolicy 巨集（如 `sysnet_dns_name_resolve(myapp_t)`）而非原始 allow | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| audit2allow / semodule / .te / .pp | 把 AVC 反推成放行規則（`.te` 原始碼）並編成 `.pp` 模組 / 載入、列出、移除模組 | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| `audit2why` | 讀 AVC，回答「被拒的原因是缺規則、標籤錯，還是某個 boolean 沒開」 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| audit2why / audit2allow | 都讀 AVC：前者解釋「為什麼被拒、哪個 boolean 能解」，後者把 AVC 翻成 allow 規則草稿 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| `auditctl` / `augenrules` / `rules.d` | `auditctl` 即時對核心下規則（重開機消失）；`augenrules` 把 `rules.d/*.rules` 合併成 `audit.rules` 並載入 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| auditd | 從核心接收 audit 事件並寫入 `/var/log/audit/audit.log` 的 daemon（🟠 套件 `auditd`、🔵 `audit`） | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| auditd / `audit` | Linux 核心稽核子系統的使用者端守護程式（套件名 🟠 `auditd`、🔵 `audit`） | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| auditd / audit.log | 核心稽核子系統的守護程式與其日誌檔（見 §8） | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| auditd / `audit.log` / `ausearch` | 稽核守護程序 / 它寫的檔 / 查詢工具（`-m` 事件類型、`-ts` 時間、`-c` 程式名、`-i` 轉可讀） | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| auditd / ausearch | auditd 是接收核心稽核事件、寫入 `/var/log/audit/audit.log` 的守護程序；ausearch 是查詢它的工具 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| auditd / AVC | 核心稽核子系統的使用者空間 daemon；AVC 是 SELinux 的拒絕紀錄，也走 audit 通道 | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| `auid` | audit UID：登入時就固定、之後 `su` / `sudo` 也不變的「原始登入者」 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| `aureport` | auditd 的報表工具：`-a` 只算 AVC，`--summary` 依 domain / type 彙總 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| `ausearch -m avc` | 從 audit 日誌撈出 SELinux 拒絕紀錄（AVC）的指令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| `ausearch` / `aureport` | 查詢事件（依 key、訊息類型、檔案、時間）/ 產生統計報表 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| ausearch / sealert / setroubleshoot / audit2why | 查 audit.log 的工具 / 把 AVC 翻成人話並給建議指令 / sealert 背後的守護程式 / 解釋「為什麼被拒、有無 boolean 可解」 | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| `auth.log` / journal | 認證相關事件的日誌：🟠 Ubuntu 寫 `/var/log/auth.log`，🔵 Fedora 只進 systemd journal（`journalctl _COMM=sudo`） | [02-初始設定](02-初始設定.md) · 3. 使用者與 sudo |
| `auth.log` / `secure` | 🟠 / 🔵 rsyslog 把 `auth`、`authpriv` facility 落地的檔案 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| AuthenticationMethods | sshd 設定：列出「必須依序全部通過」的認證方法，逗號分隔 | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| AuthenticationMethods / PasswordAuthentication / KbdInteractiveAuthentication | 使用者認證階段允許的方法 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| `AuthorizedKeysFile` / `AuthorizedKeysCommand` | sshd 全域選項：前者改公鑰檔的位置（可用 `%u` 代入帳號），後者改成呼叫外部程式取得公鑰 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| authselect | 🔵 Fedora 產生與管理 `/etc/pam.d/` 的工具：先選一個 profile（`local`、`sssd`…）再開關功能（`with-faillock`） | [08-安全強化](08-安全強化.md) · 2.1 密碼政策 |
| autoactivation | 開機（或裝置出現）時由 udev 事件觸發的自動啟用 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| autoextend（`thin_pool_autoextend_*`） | lvm.conf 設定：pool 用到某百分比就自動 `lvextend` 多少 | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| autoinstall | 🟠 Subiquity 的無人值守格式：一份 YAML，放在 cloud-init 的 `user-data` 檔內 `autoinstall:` 鍵之下 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| autoinstall / Kickstart | 無人值守安裝的答案檔：🟠 autoinstall 是 cloud-init 風格的 YAML；🔵 Kickstart 是 `.ks` 文字腳本 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| avahi（mDNS）/ cups / bluetooth / ModemManager | 區網服務探索（5353/udp）/ 列印（631）/ 藍牙 / 行動網路撥號 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| AVC | Access Vector Cache，SELinux 的存取決策快取；「AVC denied」就是 SELinux 拒絕紀錄 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| AVC / ausearch / sealert | AVC（Access Vector Cache）拒絕紀錄是 SELinux 擋人時寫進 audit.log 的那一行；`ausearch -m avc` 篩出來，`sealert` 進一步翻譯成「該開哪個 boolean / 該下哪條指令」 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| AVC 快取 / `cache_stats` | 核心把「domain–type–class → 允許的 permission」查詢結果快取起來；`/sys/fs/selinux/avc/cache_stats` 是它的計數器 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| AVC ／ `semanage port` | AVC 是 SELinux 的拒絕紀錄（`ausearch -m avc`）；`semanage port` 把某個埠標記給某類服務使用 | [05-網路與防火牆](05-網路與防火牆.md) · 10. 網路除錯流程 |
| `avcstat` | `libselinux-utils` 的工具，每秒印一次 cache_stats 的差值 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| await / %util / aqu-sz | `iostat -x` 的每次 I/O 平均延遲（ms）、裝置忙碌比例、平均佇列長度 | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| await / aqu-sz / %util | `iostat -x` 的三個磁碟指標：平均每次 I/O 等待毫秒數、平均佇列長度、裝置忙碌時間比例 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| back-ends | `/etc/crypto-policies/back-ends/` 內每個函式庫一份的實際設定檔 | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| backend | jail 取得日誌的方式：`systemd` 直接查 journald，`auto` / `pyinotify` / `polling` 讀文字檔 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| backports | 🟠 `noble-backports` 套件庫，提供較新版但未進主庫的套件 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 8. 多主機管理：Cockpit |
| backstore | target 上實際存資料的東西：區塊裝置、檔案或 RAM | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| backup server | 標記 `backup` 的 server 只在其他 server 全掛時才被使用 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| `BACKUP=NETFS` | rear 內建的 tar 備份方式，寫到網路檔案系統 | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| Bacula / Bareos / Amanda、Velero | 企業級主從式（C/S）備份系統，集中管理多主機與磁帶 / Velero 是 Kubernetes 專用備份工具 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| balance | 把資料在磁碟間或區塊群組間重新分配 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| balance（分配演算法） | `roundrobin` 輪流、`leastconn` 連線最少優先、`source` 依來源 IP 固定、`first` 先塞滿第一台 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| bantime / findtime / maxretry | 封多久 / 觀察窗口多長 / 窗口內允許幾次失敗 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| barrier | 檔案系統為保證日誌順序而下的「寫入屏障」（強制 flush） | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| BCC | BPF Compiler Collection：一組現成的 eBPF 觀測工具（Python 封裝） | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| `before.rules` ／ `user.rules` ／ `after.rules` | ufw 的三份 iptables-restore 格式檔，依序載入 | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| bind mount efivars | `mount --bind /sys/firmware/efi/efivars` 到 chroot 內同路徑 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| binlog | MariaDB / MySQL 的二進位日誌，記錄所有變更 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| binlog_format=ROW | 以「列的變更」而非 SQL 語句記錄，Galera 必須用這種格式 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| BIOS / UEFI / Secure Boot | 主機板韌體的兩代標準，以及 UEFI 的開機檔簽章驗證功能 | [01-系統安裝](01-系統安裝.md) · 1.4 硬體需求（實務建議） |
| BIOS（Legacy） | 1981 年起的 PC 韌體：16-bit、從磁碟第一個磁區（MBR）載入開機碼、不驗證任何東西 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| Blackbox exporter / probe / relabel | 黑箱探測 exporter（:9115）；`/probe?target=URL&module=http_2xx` 才是它的抓取端點；relabel 是把 Prometheus 設定裡的目標 URL 改寫成「抓 exporter、URL 當參數」的固定寫法 | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| Blackbox exporter / Uptime Kuma | 黑箱探測工具：前者是 Prometheus 生態的 exporter，後者是獨立、自帶介面與通知的工具 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| BlackLotus（2023） | 拿舊版有漏洞但簽章仍有效的 Windows bootloader 繞過 Secure Boot 的實戰 bootkit | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| Blivet-GUI | Anaconda 內建的進階儲存編輯器，以樹狀圖直接操作分割區 / LVM / Btrfs | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| blk-mq / nr_requests（queue depth） | 核心的多佇列區塊層；`nr_requests` 是每個佇列可暫存的請求數 | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| `blkid` / PARTLABEL | 列出分割的檔案系統類型、UUID、GPT 分割名稱 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| BLS / `grubby` | BLS（Boot Loader Specification）把每個核心的開機項存成獨立檔案；`grubby` 是編輯這些檔案與核心參數的工具 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| BLS / loader entries / grubby / kernel-install | Boot Loader Specification：每個核心一個 `/boot/loader/entries/*.conf`；`grubby` 改這些 entry 的參數，`kernel-install` 在裝核心時產生它們（§5.2） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| BLS Type #1 entry | freedesktop 規範的純文字開機項：`title` / `linux` / `initrd` / `options` 各一行，一個核心一個檔 | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| BLS（Boot Loader Specification） | systemd 提出的規範：每個核心一個純文字開機項檔，放在 `/boot/loader/entries/` | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| BMC / iDRAC / iLO | 伺服器的獨立管理控制器（Dell iDRAC、HPE iLO 都是 BMC 實作） | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| Bonding | 核心 bonding 模組：把多張網卡合成一個 `bondX` 介面，提供備援或頻寬疊加 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| boolean | 政策內預留的開關（`getsebool -a` 列出），例如 `httpd_can_network_connect` 允許 web 服務主動連外 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| boolean / 條件規則 | boolean 是政策內建的開關；條件規則是「boolean 為真時才生效」的 allow | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| Boot Loader Interface / `25_bli` | systemd 定義的一組 EFI 變數（`LoaderEntrySelected`、`LoaderDevicePartUUID` 等），讓 OS 知道自己是被哪個載入器、哪個 entry 開起來的 | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| Boot#### | 一個開機項：名稱 + 「哪顆磁碟的哪個 GPT 分割、分割內哪個路徑」（`HD(1,GPT,...)/File(\EFI\...)`） | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| Boot#### / BootOrder / BootNext | NVRAM 中的開機項變數：每個 `Boot####` 指向「哪顆磁碟的 ESP 裡的哪個檔」，`BootOrder` 是嘗試順序，`BootNext` 是下次一次性開機用哪個 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `bootctl` | 安裝 / 更新 systemd-boot 到 ESP、列出項目與狀態的工具 | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| BootCurrent | 這次實際是從哪個 Boot#### 開起來的 | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| BootHole（2020） | GRUB 解析 `grub.cfg` 時的緩衝區溢位：簽過的 GRUB 讀一份惡意設定檔就能執行任意碼 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| `bootia32.efi` / 32-bit UEFI | 32-bit UEFI 韌體（舊 Atom 平板）要的 IA32 版載入器 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| `bootloader --sdboot` | 🔵 Kickstart 的選項，讓 Anaconda 安裝 systemd-boot 而非 GRUB | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| BootNext | 只用一次的「下次開機用這個」，用完自動清除 | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| BootOrder | 韌體依序嘗試 Boot#### 的清單 | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| bootstrap / galera_new_cluster | 從零建立叢集（宣告「我是第一個節點」）的動作與指令 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| boot（`-b`） | journald 依每次開機的唯一 boot ID 分段 | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| `borg serve --append-only` | 在遠端 `authorized_keys` 限制客戶端只能新增不能刪 | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| borg（borgbackup） | 區塊級去重、加密、壓縮的備份工具，遠端只支援 SSH | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| bpftrace | 類 awk 語法的 eBPF 追蹤語言，適合臨時寫一行程式 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| Bridge | 核心的軟體交換器（L2 轉發），把多個介面接成同一個廣播網域 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| `btmp` / `lastb` | 失敗登入的二進位紀錄（`/var/log/btmp`）/ 讀它的指令 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| Btrfs | 新世代 copy-on-write 檔案系統，內建子卷、快照、透明壓縮、多碟 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| `build-dep` / `builddep` | 讀取「該套件打包時宣告的建置相依」並一次裝齊的子命令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| build-essential / development-tools | 🟠 `build-essential` 是一個 **metapackage**（本身沒有檔案，只靠相依把 gcc、g++、make、libc6-dev 拉進來的空套件）；🔵 對應的是 group（§3.4）`development-tools` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| C-state | CPU 閒置時的省電深度（C0 執行中、C1～C6 越深越省電、喚醒越慢） | [09-性能調校](09-性能調校.md) · 2. CPU |
| C-state / energy_perf_bias / min_perf_pct | profile `[cpu]` 區段常見的三個旋鈕：限制閒置深度、告訴 CPU 偏效能或省電、Intel P-state 的最低頻率百分比 | [09-性能調校](09-性能調校.md) · 7. tuned（🔵 Fedora 預設；🟠 Ubuntu 可安裝，已實測） |
| CA | Certificate Authority，簽發憑證的機構；瀏覽器與作業系統內建一份「信任的公開 CA 清單」 | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| CA bundle | 系統信任的根憑證集合檔，用來驗證 relay 的 TLS 憑證 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| cache_policy（smq） | 決定哪些區塊該進快取、哪些該淘汰的演算法 | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| cachemode `writethrough` / `writeback` | 寫入同時落 SSD 與 HDD 才回應 / 只落 SSD 就回應 | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| cachepool | 舊式做法：快取資料與 metadata 是兩個獨立 LV 組成的 pool | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| cachevol | 新式做法：一個普通 LV 同時放快取資料與快取 metadata | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| capsule | UEFI 韌體更新封裝（§9） | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| capsule（UEFI Capsule） | UEFI 規範的韌體更新封裝：OS 把它放進 ESP 並設變數，韌體在下次開機時讀取並刷寫 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| CA（Certificate Authority） | 一把專門用來簽憑證、平時離線保管的金鑰對 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| CDDL / GPL | ZFS 與 Linux 核心各自的開源授權，法律上不相容 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.5 ZFS（🟠 Ubuntu 原生支援） |
| CentOS Stream | RHEL 下一個小版本的滾動預覽版 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Ceph | 自我修復的分散式儲存，同一叢集同時提供區塊、檔案、物件三種介面 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| cephadm | Ceph 官方的部署工具，用容器跑每個 daemon | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| certbot | EFF 開發的 ACME 客戶端（Python），負責申請、安裝、續期憑證 | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| certbot.timer / certbot-renew.timer | 每天觸發 `certbot renew` 的 systemd timer（🟠 / 🔵 名稱不同） | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| cgroup | 核心的「控制群組」：把一群程序放進同一個資源帳戶，可統計與限制 CPU / 記憶體 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| cgroup v2 | 核心的「控制群組」第二版：把程序分組後對每組限制 CPU、記憶體、I/O、PID 數；統一成一棵樹（v1 是每種資源各一棵） | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| chage | 直接修改 `/etc/shadow` 內既有帳號的有效期欄位（`-M` 最長天數、`-W` 提前警告、`-l` 列出） | [02-初始設定](02-初始設定.md) · 3.4 密碼與帳號政策 |
| chain | table 內的規則序列；base chain 以 `type`＋`hook`＋`priority` 掛到核心，並有 `policy`（沒規則符合時的預設） | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| challenge（HTTP-01 / DNS-01） | ACME 驗證網域控制權的兩種方式 | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| `chattr` / `lsattr` | 設定與查看檔案系統層級的屬性（`i` 不可變、`a` 只能附加） | [04-系統管理](04-系統管理.md) · 2.2 檔案權限 |
| `chcon` | 直接改 xattr 的指令 | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| `chcon -R` 修標籤 | 下次 `restorecon` / 重標就消失 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| check / --read-data-subset | check 驗證 repo 結構完整；`--read-data-subset=10%` 抽樣實際讀回並驗證區塊 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| check mode（`--check --diff`） | 只比對、不修改的模擬執行；`--diff` 顯示會改的內容 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| checkinstall | 🟠 攔截 `make install` 寫入的檔案清單，順手打成可用 `apt remove` 移除的簡易 `.deb` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| `checklayout` | 比對目前磁碟佈局與上次做救援 ISO 時是否相同 | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| `checkmodule -M -m` | `-m` 表示編譯的是「模組」而非整套基礎政策；`-M` 啟用 MLS / MCS 欄位 | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `checkmodule` / `semodule_package` | 編譯 `.te` → `.mod` / 打包 `.mod`（+ `.fc`）→ `.pp` 的兩支工具（`checkpolicy`、`policycoreutils` 套件） | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| checksum 比對 | 用 sha256sum 等比對還原出的檔案與原檔是否一致 | [11-備份與災難復原](11-備份與災難復原.md) · 10.2 演練情境（至少每半年） |
| `chmod` / `chown` | 前者改權限位元，後者改擁有者與群組 | [04-系統管理](04-系統管理.md) · 2.2 檔案權限 |
| chrony / chronyd / chronyc | 兩個發行版預設的 NTP 實作：`chronyd` 是 daemon（既當 client 也能當 server），`chronyc` 是查詢與控制 CLI | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 5. 時間服務：當 NTP 伺服器 |
| chrony / timedatectl | NTP 客戶端 / 時間狀態查詢 | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| chrony（chronyd / chronyc） | 完整的 NTP 實作：`chronyd` 是 daemon，`chronyc` 是查詢與操作它的 CLI | [02-初始設定](02-初始設定.md) · 2.1 時間同步（NTP） |
| chroot | 把某個目錄當成根目錄執行指令 | [12-監控與故障排除](12-監控與故障排除.md) · 3.1 進入救援環境 |
| chrt / nice | `chrt` 設即時排程策略（FIFO / RR），`nice` 調一般程序的優先權 | [09-性能調校](09-性能調校.md) · 2. CPU |
| chunksize（傳統快照 `-c`） | COW 快照每次複製的單位 | [15-LVM進階](15-LVM進階.md) · 9. 監控、效能與 dmeventd |
| chunk（`--chunksize`） | pool 配置與快照差異追蹤的最小單位 | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| CIB | Cluster Information Base，叢集所有設定與狀態的 XML | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| cifs-utils / `mount -t cifs` | Linux 客戶端掛載 SMB 分享的工具與檔案系統類型名 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| CIL | Common Intermediate Language：新的原生政策語言，`semodule` 直接吃 `.cil` 不需編譯 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| cipher suite / CBC | 一次 TLS 連線用的整組演算法（金鑰交換 + 簽章 + 對稱加密 + 雜湊）/ 其中一種對稱加密模式 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| Cipher（Ciphers） | 通道的對稱加密演算法 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| CIS | Center for Internet Security，發布各作業系統安全設定基準（Benchmark）的組織 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| CIS / PCI-DSS / STIG | 三套安全基準：CIS Benchmark 是業界通用、PCI-DSS 是信用卡產業規範、STIG 是美國國防部標準 | [08-安全強化](08-安全強化.md) · 8. 稽核（auditd） |
| CIS / STIG | 兩套常見的伺服器合規基準；STIG 明文要求 confined users | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| CIS / STIG / PCI-DSS | 三套安全基準：CIS Benchmark（業界通用，分 Level 1 / 2）、DISA STIG（美國國防部）、PCI-DSS（信用卡產業） | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| ClamAV / freshclam / clamd | 開源防毒引擎 / 更新病毒庫的工具 / 常駐掃描守護程式 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| class / permission | class 是物件的種類（`file`、`dir`、`tcp_socket`、`process`…），permission 是該 class 上可做的動作（`read`、`name_connect`…） | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| clone / promotable | clone = 每個節點各跑一份；promotable（舊稱 master/slave）= 其中一份可被升級為 master | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| Clonezilla Live | 可開機的映像工具，能整碟或整分割區做映像，只複製有資料的區塊 | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| cloud-init | 雲端 / 虛擬機第一次開機時讀取 metadata 做初始設定（主機名、使用者、網路）的工具 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| cloud-init / NoCloud / seed ISO | §5、§5.1 定義的第一次開機設定機制與其本機資料源 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| `cloud-init schema` / JSON schema | 前者檢查 cloud-config 外層格式；後者是 Subiquity 公布的 autoinstall 欄位定義，用 Python `jsonschema` 套件比對 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| Cluster | Redis 內建的分片模式：資料依 hash slot 分散到多個主節點，每個主節點有自己的從節點 | [10-高可用設計](10-高可用設計.md) · 6.3 Redis / Valkey |
| CMDB | Configuration Management Database，集中記錄所有資產與其設定的資料庫 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| CN / SAN | Common Name（憑證主體欄位）/ Subject Alternative Name（列出所有適用主機名與 IP 的擴充欄位） | [08-安全強化](08-安全強化.md) · 9.2 內部 CA / 自簽 |
| Cockpit | Red Hat 主導的網頁式主機管理介面（服務、儲存、網路、終端機），監聽 9090 埠 | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| `cockpit.socket` | 用 §4.1 的 socket activation：systemd 代聽 9090，有人連線才啟動 `cockpit.service`（`cockpit-ws`） | [02-初始設定](02-初始設定.md) · 9.3 Cockpit 網頁管理介面 |
| collection | 以 `namespace.name` 命名的 module / role 打包單位（`community.general`、`ansible.posix`） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| collector | node_exporter 內部的模組，每個負責一類指標（cpu、filesystem、systemd、apt…） | [12-監控與故障排除](12-監控與故障排除.md) · 1.1 node_exporter（主機指標） |
| `comm` / `pid` / `name` / `dest` | 程式名、程序號、被碰的檔名、目的埠 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| `command -v` | bash 內建，查某指令是否存在並印出路徑，找不到時回傳非 0 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| Compose | 用一份 YAML 描述多容器應用的工具；Docker 為 `docker compose` plugin，Podman 用 `podman-compose` 或轉呼叫 docker-compose | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| `compress` / `delaycompress` | 壓縮舊檔 / 最新那份先不壓、下一輪才壓 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| `compress=zstd:1` | 掛載選項：以 zstd 等級 1 做透明壓縮 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| compression zstd,3 | 存入前壓縮，zstd 等級 3 在速度與壓縮率間取平衡 | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| `con mod` ／ `con up` | 修改 profile 內容／把 profile 套用到裝置 | [05-網路與防火牆](05-網路與防火牆.md) · 4. 🔵 Fedora：NetworkManager（nmcli） |
| `con reload` | 讓 NM 重新掃描 `system-connections/` 目錄，認出手動放進去的 keyfile | [05-網路與防火牆](05-網路與防火牆.md) · 4.2 靜態 IP / DHCP |
| confined domain | 有專屬 type、規則只涵蓋服務實際需要動作的 domain | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| connection profile | 一組完整的連線設定（IP、DNS、路由、Wi-Fi 密碼…），存成一個 keyfile，有自己的名字與 UUID | [05-網路與防火牆](05-網路與防火牆.md) · 4. 🔵 Fedora：NetworkManager（nmcli） |
| connection（nmcli） | NetworkManager 的一份設定，有自己的名稱，綁定某個介面 | [02-初始設定](02-初始設定.md) · 5. 網路基本設定（詳見第 05 章） |
| conntrack | netfilter 追蹤每條連線狀態的表，NAT 與狀態防火牆都靠它 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| constraint | 資源之間的規則：`order`（先後）、`colocation`（必須同節點或不同節點）、`location`（偏好節點） | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| container boolean（`container_manage_cgroup`、`container_use_devices`…） | `container-selinux` 內建的開關，放寬 `container_t` 的特定能力 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| `container_file_t` | 容器可讀寫的檔案 type；宿主機上只有標成它的目錄才能給容器用 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| `container_t` | 所有容器程序預設跑的 domain（`container-selinux` 套件提供） | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| context / label | 貼在每個程序、檔案、埠上的標籤，格式 `user:role:type:level`（如 `system_u:object_r:httpd_sys_content_t:s0`） | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| context / label（安全上下文 / 標籤） | 一串 `user:role:type:level` 字串；程序的記在核心，檔案的存在 inode 的擴充屬性（xattr `security.selinux`） | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| `context=` / `defcontext=` / `fscontext=` | 掛載選項：整個掛載點統一標籤 / 只給沒標籤的檔 / 給檔案系統本身（superblock） | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| COPR（Cool Other Package Repo） | 🔵 Fedora 專案提供的個人建置服務與套件庫，定位對應 PPA | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.3 社群套件庫：PPA vs COPR |
| copy-on-write（COW） | 快照不複製資料，只在原卷被改寫時才把舊區塊留一份給快照 | [11-備份與災難復原](11-備份與災難復原.md) · 6. 快照（一致性與快速回滾） |
| `copytruncate` | 不改名、改為複製一份再把原檔清空 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| `corenet_port(T)` | 宣告 T 是埠 type：掛上 `port_type` attribute，讓 `sesearch` / `semanage port` 認得它 | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| Corosync | 叢集通訊層：節點間心跳、成員關係與 quorum 投票（UDP 5404-5405） | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| counter ／ log | 規則上的計數器／把符合的封包寫進核心日誌（`journalctl -k`） | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| COW 檔案系統 | 不在原位覆寫，改寫時把新資料寫到新區塊再切換指標（與 §3.4 的 LVM 快照同一原理，但做在檔案系統層） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.1 選擇 |
| CoW（Copy-on-Write） | 寫入時不覆蓋原資料、而是寫到新位置再切換指標的策略 | [01-系統安裝](01-系統安裝.md) · 2.3 檔案系統選擇 |
| `cp` / `mv` / `cp --preserve=context` | 建新 inode / 搬同一個 inode / 建新 inode 但複製 xattr | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| CPU 親和性（affinity） | 把程序限制在指定核心上執行 | [09-性能調校](09-性能調校.md) · 2. CPU |
| cpupower | 操作 cpufreq 的命令列工具（🟠 在 `linux-tools-generic`、🔵 `kernel-tools`） | [09-性能調校](09-性能調校.md) · 2. CPU |
| cpupower / tuned-adm | 查 CPU 頻率與 governor / 查目前 tuned profile（09 章 §2、§7） | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| CPUQuota / CPUWeight | Quota 是絕對上限（200% = 兩顆核心），Weight 是與同層其他 cgroup 競爭時的相對比例（預設 100） | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| `Cpy%Sync` / `sync_percent` | 副本同步進度 | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| cramfs / freevxfs / jffs2 / hfs / hfsplus / udf | 冷門或嵌入式檔案系統模組 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| crash recovery | 資料庫或日誌式檔案系統在「非正常關機」後開機時的自我修復 | [11-備份與災難復原](11-備份與災難復原.md) · 6.4 虛擬機 / 雲端快照 |
| crash 工具 | 讀 vmcore 的互動式分析器（`bt` 呼叫堆疊、`log` 核心日誌、`ps` 程序） | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| crashkernel= | 核心參數，開機時預留一塊記憶體給捕捉核心 | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| `create` / `su` | 輪替後建立新空檔（指定權限與擁有者）/ 以指定使用者身分操作該目錄 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| cron | 傳統 Unix 排程 daemon，依 crontab 裡的「分 時 日 月 週」表達式定期執行指令 | [04-系統管理](04-系統管理.md) · 4. 排程：cron、at 與 timer |
| cron / cronie / systemd timer | cron 是傳統排程機制；`cron` 與 `cronie` 是同一功能的兩個實作套件；systemd timer 是 systemd 的排程單元 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| cron / MTA | cron 是傳統排程 daemon（§4.1）；MTA 是寄信程式（postfix、sendmail） | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| cron daemon（`cron` / `crond`） | 常駐程序，每分鐘檢查所有 crontab 並執行到期工作 | [04-系統管理](04-系統管理.md) · 4.1 cron |
| `cron.allow` / `cron.deny` | 允許 / 禁止使用 crontab 的使用者清單 | [04-系統管理](04-系統管理.md) · 4.1 cron |
| crontab | 既是「排程表檔案」也是編輯它的指令（`crontab -e`） | [04-系統管理](04-系統管理.md) · 4.1 cron |
| CrowdSec | 同類的開源替代品：多了社群共享的惡意 IP 情報（別人被打過的 IP 你先封） | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| crypto-policies | Red Hat 的系統級加密策略：一份設定同時套用到 SSH、TLS、Kerberos 等 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| cryptsetup | 操作 LUKS 的使用者空間工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| CSM / Legacy Boot | UEFI 內建的「模擬舊 BIOS」相容模式 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| ct（conntrack） | 核心的連線追蹤表，記錄每條連線的狀態：`new`、`established`、`related`、`invalid` | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| CUPS | Common Unix Printing System，兩邊共用的列印服務，Web 管理介面在 631 埠 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| curtin / `in-target` / `late-commands` | curtin 是 Subiquity 底層實際做分割與複製系統的引擎；`late-commands` 在安裝完成、重開前執行；`curtin in-target` 讓指令在新系統（`/target`）內執行 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| CVE | Common Vulnerabilities and Exposures，公開漏洞的統一編號 | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| D 狀態 | 程序等待 I/O 完成時的不可中斷睡眠狀態（`ps` 的 STAT 欄 `D`） | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| D 狀態 / wchan | 不可中斷睡眠（等 I/O 或驅動）；`wchan` 欄顯示它在核心的哪個函式裡等 | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| DAC | 傳統 Unix 權限：檔案擁有者自行決定（discretionary）誰能讀寫，root 不受限 | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| DAC / MAC | DAC（Discretionary）是檔案擁有者自己決定的 rwx 權限；MAC（Mandatory）是系統政策強制、擁有者也改不了的規則 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| daemon / socket | daemon 是常駐背景程序；`/var/run/docker.sock` 是 CLI 與它溝通的 Unix socket | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| daemon-reload | 要求 systemd 重新讀取磁碟上所有單元檔與 drop-in | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| `daemon.json` | Docker daemon 的設定檔（`/etc/docker/daemon.json`） | [07-日誌管理](07-日誌管理.md) · 7. 應用程式日誌慣例 |
| Data% / Meta% | `lvs` 顯示 pool 的資料區 / metadata 區使用率 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.5 Thin Provisioning |
| data=writeback / nodatacow | ext4 的 `data=writeback` 讓資料不經日誌只記中繼資料；Btrfs 的 `nodatacow` 關掉寫入時複製 | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| dataset | pool 內的檔案系統（或 zvol 區塊裝置），可各自設壓縮、配額、掛載點 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.5 ZFS（🟠 Ubuntu 原生支援） |
| datasource | cloud-init 取得設定資料的來源：雲端平台的 metadata 服務（AWS、GCP、OpenStack…）或本機的 NoCloud | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| `dateext` | 輪替後檔名加日期（`-20260829`）而非序號 `.1` | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| dbx | hash / 憑證撤銷清單（§4.1） | [14-UEFI進階](14-UEFI進階.md) · 4.4 Secure Boot 相關故障 |
| dbx（撤銷清單） | 已知有漏洞、即使簽章有效也不准執行的檔案 hash 或憑證清單 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| db（允許清單） | 韌體信任的憑證與 hash 清單；PC 上幾乎只有 Microsoft Windows CA 與 Microsoft UEFI CA（第三方 CA） | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| DCCP / SCTP / RDS / TIPC | 四個冷門傳輸層協定（資料報壅塞控制 / 串流控制傳輸 / 可靠資料報 / 叢集透明 IPC） | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| DCS / etcd | Distributed Configuration Store：Patroni 存放叢集狀態與 leader lease 的地方；etcd 是最常用的實作（也可 Consul / ZooKeeper） | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| `dd` | 逐位元組把輸入複製到輸出裝置的工具，不看檔案系統、不問確認 | [01-系統安裝](01-系統安裝.md) · 1.3 製作開機 USB |
| dead-man switch | 「定期收到心跳才算正常，沒收到就告警」的反向監控 | [11-備份與災難復原](11-備份與災難復原.md) · 10.3 備份監控 |
| deadsnakes | 🟠 提供多版本 Python 的知名 PPA（§3.3） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| deb-src | 套件庫裡「原始碼套件」的通道，`Types: deb deb-src` 才會下載它的索引 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| deb822 | 🟠 Ubuntu 24.04 起的套件庫定義格式：一段多行「欄位: 值」（Types / URIs / Suites / Components / Signed-By），存於 `/etc/apt/sources.list.d/*.sources` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| Debian | 1993 年起的純社群發行版，以政策文件與 `.deb` 套件格式著稱 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Debian 工具鏈 | `.deb` 格式、`dpkg`（低階）/ `apt`（高階）、AppArmor、ufw；Canonical 再加上 Snap、Netplan、Livepatch、Landscape | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Debian 系 | 以 Debian 為上游的發行版家族（Ubuntu 等），apt / .deb、AppArmor | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| debsums / `rpm -V` | 用套件管理器內建的檔案 checksum 驗證已安裝檔案是否被改（🟠 / 🔵） | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| `debsums` / `rpm -Va` | 用套件資料庫記錄的 checksum 與權限，逐檔比對已安裝檔案有沒有被改動 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| debug symbol | 帶符號的核心映像（🟠 `-dbgsym` 來自 ddebs repo、🔵 `kernel-debuginfo`） | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| `DEFAULT_FORWARD_POLICY` | `/etc/default/ufw` 內，決定「經過本機轉送」的封包預設放行還是丟棄 | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| `default_t` / `unlabeled_t` | 「file_contexts 沒定義這條路徑」/「檔案根本沒 xattr」的兩個佔位 type | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| `default_t` / `unlabeled_t` / `unreserved_port_t` | 「file_contexts 沒定義這條路徑」/「檔案根本沒標籤」/「沒有任何服務認領的埠」三個佔位 type | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| Defaults | sudoers 內的全域選項行，改變 sudo 的行為而非授權 | [08-安全強化](08-安全強化.md) · 2.2 sudo 強化 |
| DENIED | 核心日誌（`journalctl -k`、`dmesg`）中 AppArmor 拒絕事件的關鍵字 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| deny vs reject | 都是擋，deny 靜默丟棄、reject 回 ICMP／TCP RST 告知對方 | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| Deployment replicas | Kubernetes 中同一應用要跑幾個 Pod 副本 | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| device | NM 眼中的網卡或虛擬介面（`nmcli device`） | [05-網路與防火牆](05-網路與防火牆.md) · 4. 🔵 Fedora：NetworkManager（nmcli） |
| device-mapper | 核心裡把「邏輯區塊 → 實體區塊」對應表變成裝置的框架 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3. LVM（Logical Volume Manager） |
| device-mapper（dm） | 核心把「邏輯區塊 → 實體區塊」對應表變成裝置的框架 | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| devices file（`/etc/lvm/devices/system.devices`） | lvm2 2.03.12+ 的白名單：只掃描檔中列出的裝置 | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| `df` vs `du` | 檔案系統層的已用空間 / 逐檔加總的空間 | [07-日誌管理](07-日誌管理.md) · 9. 日誌相關故障排除 |
| DHCP | 網卡開機時向網段上的 DHCP 伺服器租用 IP、閘道、DNS 的協定（`dhcp4: true`） | [05-網路與防火牆](05-網路與防火牆.md) · 3.2 靜態 IP / DHCP |
| DHCP / 租約 | 由伺服器動態配發 IP 的協定；配發的 IP 有「租約」期限，到期要續租，續不到或伺服器重啟後可能拿到不同 IP | [02-初始設定](02-初始設定.md) · 5. 網路基本設定（詳見第 05 章） |
| DHCP / 靜態 IP | DHCP 是由伺服器自動配發 IP 的協定；靜態 IP 則是手動寫死 | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| DHCP option 67 / option 93 | 67 是「開機檔名」；93 是客戶端回報的架構（BIOS 或 x64 UEFI 等） | [14-UEFI進階](14-UEFI進階.md) · 10. PXE / HTTP Boot 與網路安裝（UEFI 版） |
| DHCP（option 66 / 67） | 配發 IP 的協定（§3）；PXE 額外用 option 66（next-server）與 67（filename）告知去哪抓什麼 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| dig ／ nc ／ curl ／ mtr | 分別針對 DNS、TCP 埠、HTTP、逐跳延遲的探測工具 | [05-網路與防火牆](05-網路與防火牆.md) · 2. 共通的觀察指令（iproute2） |
| dirty blocks | writeback 模式下已在 SSD 但尚未回寫 HDD 的區塊 | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| discard / passdown | 檔案系統釋放區塊時通知 pool / pool 再把通知往下傳給底層 SSD | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| `distro-sync` | 🔵 把所有已裝套件強制對齊到目前啟用的 repo 所提供的版本，包含降版 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| Distrobox | 與 Toolbox 概念相同但支援任意發行版映像的社群工具，底層可用 Podman 或 Docker | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| DKMS | 隨核心更新自動重新編譯第三方模組的機制 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| DKMS / akmods | 在每次核心更新後自動重新編譯第三方模組的機制（🟠 DKMS、🔵 akmods） | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| DKMS 模組 | 隨 kernel 升級自動重新編譯的第三方核心模組（NVIDIA、ZFS，見 01 章 §1.5） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| dm-cache | device-mapper 的讀寫快取目標：把慢 LV 的熱區塊複製一份到快裝置 | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| dm-crypt | Linux 核心的透明區塊加密層（device-mapper 的 crypt 目標），對每個區塊即時加解密 | [01-系統安裝](01-系統安裝.md) · 2.4 全碟加密（LUKS） |
| dm-raid | device-mapper 的 RAID 目標模組，內部呼叫 md 的 RAID 引擎 | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| dm-writecache | device-mapper 的純寫入快取：寫入先落 SSD、背景回寫 HDD | [15-LVM進階](15-LVM進階.md) · 4. 快取（dm-cache / dm-writecache） |
| dmesg | 核心環形緩衝區（ring buffer）的訊息：硬體、驅動、OOM、I/O 錯誤 | [12-監控與故障排除](12-監控與故障排除.md) · 2. 故障排除方法論 |
| `dmesg` / 核心訊息 | 核心自己的環形緩衝區 | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| dmeventd | LVM 的 device-mapper 事件監控 daemon | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| DMI / SMBIOS、`dmidecode` | SMBIOS 是主機板韌體提供硬體資訊（型號、序號、記憶體插槽）的標準表，`dmidecode` 讀取它 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| dmidecode / lshw / lspci | 讀 SMBIOS 表 / 列硬體 / 列 PCI 裝置與綁定的驅動 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| `dmsetup` | 直接操作 device-mapper 表的工具 | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| dmstats | device-mapper 內建的分區段 I/O 統計 | [15-LVM進階](15-LVM進階.md) · 9. 監控、效能與 dmeventd |
| `dnf config-manager addrepo` | 🔵 dnf5 的 repo 管理子命令，`--from-repofile=URL` 直接抓廠商的 `.repo` 檔放進 `/etc/yum.repos.d/` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.2 新增第三方套件庫（以 Docker 為例，已實測） |
| `dnf history` / `selinux-policy` 升級 | 政策套件升級會重建 policy.35；自訂模組（400）保留但可能與新版規則衝突 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| `dnf needs-restarting` | 🔵 dnf 內建的對應功能：不帶參數列程序、`-r` 判斷是否需重開機、`-s` 只列 systemd 服務 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.2 判斷是否需要重開機 |
| `dnf needs-restarting -r` | 檢查是否有更新（含核心）需要重開機才生效 | [04-系統管理](04-系統管理.md) · 5.1 核心版本與套件 |
| `dnf swap` | 🔵 在同一筆交易內移除 A、安裝 B 的指令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.4 🔵 RPM Fusion（Fedora 必裝的第三方庫） |
| `dnf system-upgrade` | 🔵 dnf 插件：先把新版所有套件下載到本機，重開機進入極簡的離線環境套用，再開回新系統 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 9. 發行版大版本升級 |
| `dnf upgrade` | 🔵 更新所有套件的指令（等同 🟠 的 `apt full-upgrade`，預設就允許相依變動） | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| dnf-automatic.timer | 🔵 觸發 dnf5-plugin-automatic 的 systemd timer | [08-安全強化](08-安全強化.md) · 1.1 自動安全更新 |
| dnf-automatic（dnf5-plugin-automatic） | 🔵 dnf 的自動更新外掛，設定在 `/etc/dnf/automatic.conf`：`apply_updates` 決定「只下載」還是「真的安裝」，`upgrade_type` 決定 `default`（全部）還是 `security` | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| dnf5-plugin-automatic | 🔵 Fedora 的 dnf5 外掛，負責自動下載 / 安裝更新並發通知 | [08-安全強化](08-安全強化.md) · 1.1 自動安全更新 |
| DNS | 把主機名換成 IP 的網路查詢服務 | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| dnsmasq | 同時提供 DHCP、DNS、TFTP 的輕量服務，一個設定檔搞定 PXE 所需 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| dnsmasq ／ unbound | 本機自架的快取或遞迴 DNS 伺服器 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| DNSSEC | 驗證 DNS 回應簽章、防止被偽造的機制；`allow-downgrade` = 上游不支援就略過 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| `do-release-upgrade` | 🟠 Ubuntu 的升版工具：把 `.sources` 的 Suites 代號換成新版後，在**執行中的系統**上以 apt 把所有套件換掉 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 9. 發行版大版本升級 |
| Docker | 最早普及的容器引擎，所有容器由一個常駐的 `dockerd` daemon 統一建立與管理 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| Docker `"selinux-enabled": true` | Docker daemon 預設不打 SELinux 標籤，要在 `daemon.json` 開啟 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| Docker / Podman logging driver | 容器引擎收集容器 stdout 的方式：`json-file`（每容器一個 JSON 檔）、`journald`（寫進 journal） | [07-日誌管理](07-日誌管理.md) · 7. 應用程式日誌慣例 |
| `docker-default` | Docker / Podman 在 Ubuntu 上給每個容器套的預設 AppArmor profile | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| domain transition / `*_exec_t` | 程序執行一個標為 `xxx_exec_t` 的檔案時，依 `type_transition` 規則自動換到 `xxx_t` domain | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| dontaudit | 「拒絕但不寫 AVC」的規則，用來壓掉已知無害的雜訊 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| DoT（DNSOverTLS） | 與上游 DNS 改走 853 埠的 TLS 加密通道；`opportunistic` = 上游支援才用、不支援就退回明文 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| `dpkg --configure -a` | 🟠 把所有停在「已解開但未設定」的套件重新跑安裝腳本 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| `dpkg --set-selections` / `dselect-upgrade` | 匯入套件選擇狀態 / 依該狀態安裝 | [11-備份與災難復原](11-備份與災難復原.md) · 8.3 手動重建流程（無映像時） |
| `dpkg -L` / `rpm -ql` | 列出某套件安裝了哪些檔案 | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| `dpkg` / `rpm` | 低階工具：安裝、移除、查詢單一套件檔，並維護「已安裝」資料庫 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| `dpkg-deb` / `rpm -qlp` / `rpm2cpio` | 不安裝、只讀取或解開套件檔內容的工具：`dpkg-deb -c` 列檔案、`-x` 解到目錄；`rpm -qlp` 列檔案、`rpm2cpio` 轉成 cpio 封存再解開 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| `dracut` | 🔵 RHEL 上游主導的產生器：`dracut --force` 建、`lsinitrd` 看、設定在 `/etc/dracut.conf.d/` | [04-系統管理](04-系統管理.md) · 5.3 initramfs |
| dracut / `dracut.conf.d/` | 🔵 預設的產生器（🟠 亦可裝），模組化、原生支援 systemd、TPM2 與 `--uefi` 直接輸出 UKI | [14-UEFI進階](14-UEFI進階.md) · 6. initramfs 與 UEFI 相關設定 |
| dracut hostonly | 🔵 dracut 只打包本機硬體需要的模組進 initramfs 的模式 | [09-性能調校](09-性能調校.md) · 9. 開機與服務啟動時間 |
| DRBD | Distributed Replicated Block Device，把兩台主機的區塊裝置透過網路做成鏡像（「網路 RAID-1」）的核心模組與工具（`drbd-utils`） | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| DRBD 8.4 / 9 | 8.4 是核心內建的舊版；9 支援多節點與更佳效能但需 LINBIT 的模組 | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| drop-in | 放在 `<unit>.d/*.conf` 的片段設定檔，與原單元檔合併生效 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| drop-in（`conf.d/*.conf`） | 放在 `/etc/NetworkManager/conf.d/` 的片段設定檔，與套件自帶的 `NetworkManager.conf` 合併 | [05-網路與防火牆](05-網路與防火牆.md) · 4.5 NetworkManager 全域設定 |
| drop-in（`sshd_config.d/*.conf`） | 主檔第一行 `Include /etc/ssh/sshd_config.d/*.conf` 載入的片段檔，兩個發行版都有 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| DRP（災難復原計畫） | 寫明「災難發生時誰、依什麼順序、用哪份備份、怎麼驗證」的文件 | [11-備份與災難復原](11-備份與災難復原.md) · 10. 災難復原計畫（DRP） |
| `ds=nocloud` vs `ds=nocloud-net` | 核心參數，指定 NoCloud 資料源位置：本機路徑 / 裝置，或 HTTP URL | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| duplicity | 以 tar 增量檔 + GPG 加密的舊式工具 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| eBPF | 核心內建的沙箱虛擬機，可安全載入小程式掛在核心事件上執行，不必改核心或重開機 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| ECDSA P-256 / RSA 2048+ | 憑證金鑰的兩種演算法：橢圓曲線（短、快）/ 傳統（相容性最好） | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| EDAC / rasdaemon / ras-mc-ctl | EDAC 是核心回報記憶體 ECC 錯誤的子系統；rasdaemon 把 MCE / EDAC 事件記進資料庫；`ras-mc-ctl` 查詢 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| `EDITOR` / `VISUAL` | 需要開編輯器的程式（`visudo`、`systemctl edit`、`crontab -e`、git）讀的環境變數 | [02-初始設定](02-初始設定.md) · 9.4 Shell 環境 |
| `EFI/<發行版>/` | 每個 OS 在 ESP 裡的私有目錄（🟠 `EFI/ubuntu/`、🔵 `EFI/fedora/`） | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| `EFI/BOOT/BOOTX64.EFI`（後備路徑） | UEFI 規範定義的「可移除媒體路徑」：韌體找不到任何有效 Boot#### 時會試這個檔 | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| efibootmgr | 從 Linux 讀寫 Boot#### / BootOrder 的 CLI | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| efitools / efi-readvar | 讀取與操作 PK / KEK / db / dbx 的工具組 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| `efivarfs` 模組 | 把 NVRAM 變數掛成 `/sys/firmware/efi/efivars` 的核心模組（§1） | [14-UEFI進階](14-UEFI進階.md) · 6. initramfs 與 UEFI 相關設定 |
| Elasticsearch / Kibana / Filebeat（ELK） | 全文檢索引擎 / 其網頁查詢介面 / 其輕量收集端 | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| emergency shell | systemd 在關鍵掛載失敗時進入的單人維護 shell | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| `emergency.target` | 最小環境：`/` 唯讀、幾乎不啟動任何 unit | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `enable --now` | `enable` 設定開機自動啟動、`--now` 同時立刻啟動，一條指令做兩件事 | [02-初始設定](02-初始設定.md) · 4.1 安裝與啟用 |
| enable / disable | 對「開機時」的操作：在 target 的 `.wants/` 目錄建立 / 移除符號連結 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| Endpoint ／ ListenPort | 對方的公網位址：埠／自己監聽的 UDP 埠 | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| enforce / complain / disable | profile 的三種狀態：阻擋並記錄 / 只記錄不阻擋 / 完全不載入 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| enforce / complain（AppArmor）、enforcing / permissive（SELinux） | 阻擋並記錄 / 只記錄不阻擋 | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| enforcing / permissive / disabled | SELinux 三種模式：擋並記錄 / 只記錄不擋 / 完全關閉 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| enforcing=0 | 核心參數：讓 SELinux 以 permissive 模式開機 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| `entries/*.conf` | 每個核心一個開機項，格式就是 §5.2 的 BLS | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| env_reset / secure_path | 執行前清空環境變數、並固定 `PATH` | [08-安全強化](08-安全強化.md) · 2.2 sudo 強化 |
| `EnvironmentFile=` | 從檔案讀 `KEY=VALUE` 環境變數注入程式 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| EOL | End of Life，停止安全更新的日期 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| ephemeral port | 出站連線由核心自動分配的來源埠，範圍由 `ip_local_port_range` 決定 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| ESM | Expanded Security Maintenance，Ubuntu Pro 中「LTS 過了 5 年後仍提供安全更新」的部分，也涵蓋 universe 套件庫 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| ESP | EFI System Partition，一個 FAT32 小分割區（`/boot/efi`），UEFI 只會從這裡找開機檔 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| ESP / FAT32 | ESP 是 UEFI 專用的開機分割區（§1.5），必須格式化成 FAT32，因為那是韌體唯一保證能讀的檔案系統 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| `etcdctl snapshot save` | 匯出 etcd 整個鍵值庫的快照 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| etckeeper | 把 `/etc` 放進 git、每次套件操作後自動 commit 的工具 | [12-監控與故障排除](12-監控與故障排除.md) · 2. 故障排除方法論 |
| ethtool | 查詢與設定網卡驅動層資訊（速率、雙工、link 偵測、offload、統計）的工具 | [05-網路與防火牆](05-網路與防火牆.md) · 2. 共通的觀察指令（iproute2） |
| evil maid | 能短暫實體接觸機器、竄改開機檔（如 initramfs）再放回去的攻擊 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| `exec` + 重新導向 | 不帶指令名的 `exec > file 2>&1` 會改接「目前 shell 自己」的 fd，之後所有指令都沿用 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 1.4 tee 的其他實用場景 |
| exit code | 每個程式結束時交回的 0～255 整數，0 表示成功 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| exporter | 把某個系統的狀態轉成 Prometheus 格式並以 HTTP 提供的小程式 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| ext4 | Linux 最普及的日誌式檔案系統，成熟、工具齊、可縮可擴 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| facility | syslog 訊息的「來源類別」：`auth`、`authpriv`、`kern`、`mail`、`cron`、`daemon`、`local0`～`local7` 等 | [07-日誌管理](07-日誌管理.md) · 3. rsyslog |
| `facility.priority` selector | 傳統一行規則的左半：`auth,authpriv.*`（多個 facility 用逗號）、`*.info`（所有 facility 的 info 以上） | [07-日誌管理](07-日誌管理.md) · 3.1 安裝與預設 |
| facts / `ansible_facts` | 執行 play 前由 `setup` module 從受管機蒐集的系統資訊（`os_family`、`selinux`、IP…） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| Fail2ban | 讀日誌、把反覆登入失敗的來源 IP 暫時加進防火牆黑名單的工具（08 章 §4） | [02-初始設定](02-初始設定.md) · 4.3 更改 SSH Port（含 SELinux / socket 差異） |
| Fail2ban / logwatch | 讀日誌找攻擊並封鎖來源 IP / 每日彙整日誌寄報告的工具 | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| Fail2ban jail | Fail2ban 的一組「監看哪個日誌、比對哪個樣式、封鎖多久」設定 | [07-日誌管理](07-日誌管理.md) · 3. rsyslog |
| failover | primary 故障時 promote 一台 replica 並把應用連線導過去的完整流程 | [10-高可用設計](10-高可用設計.md) · 6. 資料庫高可用 |
| failover（自動切換） | 偵測到故障後，由軟體把流量或 primary 角色轉到健康節點 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| fall / rise | 連續失敗幾次才算掛、連續成功幾次才算恢復 | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| FallbackDNS | 所有網卡與全域 `DNS=` 都沒設定時才用的最後手段 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| Fast Startup | Windows 的「關機其實是休眠核心」功能，關機後 NTFS 與 ESP 仍處於被鎖定的髒狀態 | [14-UEFI進階](14-UEFI進階.md) · 11. 雙系統與多 ESP |
| fbx64.efi / BOOTX64.CSV | shim 的 fallback 程式與它讀的清單：從後備路徑開機時，依 CSV 內容重建 NVRAM 開機項 | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| fcontext | 「路徑樣式 → 應有的 type」的規則表（`semanage fcontext -l`） | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| Fedora / Fedora Project | Red Hat 贊助的社群發行版，任務是搶先驗證將進入 RHEL 的技術 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Fedora 版本壽命 | 每版約 13 個月：到「下下版」發布後一個月即停止支援 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| fencing / STONITH | Shoot The Other Node In The Head：用 IPMI 或虛擬化 API 把疑似故障的節點強制關機 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| FIDO2 硬體金鑰（`-sk`） | 私鑰存在 YubiKey 等裝置內，電腦上的 `id_ed25519_sk` 只是「把手」；`-O resident` 把把手也存進裝置、`-O verify-required` 每次登入要輸 PIN | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| file conflicts / 被保護的套件 | 前者是兩個套件要寫同一個路徑（多半是不同 repo 的同名軟體）；後者是 dnf 拒絕移除的核心套件（`dnf`、`kernel`、`systemd`，列於 `/etc/dnf/protected.d/`） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| `file_contexts` / `file_contexts.local` | 「路徑 regex → 標籤」對照表：前者由各模組的 `.fc` 產生，後者是 `semanage fcontext -a` 加的 | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| `files_type(T)` / `init_daemon_domain(D, E)` | 前者宣告 T 是一般檔案 type（restorecon、備份 domain 認得）；後者宣告「systemd 執行 E → 轉入 D」並給 D daemon 的基本權限 | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| filter | `filter.d/*.conf` 內的正則表示式，定義什麼樣的日誌行算「一次失敗」並抓出 `<HOST>` | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| `filter` / `global_filter` | lvm.conf 中以 regex 接受 / 拒絕裝置路徑的舊機制 | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| filter 表 ／ nat 表 | netfilter 裡的兩類規則表：filter 決定封包放不放行，nat 決定要不要改寫位址或埠 | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| fio | 可指定讀寫模式、區塊大小、佇列深度、並行數的 I/O 壓測工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| fio / iperf3 | 磁碟 I/O 基準 / 網路頻寬基準 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| FIPS | 美國政府的加密模組驗證標準（FIPS 140）；FIPS 模式會禁用未經驗證的演算法 | [08-安全強化](08-安全強化.md) · 1.2 Live patch 與延伸支援 |
| FIPS / fips-mode-setup | FIPS 140 是美國政府的加密模組驗證標準；`fips-mode-setup --enable` 除了切策略還會加核心參數 `fips=1` 並重建 initramfs | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| firewalld | 🔵 Fedora 預設的防火牆管理服務，以「zone + service」描述放行規則，`firewall-cmd` 是它的指令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| firewalld / firewall-cmd | 🔵 Fedora 的動態防火牆 daemon 與其 CLI，用 zone 組織規則 | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| `fixfiles -B onboot` / `.autorelabel` | 🔵 排程下次開機重標 SELinux 標籤；`-B` 只處理上次重標之後改過的檔案 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| flame graph | 把取樣到的呼叫堆疊畫成「寬度＝佔用時間比例」的火焰圖 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| Flatpak | 跨發行版的桌面應用打包格式與執行環境，由社群主導 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 4. 通用套件格式：Snap 與 Flatpak |
| Flatpak / Flathub | Flatpak 是跨發行版的沙箱式桌面應用格式；Flathub 是最大的 Flatpak 應用庫 | [01-系統安裝](01-系統安裝.md) · 4.2 🔵 Fedora Workstation |
| `flush ruleset` | 清空核心內所有 table／chain／rule | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| Flutter 安裝程式 | 24.04 起 Ubuntu Desktop 的新安裝程式（以 Flutter 框架撰寫，取代舊的 Ubiquity） | [01-系統安裝](01-系統安裝.md) · 3.1 🟠 Ubuntu Desktop 安裝重點 |
| forget / prune | forget 依 `--keep-daily 7` 等策略把過期 snapshot 從清單移除；prune 才真正刪掉沒人引用的區塊釋放空間 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| Forwarding（X11 / Agent / TCP）、PermitTunnel、GatewayPorts | session 建立後可額外開的通道：轉發圖形、轉發 ssh-agent、埠轉發（`ssh -L/-R`）、VPN 式 tun 裝置 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| `ForwardToSyslog=` / `ForwardToWall=` | 是否把訊息再轉給 `/run/systemd/journal/syslog` socket（傳統 syslog daemon 用）/ 是否把 emerg 訊息廣播到所有終端 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| fpm | 用一行指令把目錄或語言套件轉成 `.deb` / `.rpm` 的跨格式打包工具 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| FQDN | Fully Qualified Domain Name，含網域的完整主機名（`web01.example.com`），對應的短名是 `web01` | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| frontend | 定義「收流量」的一端：`bind` 哪個埠、TLS 憑證、依 ACL 選 backend | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| fs.file-max / fs.nr_open | 前者是整台機器所有程序合計的上限，後者是單一程序的絕對上限 | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| fsck | 檔案系統一致性檢查與修復 | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| `fsck.vfat` | FAT 檔案系統檢查修復工具 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| fsck（file system check） | 掃描檔案系統結構、修正不一致的工具總稱 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.3 檢查與修復 |
| fsfreeze | 讓 guest 內檔案系統暫停寫入並把快取刷到磁碟的指令 | [11-備份與災難復原](11-備份與災難復原.md) · 6.4 虛擬機 / 雲端快照 |
| `fstab` / `crypttab` / `machine-id` | 掛載表 / LUKS 自動解鎖表 / 每台機器唯一的識別碼 | [11-備份與災難復原](11-備份與災難復原.md) · 8.3 手動重建流程（無映像時） |
| full / incremental / differential | 全量 = 整份備；增量 = 只備上次「任一備份」以來的變動；差異 = 只備上次「全量」以來的變動 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| `full-upgrade` vs `upgrade` | 🟠 apt 的 `upgrade` 不會為了升級而移除既有套件，`full-upgrade` 允許（核心版本更換時常需要）；🔵 dnf 的 `upgrade` 本來就允許 | [02-初始設定](02-初始設定.md) · 8. 系統更新與基本工具 |
| fullchain.pem / privkey.pem | 伺服器憑證 + 中繼 CA 憑證串 / 對應私鑰 | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| FUSE | Filesystem in Userspace，讓一般程序在使用者空間掛載檔案系統的核心介面與函式庫 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| fwupd / `fwupdmgr` | 韌體更新服務與 CLI（14 章 §9） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| fwupd / LVFS | 韌體更新 daemon / 廠商上傳韌體的公共服務 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| fwupd / LVFS / capsule | 韌體更新服務 / 廠商上傳簽過韌體的雲端倉庫 / UEFI 規範的韌體更新封裝格式（§9） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| fwupd / systemd-boot | 韌體更新工具 / 極簡開機載入器 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| fwupd-efi / `fwupdx64.efi` | 放在 ESP `EFI/<distro>/` 的 EFI 應用程式，負責在韌體階段把 capsule 交給韌體 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| GA 核心 | General Availability，LTS 發布當下附帶的核心版本，整個生命週期只修 bug 不升大版 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| Galera | MariaDB / MySQL 的多主同步複製外掛（libgalera），每個節點都能寫 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| gcomm:// | `wsrep_cluster_address` 的位址格式，列出叢集成員 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| `gdisk` | GPT 分割表編輯工具 | [14-UEFI進階](14-UEFI進階.md) · 11. 雙系統與多 ESP |
| `gen_context(context, level)` | `.fc` 裡產生完整 context 字串的巨集 | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| glibc | GNU C Library，幾乎所有程式都動態連結的基礎函式庫 | [02-初始設定](02-初始設定.md) · 8. 系統更新與基本工具 |
| global / defaults | `global` 是程序層設定（日誌、連線上限、管理 socket）；`defaults` 是後面各段共用的預設值（timeout） | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| GLPI / Snipe-IT | 開源 IT 資產管理系統，搭配 agent 自動回報 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| GlusterFS | 把多台主機的目錄合成一個網路檔案系統，複製卷（replica）在 3 台上各存一份 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| GNOME / KDE Plasma | 兩大桌面環境；🟠 出貨 GNOME 客製版、🔵 GNOME 原味與 KDE Edition | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| GNOME Initial Setup | 第一次開機時 GNOME 的歡迎精靈，負責建立使用者、時區、線上帳號 | [01-系統安裝](01-系統安裝.md) · 4.2 🔵 Fedora Workstation |
| google-authenticator / pam_google_authenticator | 前者是產生 TOTP 密鑰與 QR code 的指令（寫進 `~/.google_authenticator`），後者是驗證動態碼的 PAM 模組 | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| governor（cpufreq） | 核心 cpufreq 子系統的頻率調速策略：`performance` 鎖最高頻、`powersave` 偏省電、`schedutil` 依排程器負載動態調整 | [09-性能調校](09-性能調校.md) · 2. CPU |
| `gparted` | 圖形化的分割區編輯工具，直接搬移 / 縮放分割區 | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| `gpasswd` | 管理群組成員與群組密碼 | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| GPG 簽章 | 發行版用私鑰對校驗檔產生的簽名（🟠 獨立檔 `SHA256SUMS.gpg`；🔵 直接內嵌在 CHECKSUM 檔內） | [01-系統安裝](01-系統安裝.md) · 1.2 校驗映像完整性 |
| GPG 金鑰 / keyring | 套件庫用來簽章索引的公鑰；keyring 是存放這些公鑰的檔案 | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| GPG 金鑰（keyring） | 套件庫用來簽署 metadata 的公鑰，存在本機的金鑰檔（keyring）裡，高階工具驗簽通過才使用該來源 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| `gpgcheck=1` / `gpgkey=` | 🔵 `.repo` 的兩個欄位：前者要求驗簽、後者指定該 repo 公鑰的位置（URL 或 `file://`） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.2 新增第三方套件庫（以 Docker 為例，已實測） |
| GPT | UEFI 規範定義的新格式：64 位元定址、128 個分割區、表有備份與 CRC 校驗 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| graceful shutdown（優雅關閉） | 收到 SIGTERM 後先停收新連線、把進行中的請求做完再退出 | [10-高可用設計](10-高可用設計.md) · 7.1 應用無狀態化 |
| Grafana | 儀表板工具，向 Prometheus / Loki 查詢並畫圖 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| Grafana / Prometheus | 儀表板 / 指標（metrics）系統 | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| grastate.dat / safe_to_bootstrap | 每個節點資料目錄裡記錄叢集狀態的檔案；`safe_to_bootstrap: 1` 標記最後關機、資料最新的節點 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| group | 把多個 resource 綁成一組：同一節點、依序啟動、反序停止 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| Group Replication / InnoDB Cluster | MySQL 官方的多節點同步複製（Paxos 變體）；InnoDB Cluster 是它加上 MySQL Shell 管理的整套方案 | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| group（套件群組） | 🔵 Fedora 定義的一組套件集合（如 `multimedia`、`development-tools`），`dnf group install` 一次裝齊 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.4 🔵 RPM Fusion（Fedora 必裝的第三方庫） |
| `growpart` | cloud-utils 提供的工具，線上把分割區的結尾往後推、不動資料 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.2 線上擴充（最常用；已實測） |
| GRUB | 兩者預設的開機載入器（bootloader）：顯示選單、讀取核心與 initramfs、交棒給核心 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| GRUB / grub-install / grub2-install | 開機載入器 / 把它安裝到 MBR 或 ESP 的指令 | [12-監控與故障排除](12-監控與故障排除.md) · 3.3 重裝開機載入器 |
| GRUB / `update-grub` / `grub2-mkconfig` | GRUB 是兩家共用的開機載入器；後兩者是依 `/etc/default/grub` 與偵測結果重新產生 `grub.cfg` 的指令（`update-grub` 只是 `grub-mkconfig` 的包裝） | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| grub rescue> | GRUB 找不到自己的模組目錄或 `/boot` 時退化成的極簡提示 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| GRUB 選單 | 開機時列出所有已安裝核心的畫面 | [04-系統管理](04-系統管理.md) · 5. 核心與開機管理 |
| `grub-install --uefi-secure-boot` | 🟠 把已簽署的 `grubx64.efi.signed` 與 shim 複製進 ESP 並建 NVRAM 項 | [14-UEFI進階](14-UEFI進階.md) · 5.1 GRUB2（兩者預設） |
| grub-install / grub2-install | 把 GRUB 執行檔裝進 ESP 並建 NVRAM 項的指令 | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| `grub-reboot` / `grub-set-default` | 🟠 設定「下次一次性」/「永久」預設開機項 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `grub.cfg` / `grub-mkconfig` | 前者是 GRUB 真正讀的設定檔（自動產生、勿手改）；後者依 `/etc/default/grub` 與 `/etc/grub.d/` 腳本產生它 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| grub.cfg / update-grub / grub2-mkconfig | GRUB 的選單設定檔，與兩邊產生它的指令（🟠 `update-grub`、🔵 `grub2-mkconfig`） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `grub2-editenv` / grubenv / kernelopts | `grubenv` 是 GRUB 的小型鍵值檔（記住上次選的核心等）；🔵 舊版把核心參數放在其中的 `kernelopts` | [14-UEFI進階](14-UEFI進階.md) · 5.1 GRUB2（兩者預設） |
| `GRUB_CMDLINE_LINUX` / `_DEFAULT` | 兩個核心參數變數：前者所有開機項都套用（含救援），後者只套用一般開機項 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `GRUB_ENABLE_BLSCFG` | `/etc/default/grub` 的開關，`true` 時 grub.cfg 只放一行 `blscfg` 去讀 entry 檔 | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| `grubby` | 🔵 直接編輯 BLS 開機項（加減參數、設預設）的工具 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `grubnetx64.efi.signed` | 🟠 內建網路模組的 GRUB EFI 版，已簽署 | [14-UEFI進階](14-UEFI進階.md) · 10. PXE / HTTP Boot 與網路安裝（UEFI 版） |
| GSLB | Global Server Load Balancing，用 DNS 依健康狀態 / 地理位置把使用者導向不同站點 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| guest agent | 跑在 VM 內、透過虛擬化平台的專用通道（不走網路）與 hypervisor 對話的 daemon | [02-初始設定](02-初始設定.md) · 9.5 虛擬機 Guest Agent |
| handle | 每條 rule 在核心裡的流水號（`nft -a` 顯示） | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| handler | 一種特殊 task：只有被 `notify` 且觸發它的 task 回報 changed 時才執行，且整個 play 只跑一次 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| handshake | 兩端每 2 分鐘左右重新協商一次工作階段金鑰 | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| HAProxy | 高效能的 L4 / L7 反向代理與負載平衡器，會主動對後端做健康檢查 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| hardlink | 同一個 inode 的多個檔名，不佔額外空間 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| hardlink 快照 | rsnapshot 的做法：沒變的檔案用 hardlink 指向上一份，看起來每天都是完整目錄 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| header | LUKS 容器開頭的 metadata 區：cipher、salt、主金鑰的加密副本 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| health check | `check` 開啟探測；`option httpchk` 指定 HTTP 路徑、`http-check expect` 指定期望結果；`inter` 間隔、`fall` / `rise` 次數 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| healthchecks.io / Uptime Kuma | 託管 / 自架的 dead-man switch 服務，每個任務一個 ping URL | [11-備份與災難復原](11-備份與災難復原.md) · 10.3 備份監控 |
| HealthCmd / HealthOnFailure | 容器內定期執行的健康檢查指令，與檢查失敗時的動作（Podman 5 可 kill / restart） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.2 Quadlet（Podman 4.4+，兩者皆可） |
| heredoc（`<<EOF`） | 把命令列中接下來直到結束標記為止的多行文字當作程式的 stdin | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| `HISTSIZE` / `HISTTIMEFORMAT` | bash 記憶體內保留的歷史筆數 / 顯示歷史時的時間格式；設了後者，bash 才會把時間戳寫進 `~/.bash_history` | [02-初始設定](02-初始設定.md) · 9.4 Shell 環境 |
| HLL / `hll/pp` | High Level Language 與它的轉換器（`/usr/libexec/selinux/hll/pp`）：把 `.pp` 轉成 CIL | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| hold（`apt-mark hold`） | 🟠 把套件標成「升級時跳過」，記在 dpkg 的 selections 狀態裡 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| hook | 核心 netfilter 在封包路徑上提供的五個掛載點（prerouting／input／forward／output／postrouting） | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| HostKey / HostKeyAlgorithms | 伺服器的身分金鑰（`/etc/ssh/ssh_host_*_key`）與允許用來簽署的演算法 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| hostnamectl | systemd 提供的主機名管理指令，一次寫入 `/etc/hostname`、通知核心、經 D-Bus 即時生效，不必重開機 | [02-初始設定](02-初始設定.md) · 1. 主機名與 hosts |
| `hostnamectl` / `timedatectl` | systemd 附的查詢工具：前者顯示主機名、核心、虛擬化平台；後者顯示時區與 NTP 同步狀態 | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| HSI（Host Security ID） | fwupd 對機器開機安全設定的分級評分：Secure Boot、TPM、IOMMU、DMA 保護、韌體寫保護等 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| HSTS | HTTP Strict Transport Security：伺服器回應 `Strict-Transport-Security` 標頭，瀏覽器之後在指定期間內一律直接用 HTTPS 連 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| HTTP Boot | UEFI 2.5 起內建的機制：DHCP 直接給一個 `http(s)://` URL，韌體用內建 HTTP 客戶端下載開機檔 | [14-UEFI進階](14-UEFI進階.md) · 10. PXE / HTTP Boot 與網路安裝（UEFI 版） |
| `httpd_enable_homedirs` | 讓 `httpd_t` 讀使用者家目錄（`user_home_t` 等）的 boolean | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| hub 式介面 / Installation Summary | Anaconda 的中央總覽畫面：每個項目（鍵盤、儲存、網路…）各自進去設定再回到總覽，沒有固定順序 | [01-系統安裝](01-系統安裝.md) · 4. 🔵 Fedora 44 互動式安裝（Anaconda） |
| HugePages（靜態） | 用 `nr_hugepages` 預留的 2 MB 大頁，不可換出、需應用明確申請 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| `hv_*` 模組 / hyperv-daemons | Hyper-V 的整合服務：核心內建驅動（`hv_vmbus`、`hv_utils`…）負責通道，🔵 `hyperv-daemons` 補上 KVP / VSS / fcopy 三個使用者空間 daemon | [02-初始設定](02-初始設定.md) · 9.5 虛擬機 Guest Agent |
| HWE 核心 | Hardware Enablement，把較新中間版的核心回移到 LTS 的套件（`linux-generic-hwe-24.04`） | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| hypervisor / guest | hypervisor 是跑 VM 的宿主層（KVM、Proxmox、VMware、雲端）；guest 是 VM 內的作業系統 | [11-備份與災難復原](11-備份與災難復原.md) · 6.4 虛擬機 / 雲端快照 |
| I/O 排程器（scheduler） | 區塊層決定「佇列中的請求以什麼順序送給裝置」的演算法，每個裝置各自設定 | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| IBus | 輸入法框架；`ibus-chewing`（注音）/ `ibus-libpinyin`（拼音）是掛在它上面的引擎 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| ICMP redirect / source route / martians | 路由器用 ICMP 叫主機改走別的閘道 / 封包自帶路徑指定 / 來源位址不合理的封包 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| IdentitiesOnly | 只送 `IdentityFile` 指定的金鑰，不把 agent 裡每一把都輪流試 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| ifupdown ／ network-scripts | 舊世代設定方式：Debian 的 `/etc/network/interfaces`、Red Hat 的 `ifcfg-*` 腳本 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| `ignore-auto-dns` ／ `never-default` ／ `route-metric` | 分別是「不採用 DHCP 給的 DNS」、「這張卡不要預設路由」、「預設路由的 metric」 | [05-網路與防火牆](05-網路與防火牆.md) · 4.2 靜態 IP / DHCP |
| `ignoredisk` / `clearpart` / `zerombr` | 限定 Anaconda 只碰哪些磁碟 / 清除分割表 / 對沒有分割表的磁碟直接初始化 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| ignoreip | 永不封鎖的 IP / 網段白名單 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| immutable（不可變） | 寫入後在保留期內誰都不能改或刪，連管理員也不行（S3 Object Lock、append-only repo） | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| `imtcp` / `imudp` | 伺服器端接收模組，分別聽 TCP / UDP | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| `imuxsock` / `imklog` / `imjournal` | rsyslog 的三種輸入模組：聽 `/dev/log`、讀核心緩衝、直接讀 journal | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| Incus | LXD 的社群分支（2023 年起由 LXC 專案維護），指令與 LXD 幾乎相同 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| init 系統 / systemd | init 是核心啟動後的第一個程序（PID 1）；systemd 是現代發行版通用的 init 實作，也管服務、日誌、計時器 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `init=/bin/bash` | 核心參數：不啟動 systemd，直接以 bash 當 PID 1 | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `init_daemon_domain(D, E)` | refpolicy 巨集：宣告 E 為 exec type，systemd（`init_t`）執行 E 時轉入 D | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| `init_t` / `bin_t` | systemd 本身的 domain / 一般可執行檔的 type | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| initiator | 掛載遠端區塊裝置的客戶端 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| initramfs | 隨核心一起載入的小型記憶體檔案系統，內含掛載真正根目錄前需要的驅動與工具（LVM、LUKS、RAID 模組） | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| initramfs / dracut / initramfs-tools | 核心開機後、真正根檔案系統掛上前用的迷你檔案系統，含驅動與 LUKS 解鎖邏輯；由 🔵 dracut / 🟠 initramfs-tools 在本機產生（§6） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| initramfs / `update-initramfs` / `dracut` | initramfs 是核心開機時先載入的迷你根檔案系統（含驅動、LVM、LUKS 工具）；後兩者是產生它的工具 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| initramfs shell / dracut | dracut 是 🔵 產生 initramfs 的工具，其 shell 只有最基本的指令 | [12-監控與故障排除](12-監控與故障排除.md) · 3.1 進入救援環境 |
| `initramfs-tools` | 🟠 Debian 系的 initramfs 產生器：`update-initramfs` 建、`lsinitramfs` 看、設定在 `/etc/initramfs-tools/` | [04-系統管理](04-系統管理.md) · 5.3 initramfs |
| initramfs-tools / `update-initramfs` | 🟠 Debian 系的 initramfs 產生器：`/etc/initramfs-tools/modules` 列要多放的模組，`update-initramfs -u` 重建 | [14-UEFI進階](14-UEFI進階.md) · 6. initramfs 與 UEFI 相關設定 |
| initramfs（🟠 initramfs-tools / 🔵 dracut） | 開機早期的迷你根檔案系統，內含 lvm2 與 lvm.conf 的副本 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| inode | 檔案系統中每個檔案的中繼資料節點，總數在 `mkfs` 時就固定 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| inotify watch | 核心讓程式訂閱「檔案有變動」通知的機制，每個被監看的檔案佔一個 watch | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| `install` | coreutils 的複製工具，複製的同時設定權限、擁有者，也能建目錄 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 5. 其他常見指令 |
| Installation Source / Closest mirror | 安裝時的套件來源；「Closest mirror」由 Fedora 的 mirrorlist 服務依地理位置自動挑鏡像站 | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| installonly 套件 / `installonly_limit` | dnf 把核心視為「只安裝不升級」的套件，每版並存；`installonly_limit` 規定最多保留幾版 | [04-系統管理](04-系統管理.md) · 5.1 核心版本與套件 |
| interface（`.if`） | 巨集的定義所在：每個模組用 `interface(名稱, 規則)` 對外宣告「別的模組可以怎麼跟我互動」 | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| inventory | 列出受管機、其連線參數（`ansible_host`、`ansible_user`）並分群的清單（`inventory.ini` 或 YAML） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| iodepth / numjobs | 同時在飛的 I/O 請求數 / 並行執行緒數 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| iostat | 每個區塊裝置的 IOPS、吞吐、延遲（`await`）、使用率（`%util`）統計 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| IOWeight / IOReadBandwidthMax / IOWriteBandwidthMax | I/O 的相對比例 / 每個裝置的絕對頻寬上限 | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| ip_forward | 允許核心把封包從一張網卡轉到另一張（當路由器） | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| `ip_forward` / `inotify max_user_watches` / `swappiness` | 三個最常改的參數：允許轉發封包（容器、VPN 必要）/ 每個使用者可監看的檔案數（IDE、同步工具）/ 核心把記憶體換到 swap 的積極程度（0～200） | [04-系統管理](04-系統管理.md) · 5.5 sysctl 核心參數 |
| ip_nonlocal_bind | 核心參數，允許程式綁定目前不在本機的 IP | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| iperf3 | 兩端各跑一份、量純 TCP / UDP 頻寬的工具 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| IPMI / BMC / ipmitool | BMC 是伺服器的獨立管理控制器，IPMI 是與它溝通的協定，`ipmitool` 是工具 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| IPMI / BMC 管理網 | 主機板上獨立於作業系統的管理控制器與它專用的網段 | [10-高可用設計](10-高可用設計.md) · 7.3 網路層冗餘 |
| iproute2 | `ip`、`ss`、`bridge`、`tc` 等指令所屬的套件，透過 netlink 觀察或直接修改核心狀態 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| iptables-nft | 以 iptables 語法為介面、但把規則寫進 nftables 的相容層 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| iptables-translate | 把一條 iptables 指令翻成等價 nft 語法的工具 | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| `ipv4.method` | 位址從哪來：`manual`（靜態）、`auto`（DHCP）、`disabled`（不設 IPv4） | [05-網路與防火牆](05-網路與防火牆.md) · 4.2 靜態 IP / DHCP |
| IPv6 隱私位址（`ip6-privacy`） | RFC 4941 的暫時位址：不用 MAC 推導的固定尾碼，而是定期換一組亂數尾碼對外連線 | [05-網路與防火牆](05-網路與防火牆.md) · 4.5 NetworkManager 全域設定 |
| iPXE | 開源、功能完整的網路開機程式：支援 HTTP(S)、iSCSI、腳本 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| IQN | iSCSI Qualified Name，格式 `iqn.年-月.反向網域:識別`，target 與 initiator 各有一個 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| IRQ | 硬體中斷請求：網卡、磁碟每收到資料就發一次，由某顆 CPU 負責處理 | [09-性能調校](09-性能調校.md) · 2. CPU |
| irqbalance | 自動把 IRQ 分散到各核心的 daemon（兩者預設啟用） | [09-性能調校](09-性能調校.md) · 2. CPU |
| iSCSI | 把 SCSI 區塊指令包在 TCP/IP 上傳送 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9. 網路儲存 |
| ISO 安裝映像 | 內含安裝程式與套件的光碟映像，寫入 USB 後開機即進入安裝流程 | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| `isolate` / `set-default` | 前者立刻切到某 target（停掉不屬於它的 unit）；後者改變開機預設 target | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| isolcpus / nohz_full / rcu_nocbs | 三個核心參數，把指定核心從一般排程、週期性時鐘中斷、RCU 回呼中隔離出來 | [09-性能調校](09-性能調校.md) · 2. CPU |
| IST | Incremental State Transfer，短暫離線的節點只補漏掉的交易（埠 4568） | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| jail | 一組「用哪個 filter 看哪個日誌、閾值多少、封鎖用哪個 action」的設定單元；`[sshd]`、`[nginx-http-auth]` 各是一個 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| job | systemd 內部對「啟動 / 停止某 unit」這件事的排隊項目 | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| job control | shell 對自己啟動的背景工作（`&`、`Ctrl-Z`）的管理 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| journal | journald 寫出的二進位日誌檔（`/run/log/journal/` 暫存或 `/var/log/journal/` 持久） | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| journal / journalctl | systemd 的結構化日誌與其查詢工具 | [12-監控與故障排除](12-監控與故障排除.md) · 2. 故障排除方法論 |
| `journal-upload` → `journal-remote` | systemd 原生集中方案（§3.3） | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| `journalctl -k` / `-t setroubleshoot` | 看核心訊息 / 看 setroubleshootd 寫的摘要 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| journald / `journalctl` | systemd 的日誌收集器與查詢工具，以二進位索引格式存放，可依 unit、時間、優先級過濾 | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| `journald.conf` 與 drop-in | 主檔（🟠 `/etc/systemd/`、🔵 `/usr/lib/systemd/`）與覆寫目錄 `/etc/systemd/journald.conf.d/*.conf` | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| journald（`systemd-journald`） | systemd 內建的日誌收集服務，接收所有來源並存成有索引的二進位 journal | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| KbdInteractiveAuthentication | 「鍵盤互動式」驗證：sshd 把問答交給 PAM（§3.4），問的可以是密碼也可以是 OTP | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| kdump | 核心當機時自動保存記憶體映像的機制 | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| kdump-config / kdumpctl | 🟠 / 🔵 管理 kdump 的指令（show / test / status） | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| Keepalived | Linux 上實作 VRRP 的 daemon，同時能執行健康檢查腳本並搬動 VIP | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| KEK（Key Exchange Key） | 被 PK 授權、可以更新 db / dbx 的金鑰（通常是 Microsoft 與廠商各一把） | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| kernel / glibc / systemd | 核心、C 標準函式庫、init 系統——三個「幾乎所有程序都載入或依賴」的元件 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.2 判斷是否需要重開機 |
| `kernel-install` / `install.d` plugin | systemd 提供的核心安裝框架：裝核心時依序執行 `/usr/lib/kernel/install.d/` 的 plugin（產 initramfs、寫 entry、建 NVRAM 項等） | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| `kernel-uki-virt` / `uki-direct` / `kernel-bootcfg` | 🔵 官方已簽署的 UKI 套件（給 VM / 雲端）/ 讓 `kernel-install` 直接把 UKI 放進 ESP 的套件 / 後者用來建 NVRAM 項的工具 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| kexec | 從執行中的核心直接載入並跳到另一個核心，不經過韌體 | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| KEX（KexAlgorithms） | Key Exchange，雙方協商出本次連線對稱金鑰的演算法 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| `Key was rejected by service` | lockdown 核心拒載模組時的錯誤訊息 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| keyfile | NM 的連線設定檔格式（ini 語法，副檔名 `.nmconnection`），一個檔案就是一個 connection profile | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| Keylime / 遠端證明 | 讓伺服器把 TPM 簽過的 PCR 值送到中央驗證，證明自己的開機路徑未被竄改 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| keyslot | header 內最多 32 個「用不同密碼包裝同一把主金鑰」的格子 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| KeyTool | efitools 附的 EFI 應用程式，在韌體階段替換 PK / KEK / db | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| Kickstart | 🔵 Anaconda 的無人值守格式：自訂指令語法的 `.ks` 純文字檔，附 `%packages` / `%post` 區段 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| Kickstart / autoinstall | 🔵 Anaconda / 🟠 Subiquity 的無人值守安裝描述檔（01 章 §5） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| kmodgenca | 🔵 akmods 套件的工具，產生一組本機 CA 金鑰（`/etc/pki/akmods/`）給 akmods 簽模組 | [08-安全強化](08-安全強化.md) · 6.5 Secure Boot 下的自訂核心模組 |
| kptr_restrict / dmesg_restrict | 對非 root 隱藏 `/proc/kallsyms` 等處的核心位址 / 禁止非 root 讀 `dmesg` | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| KRaft | Kafka 內建的 Raft 共識層，取代原本依賴的 ZooKeeper 存放中繼資料 | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| `ksvalidator` / `pykickstart` | pykickstart 是 Anaconda 解析 Kickstart 用的 Python 函式庫，`ksvalidator` 是它附的語法檢查器，`-v F44` 指定版本語法 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| KVM | Linux 核心內建的 hypervisor 模組（`kvm_intel` / `kvm_amd`），把 CPU 的硬體虛擬化功能暴露成 `/dev/kvm` | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| KVM / QEMU / libvirt | KVM 是 Linux 核心的虛擬化功能；QEMU 是模擬硬體、實際跑 VM 的程式；libvirt 是管理它們的統一 API 與守護程序 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| L4 / L7 | L4 = 只看 IP / 埠轉送 TCP 連線（`mode tcp`）；L7 = 解析 HTTP，能依 URL、Header 分流（`mode http`） | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| label | PV 最前面幾個磁區的標籤，記 PV UUID 與 metadata 區的位置 | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| label / `relabel_configs` | Loki 的索引鍵 / 把 journal 欄位（`__journal__systemd_unit`）轉成 label 的規則 | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| `label=disable` / `--privileged` | 前者只關 SELinux 標籤；後者連 capability、seccomp、裝置隔離一起關 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| Landscape | Canonical 的多主機集中管理平台 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| `LANG` / `LC_*` | 指定 locale 的環境變數：`LANG` 是所有類別的預設，`LC_TIME`、`LC_COLLATE` 等可個別覆寫，`LC_ALL` 強制全部 | [02-初始設定](02-初始設定.md) · 2.2 語系（locale） |
| langpacks-\* / glibc-langpack-\* | 🔵 Fedora 把各語言預先編譯好的 locale 拆成套件：`glibc-langpack-zh` 提供 locale 本體，`langpacks-zh_TW` 是中介套件，順便拉進字型、輸入法與翻譯 | [02-初始設定](02-初始設定.md) · 2.2 語系（locale） |
| last | 讀 `/var/log/wtmp` 列出登入 / 重開機紀錄 | [12-監控與故障排除](12-監控與故障排除.md) · 2. 故障排除方法論 |
| `lastlog` | 每個帳號最後一次登入的紀錄檔與同名指令 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| Launchpad | Canonical 的開發協作平台，PPA、Ubuntu 的 bug 追蹤與原始碼託管都在上面 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.3 社群套件庫：PPA vs COPR |
| leader lease | 在 DCS 裡帶 TTL 的「我是 primary」租約，leader 必須定期續約 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| leader 執行 / lease | 排程任務只讓一台執行：用 DB 鎖或 etcd 帶 TTL 的租約搶「leader」身分 | [10-高可用設計](10-高可用設計.md) · 7.1 應用無狀態化 |
| legacy GRUB / GRUB 2 | 舊版 GRUB 0.9x 與現行的 GRUB 2 | [00-差異速查表](00-差異速查表.md) · 6. 常用路徑對照 |
| Let's Encrypt | 免費、自動化的公開 CA | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| level 範圍 `s0-s0:c0.c1023` | 「最低 level - 最高 level」；`c0.c1023` 表示全部類別 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| level（MLS / MCS） | context 第四欄：`sensitivity:category`（如 `s0:c1,c2`）；targeted 下 sensitivity 永遠是 `s0` | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| LE（Logical Extent） | LV 內部的邏輯塊，一對一對應到某個 PV 的某個 PE | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| libvirt | 統一的虛擬化管理 API 與 daemon，用 XML 描述 VM、虛擬網路（`net-list`）與儲存池（`pool-list`） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| libvirtd / modular daemons | 🟠 `libvirtd` 是單一 daemon；🔵 拆成 `virtqemud`、`virtnetworkd`、`virtstoraged` 等各管一塊 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| limit | 同一來源 30 秒內超過 6 次新連線就拒絕的速率限制規則 | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| LimitNOFILE | unit 的檔案描述子上限（09 章 §6） | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| LimitNOFILE / DefaultLimitNOFILE | systemd unit 的 `[Service]` 選項 / `system.conf` 的全域預設 | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| `LimitNOFILE=` / `DefaultLimitNOFILE=` | systemd 單元檔與全域設定裡對應 `nofile` 的鍵（其他如 `LimitNPROC=`） | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| `limits.conf` / `limits.d/` | `pam_limits` 的設定檔，格式「誰 soft/hard 項目 值」 | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| linear（線性） | 預設 segtype：LE 依序對應到 PE，先填滿一個 PV 再用下一個 | [15-LVM進階](15-LVM進階.md) · 2. 條帶化（Striped）與 RAID LV |
| linger | logind 的旗標：即使沒有 session 也保留該使用者的 systemd 實例 | [04-系統管理](04-系統管理.md) · 1.6 使用者層級服務 |
| `linuxefi` / `initrdefi` | 舊版 GRUB 在 UEFI 下載入核心 / initrd 的專用指令 | [14-UEFI進階](14-UEFI進階.md) · 10. PXE / HTTP Boot 與網路安裝（UEFI 版） |
| `linuxx64.efi.stub` | 即 systemd-stub，做 UKI 時包在最前面的啟動程式（§7） | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| listen | frontend + backend 合併寫在一段的簡寫 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| listening socket / 攻擊面 | 服務在某個埠等待連線；每個在聽的 socket 都是外部碰得到的程式碼 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| Live 映像 | 可直接開機進完整桌面試用、再從桌面點「安裝」的 ISO | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| Livepatch | Canonical 的核心即時修補服務，不重開機就套用核心安全修補 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| Livepatch / kpatch | 不重開機套用核心修補：Livepatch 是 Canonical 的服務（§1）；kpatch 是 Red Hat 的開源機制 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| lm-sensors | 讀主機板溫度、電壓、風扇的工具（🟠 `lm-sensors`、🔵 `lm_sensors`） | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| load / %wa | load average 含等 I/O 的程序；`%wa` 是 CPU 閒著等 I/O 的比例（09 章 §1） | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| load average | `uptime` 顯示的 1 / 5 / 15 分鐘平均「可執行 + 不可中斷等待（D 狀態）」程序數 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| `loader.conf` | systemd-boot 的全域設定：預設項目、逾時秒數 | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| `local0`～`local7` | syslog 保留給本地自訂用途的 8 個 facility | [07-日誌管理](07-日誌管理.md) · 3.2 自訂規則範例 |
| locale | glibc 對「語言、字元編碼、排序、日期與數字格式」的一組設定，名稱如 `en_US.UTF-8`（語言_地區.編碼） | [02-初始設定](02-初始設定.md) · 2.2 語系（locale） |
| locale-gen / update-locale | 🟠 Debian 系工具：`locale-gen` 依 `/etc/locale.gen` 從 `/usr/share/i18n` 原始資料編譯出 locale；`update-locale` 把 `LANG=` 寫進 `/etc/default/locale` 設定系統預設 | [02-初始設定](02-初始設定.md) · 2.2 語系（locale） |
| localectl | systemd 的語系 / 鍵盤配置指令，查看兩邊通用；設定時寫入 `/etc/locale.conf` | [02-初始設定](02-初始設定.md) · 2.2 語系（locale） |
| `lock-frontend` 與 `unattended-upgrades` | 🟠 `lock-frontend` 是 apt 系列前端共用的鎖檔（§1）；`unattended-upgrades` 是每日自動安裝安全性更新的服務，由 `apt-daily-upgrade.timer` 觸發 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| lockdown | 核心在 Secure Boot 開啟時自動進入的模式：拒載未簽模組、禁寫 `/dev/mem`、限制 kexec | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `lockdown=` 核心參數 | 手動指定 lockdown 等級的參數 | [14-UEFI進階](14-UEFI進階.md) · 4.4 Secure Boot 相關故障 |
| lockdown（integrity / confidentiality） | 核心的自我限制模式：integrity 禁止修改執行中的核心（未簽模組、`/dev/mem`、kexec）；confidentiality 再禁止讀取核心記憶體 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| `logger` / `systemd-cat` | 從 shell 寫入日誌的兩個工具：前者走 syslog 協定、後者直接走 journal 原生介面 | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| `logging_log_file(T)` / `files_type(T)` | 宣告 T 是日誌檔 type（logrotate 等日誌 domain 認得）/ 一般檔案 type | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| login shell / `nologin` | `/etc/passwd` 最後一欄，登入時啟動的程式；`nologin` 是「印一句拒絕訊息後退出」的假 shell | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| login shell vs interactive shell | 登入（console、SSH）時的第一個 shell 是 login shell，讀 `/etc/profile` → `~/.profile`；之後開的每個終端機是 interactive shell，讀全域 bashrc（🟠 `/etc/bash.bashrc`、🔵 `/etc/bashrc`）→ `~/.bashrc` | [02-初始設定](02-初始設定.md) · 9.4 Shell 環境 |
| `loginctl enable-linger` | 讓該使用者的 systemd user session 在未登入時也持續存在 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| logind / `loginctl` | `systemd-logind` 負責追蹤登入 session 與使用者實例；`loginctl` 是它的 CLI | [04-系統管理](04-系統管理.md) · 1.6 使用者層級服務 |
| LogoFAIL（2023） | UEFI 韌體解析開機 logo 圖片的漏洞，惡意圖片可在 Secure Boot 之前執行程式碼 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| logrotate | 定期把日誌檔改名、壓縮、刪舊的工具（設定在 `/etc/logrotate.d/`） | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| logrotate / `dateext` | 定期把文字日誌改名、壓縮、刪舊的工具；`dateext` 是「輪替後檔名帶日期」的選項 | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| `logrotate.conf` / `logrotate.d/` | 全域預設（weekly、rotate 4…）/ 每個套件或應用的個別設定，個別設定覆蓋全域 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| Loki | Grafana Labs 的日誌儲存：只對 label（主機、unit、job）建索引，訊息本文壓縮存放 | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| Loki + Promtail / Alloy、Vector、Filebeat | 現代集中式方案的收集端與儲存端 | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| Loki / ELK | 兩套日誌集中系統：Loki 只索引標籤（輕量、與 Grafana 同家）；ELK（Elasticsearch + Logstash + Kibana）全文索引（重量） | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| `lsblk` | 列出所有區塊裝置（整顆磁碟與其分割區）及大小、型號、介面的指令 | [01-系統安裝](01-系統安裝.md) · 1.3 製作開機 USB |
| `lsblk -f` / `fstab` | 目前的裝置、檔案系統與 UUID 清單 / 掛載表 | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| `lsblk` / `lspci` / `lscpu` | 分別列磁碟（含序號）、PCI 裝置、CPU | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| `lshw` / `inxi` | `lshw` 掃描所有硬體並可輸出 JSON；`inxi` 把常見資訊排成一頁給人看 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| LSM | Linux Security Modules：核心內建的安全掛鉤框架，每個系統呼叫在 DAC 之後多呼叫一次掛鉤 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| `lsmod` / `modinfo` / `modprobe` | 列出已載入 / 顯示模組資訊與參數 / 載入（含相依）或 `-r` 卸載 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| `lsof +L1` | 列出連結數為 0（已刪除）但仍被開啟的檔案 | [07-日誌管理](07-日誌管理.md) · 9. 日誌相關故障排除 |
| `lsof` / `ss` | 列出開啟的檔案（含 socket）/ 列出 socket 與監聽埠 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| LTS | Long Term Support，Ubuntu 每兩年（偶數年 4 月）發布的長期支援版，標準支援 5 年 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| LTS / HWE | Ubuntu LTS 五年固定同一核心大版本；HWE（Hardware Enablement）是為 LTS 額外提供的較新核心 | [04-系統管理](04-系統管理.md) · 5.1 核心版本與套件 |
| LUKS | Linux 全碟加密標準，開機時輸入密碼解鎖 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| LUKS / LUKS2 | Linux Unified Key Setup，磁碟加密的標準格式：定義 header 與 keyslot 的佈局 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| LUKS / LVM | 全碟加密 / 邏輯卷管理 | [12-監控與故障排除](12-監控與故障排除.md) · 3.1 進入救援環境 |
| LUKS / systemd-cryptenroll | Linux 全碟加密格式，與把解鎖金鑰封進 TPM（綁 PCR）、加 PIN、產生救援金鑰的工具 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| LUKS header | 全碟加密分割區開頭的中繼資料，含金鑰槽 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| LUKS header / 金鑰槽 | 加密分割區開頭的中繼資料，內含以密碼包裝的主金鑰（金鑰槽） | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| LUKS keyslot | LUKS header 裡的金鑰槽，每槽可用不同方式（密碼、TPM、救援金鑰）解出同一把主金鑰 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| LUKS1 / LUKS2 | LUKS 的兩代磁頭格式：LUKS2（現行預設）支援多金鑰槽、Argon2 金鑰衍生、TPM 綁定 | [01-系統安裝](01-系統安裝.md) · 2.4 全碟加密（LUKS） |
| LUN | Logical Unit Number，target 對外呈現的每一顆「碟」的編號 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| `lvconvert --merge` | 把快照的內容合併回原 LV，等於回滾到快照時點 | [11-備份與災難復原](11-備份與災難復原.md) · 6.1 LVM 快照（兩者；伺服器常用） |
| `lvconvert --repair` / `--replace` | 用 VG 內空閒 PV 頂替已壞的副本 / 主動把某 PV 上的副本搬到另一 PV | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| `lvcreate -s` | 對某個 LV 建立 COW 快照 LV，`-L` 指定保留多少空間給被改寫的舊區塊 | [11-備份與災難復原](11-備份與災難復原.md) · 6.1 LVM 快照（兩者；伺服器常用） |
| `lvextend -r` | 放大 LV，並在完成後自動呼叫檔案系統自己的放大工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.2 線上擴充（最常用；已實測） |
| LVFS | Linux Vendor Firmware Service，廠商上傳簽章過韌體的公開倉庫 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| LVM | Logical Volume Manager：把磁碟抽象成 PV → VG → LV，可線上調整大小與做快照 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| LVM metadata / `vgcfgbackup` | VG 的結構描述（哪些 PV、LV 大小與位置）；`vgcfgbackup` 匯出、`vgcfgrestore` 還原 | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| LVM 快照（snapshot） | 在 VG 內為某個 LV 建立的即時凍結副本，只記錄之後變動的區塊 | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| `lvm2-monitor.service` / `dm-event.socket` | 開機時把已啟用的 LV 註冊給 dmeventd 的單元 / 讓 dmeventd 隨需啟動的 socket | [15-LVM進階](15-LVM進階.md) · 9. 監控、效能與 dmeventd |
| `lvmdevices` | 管理 devices file 的指令（列出、加、刪、檢查、更新 ID） | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| lvmdump | 打包 metadata、dm 表、log 的診斷工具 | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| lvmlockd | LVM 的叢集鎖管理員 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| lvmlockd（sanlock / dlm） | LVM 的叢集鎖管理員；兩種後端：sanlock 用共用磁碟上的租約、dlm 用叢集網路 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| LVS / IPVS | Linux Virtual Server，核心層的 L4 負載平衡（`ipvsadm`），效能極高但沒有 L7 功能 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| LV（Logical Volume） | 從 VG 切出、被當成「分割區」拿去格式化與掛載的邏輯卷，`lvcreate` 建立、`lvextend` 放大 | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| LXD | Canonical 的系統容器與 VM 管理器，只以 snap 發行；`lxc` 是它的 CLI | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| Lynis | CISOfy 維護的開源健檢腳本，跑一次列出數百項檢查與建議 | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| MAC | 由系統政策強制（mandatory）決定，程序與擁有者都改不了（與 §3 的 MAC 訊息驗證碼只是縮寫相同） | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| MAC / AppArmor / SELinux | 強制存取控制：由核心強制、連 root 也受限的權限系統；AppArmor 以「路徑」寫規則，SELinux 以「標籤（context）」寫規則 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| machine-id | `/etc/machine-id`，systemd 為每台機器產生的唯一 ID；journald、DHCP client-id、資產工具都拿它辨識主機 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| MAC（MACs） | Message Authentication Code，驗證每個封包沒被竄改（與 §5 的 MAC 強制存取控制只是縮寫相同） | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| MAC（SELinux / AppArmor） | 強制存取控制：🔵 SELinux 依標籤、🟠 AppArmor 依 profile 限制程序能碰什麼 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| `mail` / mailx / mailutils / s-nail | 命令列寫信程式（MUA）；`mailx` 相容指令 🟠 由 `mailutils` 提供、🔵 由 `s-nail` 提供 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| `MAILTO` / MTA | crontab 頂端變數指定輸出寄給誰；MTA 是實際寄信的程式 | [04-系統管理](04-系統管理.md) · 4.1 cron |
| main / universe | Ubuntu 套件庫的兩個區：main 由 Canonical 負責安全維護，universe 由社群維護、Canonical 不保證修補 | [08-安全強化](08-安全強化.md) · 1.2 Live patch 與延伸支援 |
| mariabackup | MariaDB 的熱物理備份工具（Percona XtraBackup 分支） | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| mariadb-dump `--single-transaction` | 在一個一致性快照交易內匯出，InnoDB 不需鎖表 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| mask / unmask | 把 unit 檔連結到 `/dev/null`，讓它連被相依關係拉起都不可能 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| masquerade ／ forward-port | zone 層級的 NAT 開關／port forward 規則（定義見 §6） | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| MASTER / BACKUP | MASTER 是目前持有 VIP、送通告的節點；BACKUP 是等待接管的節點 | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| master-eligible / replica shard | Elasticsearch 中可被選為叢集協調者的節點 / 每個索引分片的副本 | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| Match | sshd_config 的條件區塊，依使用者 / 群組 / 來源 IP 覆寫設定 | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| `Match` 區塊 | `sshd_config` 內依 `User` / `Group` / `Address` 條件套用不同設定的段落，必須放在檔案（或 drop-in）末尾 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `match: name` | netplan 語法（§3）：用萬用字元比對網卡名稱，而非寫死 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| max_map_count | 單一程序可擁有的記憶體映射區段（mmap）數上限 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| MaxAuthTries / MaxStartups / LoginGraceTime | 單一連線可嘗試認證的次數 / 同時處於「尚未認證」狀態的連線上限（`10:30:60` = 超過 10 條開始隨機拒絕，到 60 條全拒）/ 認證必須在幾秒內完成 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| `MaxRetentionSec=` / `MaxFileSec=` | 保留期限 / 多久強制切一個新檔 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| MBR | 1983 年起的舊格式：整張表塞在第一個磁區、用 32 位元記錄磁區號 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| MBR / GPT | 兩種分割表格式：MBR 是 BIOS 時代的（≤ 2 TB、4 個主分割），GPT 是 UEFI 規範要求的 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `mbr2gpt` | Windows 內建的 MBR → GPT 無損轉換工具 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| MCE | Machine Check Exception，CPU 回報的硬體錯誤（記憶體位元錯誤、匯流排錯誤），記在 `dmesg` | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| MCS（Multi-Category Security）/ category | 只用類別（c0…c1023）做水平隔離，類別之間沒有高低 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| MCS（Multi-Category Security）/ 類別 | context 第四欄的 `cX,cY` 類別對；runtime 為每個容器隨機挑兩個類別 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| mdadm | Linux 軟體 RAID（核心 md 子系統）的管理工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| `mdadm.conf` | 陣列 UUID 與裝置名的對應清單（🟠 `/etc/mdadm/mdadm.conf`、🔵 `/etc/mdadm.conf`） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| MemoryMax / MemoryHigh | Max 是硬上限，到頂就對該 cgroup 執行 OOM kill；High 是軟上限，超過就節流並積極回收 | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| `MemoryMax=` / `CPUQuota=` | 透過 service 的 cgroup（§1.1）設定記憶體與 CPU 上限 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| memtester / memtest86+ | 線上（OS 內）/ 離線（開機時）記憶體測試 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| meta-data | 平台提供的實例資訊：instance-id、主機名、網路設定等（`cloud-init query` 看得到） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| meta-disk internal | DRBD 的中繼資料（哪些區塊還沒同步）放在同一顆底層裝置的尾端 | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| metadata | LVM 記錄「哪個 VG 有哪些 PV、每個 LV 由哪些 PE 組成」的文字描述，存在每個 PV 開頭 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.6 其他 |
| metadata 區（`--metadatasize` / `--metadatacopies`） | PV 上保留給 metadata 的空間大小與份數 | [15-LVM進階](15-LVM進階.md) · 1.1 PE 大小與對齊 |
| metadata（索引） | 套件庫端產生的「有哪些套件、版本、相依、檔案清單」目錄檔，高階工具先下載它才知道有什麼可裝 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| metapackage / group | 把一組套件綁在一起：🟠 metapackage 是內容為空、只有相依的套件（`build-essential`）；🔵 group 是套件庫索引裡的群組定義 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| metric | 路由的優先權數字，越小越優先 | [05-網路與防火牆](05-網路與防火牆.md) · 3.2 靜態 IP / DHCP |
| MicroK8s / OKD / Quadlet | MicroK8s = Canonical 的單機到小叢集 Kubernetes（snap）；OKD = OpenShift 的社群版；Quadlet = 用 systemd 單元管理 Podman 容器 | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| Microsoft UEFI CA | Microsoft 專門用來簽第三方（非 Windows）開機程式的憑證 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| mii-monitor-interval | bonding 每隔多少毫秒檢查一次成員線的 link 狀態（核心參數名 `miimon`） | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| min_free_kbytes | 核心保留給自己緊急使用（如網路封包配置）的最低空閒記憶體 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| MinIO / SeaweedFS | 輕量的 S3 相容物件儲存伺服器 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| `minlen` / `minclass` / `maxrepeat` | pwquality 三個最常用的參數：最短長度、至少幾種字元類別（大寫 / 小寫 / 數字 / 符號）、同一字元最多連續幾次 | [02-初始設定](02-初始設定.md) · 3.4 密碼與帳號政策 |
| mirror / raid1 | 每筆資料寫到兩個以上 PV | [15-LVM進階](15-LVM進階.md) · 2. 條帶化（Striped）與 RAID LV |
| `missingok` / `notifempty` | 檔案不存在不報錯 / 空檔不輪替 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| mitigations | 核心對 Spectre / Meltdown 等 CPU 推測執行漏洞的軟體緩解措施 | [09-性能調校](09-性能調校.md) · 2. CPU |
| `mitigations=off` | 關閉 CPU 漏洞（Spectre / Meltdown）緩解措施的核心參數 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| `mkfs.*` | 在區塊裝置上寫入檔案系統結構的工具家族 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| `mkrescue` / `mkbackup` | 只做救援 ISO / 做 ISO + 資料備份 | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| MLS（Multi-Level Security）/ sensitivity | 依機密等級（s0 < s1 < …）垂直分級的模型：低不能讀高、高不能寫低 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| `modinfo` 的 `sig_key` / `signer` | 模組內嵌簽章的資訊 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| `modules/400/<名>/` | 模組在政策庫中的存放目錄（內含 cil、hll、lang_ext 三個檔） | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| MOK | Machine Owner Key，機器擁有者自己登錄到 shim 的憑證 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| MOK / MokManager / mokutil | Machine Owner Key：機器擁有者自己登錄進 shim 的憑證；MokManager（`mmx64.efi`）是開機時的登錄畫面；`mokutil` 是從 Linux 提出登錄請求與查狀態的 CLI | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| MOK.priv / MOK.der / MOK.pem | 同一把 MOK 的私鑰 / DER 格式公鑰憑證 / PEM 格式公鑰憑證 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| MokManager 登錄流程 | `mokutil --import` 只是把請求與一次性密碼寫進 NVRAM，真正登錄在下次開機的藍色畫面完成 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| mokutil | 管理 MOK 的指令：`--import` 排入登錄、`--sb-state` 查 Secure Boot 狀態 | [08-安全強化](08-安全強化.md) · 6.5 Secure Boot 下的自訂核心模組 |
| `mokutil --list-sbat-revocations` / `--set-sbat-policy` | 查目前 SBAT 撤銷政策 / 設定政策要跟最新還是自動 | [14-UEFI進階](14-UEFI進階.md) · 4.4 Secure Boot 相關故障 |
| `mokutil --sb-state` | 查詢 Secure Boot 是否啟用（§1.5） | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| `mokutil --timeout` | 設 MokManager 畫面的等待秒數（-1 為永遠等） | [14-UEFI進階](14-UEFI進階.md) · 4.4 Secure Boot 相關故障 |
| MOTD | Message of the Day，登入**成功之後**由 PAM（§3.4）的 `pam_motd` 模組顯示的訊息 | [02-初始設定](02-初始設定.md) · 9.2 登入橫幅與 MOTD |
| Mozilla SSL Configuration Generator / testssl.sh / SSL Labs | Mozilla 維護的設定產生器（modern / intermediate / old 三檔）/ 本機掃描腳本 / Qualys 的線上掃描服務 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| msmtp / msmtp-mta | 只會「經 relay 送出」的極簡 MTA；🟠 `msmtp-mta` 套件把它註冊為系統的 `sendmail` | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| msmtp / MTA | MTA 是負責把信送出去的程式；msmtp 是極簡 MTA，只把信轉給外部 SMTP 伺服器 | [12-監控與故障排除](12-監控與故障排除.md) · 1.4 簡易腳本監控 + 通知 |
| MTA | Mail Transfer Agent（postfix、msmtp），能把信送出去的本機程式 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| MTBF / MTTR | 平均故障間隔 / 平均修復時間 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| MTU / DF（ping -M do） | 最大封包長度 / 設「不要分段」旗標測試路徑 MTU | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| MTU / Jumbo frame | MTU 是單一封包最大位元組數（預設 1500）；Jumbo frame 指設到 9000 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| MTU ／ PMTU | 一次能送的最大封包大小（乙太網 1500）／路徑上最小的 MTU | [05-網路與防火牆](05-網路與防火牆.md) · 10. 網路除錯流程 |
| `multi-user.target` / `graphical.target` | 文字多人模式 / 再加上圖形登入 | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| Multipass | Canonical 的一鍵 Ubuntu VM 工具，內建下載雲端映像與餵 cloud-init 設定 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| multipath（mpath） | 同一顆 SAN 碟經多條路徑出現為多個 `/dev/sdX`，由 multipathd 合成 `/dev/mapper/mpathN` | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| multiverse / restricted | 🟠 官方庫內的兩個元件（§1）：restricted 放非自由驅動、multiverse 放專利或授權受限的軟體 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.4 🔵 RPM Fusion（Fedora 必裝的第三方庫） |
| multiverse / restricted / RPM Fusion | 放非自由或有授權疑慮軟體的地方：🟠 是官方套件庫內的兩個元件；🔵 是官方以外的第三方套件庫 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| MySQL Router | InnoDB Cluster 的輕量代理，自動把應用導向目前的 primary | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| NAT ／ masquerade | NAT 是改寫封包位址；masquerade 是「來源位址改成出口網卡目前的 IP」的動態 SNAT | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| ncdu / du -x | 互動式磁碟用量瀏覽器 / 只算同一檔案系統的 du | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| `nconnect` | 客戶端掛載選項：對同一伺服器開多條 TCP 連線 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| needrestart | 🟠 掃描每個執行中程序載入的函式庫是否已被新版取代、列出需重啟服務的工具，`apt` 升級後會自動呼叫 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.2 判斷是否需要重開機 |
| neofetch / fastfetch | 顯示系統資訊與發行版 logo 的一頁式工具 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| net-tools | `ifconfig`、`netstat`、`route`、`arp` 所屬的舊套件，讀 `/proc/net` 取得狀態 | [05-網路與防火牆](05-網路與防火牆.md) · 2. 共通的觀察指令（iproute2） |
| netavark | Podman 4+ 的網路後端（取代 CNI），負責容器網路、NAT 與埠轉發 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| Netdata / Cockpit / glances | 單機即時監控：Netdata 秒級圖表、Cockpit 網頁管理介面、glances 終端機儀表板 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| netfilter | 核心內建的封包過濾與 NAT 框架，在封包路徑上提供 hook 點 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| netinst | 只帶安裝程式與最小開機環境的 ISO（數百 MB），套件全部在安裝時從網路下載 | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| netlink | 核心與使用者空間交換網路設定（位址、路由、鏈路狀態）的 socket 介面 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| Netplan | Canonical 的網路設定抽象層：讀 YAML，產生後端（renderer）的設定 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `netplan try` | 套用設定並倒數 120 秒，期間沒按 Enter 確認就自動還原 | [02-初始設定](02-初始設定.md) · 5. 網路基本設定（詳見第 05 章） |
| Network Time | 開機後由 `chronyd` 向 NTP 伺服器對時的開關 | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| `network-online.target` | 「網路已經可用（拿到 IP）」的 target | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| NetworkManager | Red Hat 開發的網路管理服務，處理有線、無線、VPN；`nmcli` / `nmtui` 是它的 CLI / TUI | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| NetworkManager / nmcli | 🔵 Fedora 的網路管理 daemon 與其 CLI；設定以「connection」為單位存成 keyfile | [02-初始設定](02-初始設定.md) · 5. 網路基本設定（詳見第 05 章） |
| NetworkManager（NM） | Red Hat 主導的網路 daemon，處理有線／Wi-Fi／VPN 與動態切換，提供 nmcli／nmtui／GUI／D-Bus 介面 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| NFS | Network File System，Linux / Unix 原生的網路檔案共享協定 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9. 網路儲存 |
| NFS 4.2 `security_label` / `httpd_use_nfs` | NFS 4.2 能把伺服器端的 xattr 傳給客戶端的選項 / 讓 httpd 讀 `nfs_t` 的 boolean | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| NFS-HA | 用 DRBD + Pacemaker（或雙控制器 NAS）讓 NFS server 能在節點間漂移 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| NFSv3 / NFSv4 | 兩代協定：v3 需要 rpcbind、mountd 等多個輔助服務與動態埠；v4 全部走 2049、有狀態、支援 ACL 與更可靠的鎖 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| nftables | Linux 核心 netfilter 的現行規則語言與工具，取代 iptables | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| nice / ionice | 分別是 CPU 排程優先權（-20～19，越大越禮讓）與 I/O 優先權（class 3 = idle） | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| `nmcli --offline` | 不連 daemon、只把指令轉成 keyfile 印到標準輸出 | [05-網路與防火牆](05-網路與防火牆.md) · 4.2 靜態 IP / DHCP |
| nmcli ／ nmtui | NM 的命令列工具／文字選單工具 | [05-網路與防火牆](05-網路與防火牆.md) · 4. 🔵 Fedora：NetworkManager（nmcli） |
| `noatime` | 掛載選項：不更新檔案的「最後存取時間」 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| noatime / relatime | 掛載選項：不更新 / 只在必要時更新檔案的存取時間（atime） | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| noauto / user | 開機不自動掛 / 允許一般使用者自行掛載 | [08-安全強化](08-安全強化.md) · 6.2 檔案系統掛載選項 |
| nobody / nogroup | 無特權的系統帳號與群組 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| NoCloud | cloud-init 的一種資料源：不靠雲平台 API，直接從本機光碟 / 磁碟（`ds=nocloud`）或 HTTP（`ds=nocloud-net`）讀 `user-data` + `meta-data` | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| `nodatacow`（`chattr +C`） | 對特定檔案或目錄關閉 COW，改為原位覆寫 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| `node.startup = automatic` | initiator 端設定：開機自動登入該 target | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| node_exporter | Prometheus 官方的主機 exporter，以 HTTP 在 9100 埠提供 `/metrics` | [12-監控與故障排除](12-監控與故障排除.md) · 1.1 node_exporter（主機指標） |
| node_exporter `--collector.selinux` / textfile collector | 前者暴露 enabled / enforcing 指標；後者讓你用 cron + ausearch 寫 AVC 計數給 Prometheus | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| nodev | 不承認此檔案系統上的裝置檔（character / block device） | [08-安全強化](08-安全強化.md) · 6.2 檔案系統掛載選項 |
| noexec | 禁止直接執行此檔案系統上的檔案 | [08-安全強化](08-安全強化.md) · 6.2 檔案系統掛載選項 |
| `noexec` / `nosuid` / `nodev` | 掛載選項：禁止在該檔案系統執行程式 / 忽略 setuid 位元 / 忽略裝置檔 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| `nofail` | 掛載選項：裝置不存在時不算開機失敗 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| nofail / _netdev | fstab 選項：`nofail` 讓裝置不存在時不阻塞開機，`_netdev` 標記為網路檔案系統、等網路好了才掛 | [09-性能調校](09-性能調校.md) · 9. 開機與服務啟動時間 |
| nofile / ulimit -n | 每個程序可開啟的描述子數上限（soft / hard 兩個值） | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| `nohup` / `setsid` / `tmux` / `screen` | 前兩者讓程式脫離終端、不被 SIGHUP 帶走；後兩者是可離線再接回的終端多工器 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| nomodeset | 核心參數：不載入顯示驅動的 kernel mode setting，用基本 VGA 顯示 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| NOPASSWD | 規則標籤，表示執行該規則涵蓋的指令時不問密碼 | [02-初始設定](02-初始設定.md) · 3.2 sudo 規則 |
| nosuid | 忽略此檔案系統上檔案的 SUID / SGID 位元 | [08-安全強化](08-安全強化.md) · 6.2 檔案系統掛載選項 |
| notify_master | 節點成為 MASTER 時執行的腳本 | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| `nouuid` | XFS 專用掛載選項，忽略「此 UUID 已被掛載」的檢查 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.4 快照（備份前必做；已實測含合併還原） |
| nouveau | 社群逆向工程寫的開源 NVIDIA 驅動，核心內建 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.4 🔵 RPM Fusion（Fedora 必裝的第三方庫） |
| NSS / `getent` | Name Service Switch：依 `/etc/nsswitch.conf` 決定帳號、主機名從哪裡查（本機檔、LDAP、SSSD）；`getent` 是走 NSS 查詢的指令 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 5. 其他常見指令 |
| NTP | Network Time Protocol，向時間伺服器對時的協定；兩者以 `chronyd` 或 `systemd-timesyncd` 實作 | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| nullok | pam_google_authenticator 的選項：使用者還沒有 `~/.google_authenticator` 時直接放行 | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| NUMA | Non-Uniform Memory Access：多路伺服器每顆 CPU 有自己「近」的記憶體，存取別顆 CPU 的記憶體延遲多 30～50% | [09-性能調校](09-性能調校.md) · 2. CPU |
| numactl / numastat | 查看 NUMA 拓撲與各程序跨 node 存取量、把程序綁到 node 的工具 | [09-性能調校](09-性能調校.md) · 2. CPU |
| NVRAM / efivarfs | 主機板上的非揮發記憶體，存 UEFI 變數（開機項、Secure Boot 金鑰、MOK 請求）；`efivarfs` 是核心把這些變數掛成 `/sys/firmware/efi/efivars` 的檔案介面 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `o=`（Origin） | Pin 條件裡的來源識別字串，官方為 `Ubuntu`，PPA 為 `LP-PPA-<擁有者>-<庫名>`（§3.3） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| Object Lock / Retention Policy | 物件在保留期內不能刪改，compliance mode 連帳號擁有者也無法解除 | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| OCSP / OCSP stapling | Online Certificate Status Protocol：查憑證是否被撤銷 / 由伺服器預先向 CA 取得帶簽章的狀態回應，隨握手一起送給客戶端 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| OEMDRV | Anaconda 會自動搜尋的磁碟標籤：找到標為 `OEMDRV` 的裝置就讀其根目錄的 `ks.cfg` | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| offload（TSO / GRO / LRO） | 把 TCP 分段 / 合併的工作交給網卡硬體做 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| `omfwd` | rsyslog 的轉送輸出模組，支援 UDP / TCP | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| on-CPU / off-CPU | on-CPU 是程序真正在用 CPU 的時間；off-CPU 是它在等（鎖、I/O、排程）的時間 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| `OnBootSec=` / `OnUnitActiveSec=` | 相對時間：開機後多久、上次執行後多久 | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| `OnCalendar=` | 類似 crontab 的絕對時間表，語法用 `systemd-analyze calendar` 驗證 | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| OnFailure= | unit 的 `[Unit]` 選項：本 unit 失敗時啟動指定的另一個 unit | [12-監控與故障排除](12-監控與故障排除.md) · 1.4 簡易腳本監控 + 通知 |
| OOM | Out Of Memory：記憶體與 swap 用盡時，核心的 OOM killer 挑一個程序殺掉自救 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| OOM killer | Out-Of-Memory killer，核心在記憶體耗盡時強制砍掉某個行程以自救的機制 | [01-系統安裝](01-系統安裝.md) · 1.4 硬體需求（實務建議） |
| OOM killer / OOMPolicy | 核心記憶體耗盡時挑程序殺掉的機制；`OOMPolicy` 決定 cgroup 內有程序被殺時整個服務要不要跟著停 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| `oom_score` / `oom_score_adj` | 每個程序的「被殺優先分數」（越高越先）與管理員可加減的調整值（-1000～1000） | [04-系統管理](04-系統管理.md) · 3.1 OOM Killer |
| `OOMScoreAdjust=` | 單元檔 `[Service]` 裡對應 `oom_score_adj` 的鍵 | [04-系統管理](04-系統管理.md) · 3.1 OOM Killer |
| open-vm-tools | VMware 的開源 guest tools，取代舊的 VMware Tools ISO | [02-初始設定](02-初始設定.md) · 9.5 虛擬機 Guest Agent |
| OpenSCAP / oscap | NIST 認證的 SCAP 掃描器與其指令（`openscap-scanner` 套件） | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| OpenSSH | 兩個發行版都用的 SSH 實作，拆成伺服器套件 `openssh-server` 與客戶端套件（🟠 `openssh-client`、🔵 `openssh-clients`） | [02-初始設定](02-初始設定.md) · 4. SSH 伺服器 |
| OpenSSH server | 提供 SSH 遠端登入的 `sshd` 服務 | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| OpenSSL / GnuTLS / NSS | 三個常見的 TLS / 加密函式庫：nginx、curl 用 OpenSSL；GNOME 類程式用 GnuTLS；Firefox、Chrome 用 NSS | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| `openssl s_client` | 手動建立 TLS 連線並印出伺服器憑證的除錯工具 | [08-安全強化](08-安全強化.md) · 9.2 內部 CA / 自簽 |
| Option ROM | 顯示卡、RAID 卡、網卡上自帶的韌體程式，由 UEFI 在開機時執行 | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| `optional: true` ／ systemd-networkd-wait-online | wait-online 是開機時等待「所有受管網卡就緒」的 systemd 服務；`optional` 把某張卡排除在等待名單外 | [05-網路與防火牆](05-網路與防火牆.md) · 3.2 靜態 IP / DHCP |
| Orchestrator | 第三方 MySQL 複製拓樸管理與自動 failover 工具 | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| `os-prober` | 掃描其他作業系統並加進選單的工具 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| os-variant / libosinfo | libosinfo 是「各 OS 版本適合什麼虛擬硬體」的資料庫；`--os-variant` 告訴 virt-install 這台 VM 要裝哪個 OS | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| OSI 分層 | 把網路拆成實體、鏈路、網路、傳輸…等層次的參考模型 | [05-網路與防火牆](05-網路與防火牆.md) · 10. 網路除錯流程 |
| osquery | 把系統狀態（套件、程序、使用者、硬體）當 SQL 表查詢的代理程式，可集中收集 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 9. 系統資訊與資產清單 |
| ostree（Silverblue / CoreOS） | 以整個檔案系統樹為單位做原子更新的不可變系統 | [14-UEFI進階](14-UEFI進階.md) · 5.2 BLS（Boot Loader Specification）— 🔵 Fedora 預設 |
| `OUTPUT_URL` / `BACKUP_URL` | 分別是救援 ISO 與資料備份的存放位置（NFS、USB、SFTP …） | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| overcommit | 核心允許程序「承諾」的虛擬記憶體總量超過實體＋swap | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| Pacemaker | 叢集資源管理器：決定每個資源該在哪個節點跑、故障時搬到哪裡 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| page cache | 核心用閒置記憶體快取磁碟內容的機制 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| PAM | Pluggable Authentication Modules，Linux 上所有需要「驗身分」的程式（login、sshd、sudo、Cockpit）共用的模組框架，設定在 `/etc/pam.d/` | [02-初始設定](02-初始設定.md) · 3.4 密碼與帳號政策 |
| PAM / `pam_limits` | PAM 是登入時的可插拔認證框架；`pam_limits` 模組在登入那一刻讀 `limits.conf` 套用 | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| PAM limits（limits.d） | PAM 在使用者登入時套用的資源限制設定檔 | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| pam-auth-update / common-auth | 🟠 Ubuntu 的對應機制：`common-auth` 等共用檔被各服務 include，`pam-auth-update` 依 `/usr/share/pam-configs/` 的片段組裝它們 | [08-安全強化](08-安全強化.md) · 2.1 密碼政策 |
| pam_faillock | 記錄登入失敗次數並暫時鎖定帳號的 PAM 模組，規則讀 `/etc/security/faillock.conf`，計數存在 `/var/run/faillock/` | [08-安全強化](08-安全強化.md) · 2.1 密碼政策 |
| pam_pwquality | PAM 模組，在使用者**改密碼**時檢查強度，設定檔 `/etc/security/pwquality.conf` | [02-初始設定](02-初始設定.md) · 3.4 密碼與帳號政策 |
| panic mode | 一鍵丟棄所有進出封包 | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| `part` / `volgroup` / `logvol` | 依序建立分割區（含 `pv.01` 這種 PV）、VG、LV 的 Kickstart 指令 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| partial / refresh needed | `lvs` 健康欄的兩種狀態：缺 PV / 底層變動後 dm 表需要重載 | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| partition type | 分割表中每個分割區的「用途標籤」（GPT 用 GUID，gdisk 以 `8e00` 等代碼表示） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| `partprobe` | 通知核心重讀分割表的工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| passphrase / BORG_PASSCOMMAND | 解鎖金鑰的密碼；`BORG_PASSCOMMAND` 指定讀取密碼的指令 | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| passphrase 與 KDF | passphrase 是加密私鑰檔的口令；KDF（`-a` 回合數）把口令反覆運算拉伸成加密金鑰，回合越多離線暴力破解越慢 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `passwd` / `chage` | 前者設密碼，後者設密碼與帳號的到期日、最短 / 最長使用天數 | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| pass（第 6 欄） | 開機時 fsck 的檢查順序 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| Patroni | 跑在每台 PostgreSQL 旁的 Python 代理，負責啟動 / 設定 PostgreSQL、與 DCS 協商 leader、執行 promote | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| patronictl | Patroni 的管理 CLI（list / switchover / failover / reload） | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| PCI passthrough / `vfio-pci` | 把整張 PCI 裝置（顯示卡）直接交給虛擬機；`vfio-pci` 是佔住裝置的存根驅動 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| PCI-DSS / STIG | 支付卡產業安全標準 / 美國國防部安全技術實作指南 | [07-日誌管理](07-日誌管理.md) · 5. 稽核日誌（auditd） |
| PCR | TPM 的 Platform Configuration Register，每一個記錄開機某階段的 hash | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| PCR 11 | systemd-stub 量測 UKI 各區段用的 PCR（§8） | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| PCR policy / `--tpm2-public-key` | 不綁 PCR 的固定值，而是綁「用這把公鑰簽過的 PCR 11 預期值」 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| pcs / pcsd | `pcs` 是設定 Corosync + Pacemaker 的統一 CLI；`pcsd`（2224/tcp）是讓 pcs 跨節點操作的 daemon | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| PDU | Power Distribution Unit，機櫃的配電排插 | [10-高可用設計](10-高可用設計.md) · 7.3 網路層冗餘 |
| PE 檔 | Portable Executable，Windows 與 UEFI 共用的執行檔格式；所有 `.efi` 都是 PE | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| peer | 隧道另一端的一個節點，以 `[Peer]` 區段描述 | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| PEP 668 / externally-managed-environment | Python 官方規範：發行版可在系統 Python 放一個 `EXTERNALLY-MANAGED` 標記檔，`pip` 看到就拒絕安裝到系統目錄並印出這個錯誤 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| perf | 核心內建 perf_events 子系統的命令列工具，用硬體計數器與取樣找出 CPU 熱點 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| perf top / py-spy / jstack / pprof | 通用 CPU 熱點 / Python / Java / Go 各語言的取樣分析器 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| perf_event_paranoid | 限制非 root 使用 perf 效能計數器 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| permissive domain / `permissive D;` / `semanage permissive` | 只讓 D 這一個 domain「記錄不阻擋」，其他 domain 仍 enforcing | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| `permissive=0/1` | 0 表示真的擋了；1 表示只記錄沒擋 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| Persistent timer | systemd timer 的 `Persistent=true`：錯過的排程在開機後補跑 | [10-高可用設計](10-高可用設計.md) · 8. HA 測試（每季演練清單） |
| `Persistent=` | 記錄上次執行時間，若關機期間錯過就在下次開機補跑 | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| pesign | Red Hat 開發的同類工具，支援 NSS 資料庫與硬體簽章模組 | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| PE（Physical Extent） | VG 的配置單位，預設 4 MiB | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3. LVM（Logical Volume Manager） |
| pg_basebackup | 取得一致的 PostgreSQL 資料目錄複本（物理備份）的官方工具 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| pg_dump / pg_dumpall / `-Fc` | 單庫 / 全叢集（含角色）邏輯備份；`-Fc` 自訂格式可壓縮、可用 `pg_restore` 選表還原 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| pgBackRest / Barman | 第三方 PostgreSQL 備份管理工具：自動 base + WAL 歸檔、保留策略、平行與增量、一鍵 PITR | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| pgbench | PostgreSQL 內建的 TPC-B 型交易基準 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| PID / 主程序 | 程序識別碼；systemd 為每個 service 記錄一個「主程序」（MainPID），用它判斷服務是否還活著 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| pid_max / threads-max | 整台機器可用的 PID 數 / 執行緒數上限 | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| `PIDFile=` | 傳統 daemon fork 後把子程序 PID 寫進的檔案 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| PIN | 綁 TPM 之外再要求輸入的短密碼，TPM 內部驗證、有錯誤次數鎖定 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| Pinning / Pin-Priority | 🟠 `/etc/apt/preferences.d/` 內的規則：對符合條件（套件名、來源 `o=`、版本）的候選版本指定優先權數字，apt 選版本時取最高者 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| PipeWire / BlueZ | PipeWire 是統一處理音訊與視訊串流的服務（取代 PulseAudio）；BlueZ 是 Linux 藍牙堆疊 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| pipx | 專給「命令列工具」用的安裝器：每個工具自動建一個 venv，再把執行檔連結到 `~/.local/bin` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| PITR | Point-in-Time Recovery：從物理備份出發重放日誌到指定時刻 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| PK / KEK / db / dbx | Secure Boot 的四層金鑰：PK 主機板廠商擁有者金鑰 → KEK 授權改 db / dbx → db 允許清單 → dbx 撤銷清單（§4.1） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| PK（Platform Key） | 主機板廠商的「平台擁有者」金鑰，一台機器只有一把 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| playbook | 一份 YAML，描述「對哪些主機、依序執行哪些 task」 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| plymouth | 開機畫面（splash）程式 | [07-日誌管理](07-日誌管理.md) · 7. 應用程式日誌慣例 |
| PodDisruptionBudget | 宣告「任何時候至少要有幾個 Pod 可用」，限制節點維護時的驅逐速度 | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| Podman | Red Hat 主導、指令與 Docker 相容、不需常駐守護程序的容器引擎 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| `podman auto-update` | 檢查帶 `AutoUpdate=registry` 的容器，其映像 tag 在 registry 上是否有新版，有就拉新並重啟 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.2 Quadlet（Podman 4.4+，兩者皆可） |
| policy | firewalld 1.0 新增：定義「從 zone A 到 zone B」轉送流量的規則 | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| policy routing ／ `ip rule` | 核心的 RPDB（routing policy database）：依來源位址、標記、入口網卡等條件決定「查哪張表」的規則清單 | [05-網路與防火牆](05-網路與防火牆.md) · 9.2 Policy routing（多 WAN / 來源路由） |
| `policy.35` | 把政策庫所有模組編譯成的二進位檔，檔名數字是政策格式版本；核心開機載入的就是它 | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| `policy_module()` / refpolicy 巨集 | `.te` 開頭宣告「這是 refpolicy 模組」的巨集；巨集是 m4 定義，一行展開成多條規則 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `policy_module(名, 版本)` | `.te` 開頭的巨集：宣告模組名稱與版本，並自動 require 基礎 class 與核心 type | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| POODLE / BEAST | 兩個針對 SSL 3.0 / TLS 1.0 + CBC 的著名攻擊 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| pool / dataset | pool（`tank`）是一群磁碟組成的儲存池；dataset（`tank/data`）是池內可獨立設定與快照的檔案系統 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| pool / iburst | `chrony.conf` 的來源設定：`pool` 指向一個會解析出多台伺服器的名稱，`iburst` 讓剛啟動時連發多個封包以加快首次同步 | [02-初始設定](02-初始設定.md) · 2.1 時間同步（NTP） |
| pool（zpool） | ZFS 管理的一組磁碟，同時扮演 LVM 的 VG 角色 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.5 ZFS（🟠 Ubuntu 原生支援） |
| port | 直接以埠號／協定放行 | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| port forward（REDIRECT ／ DNAT） | 把進來的封包改送到別的埠（REDIRECT，本機）或別的主機（DNAT） | [05-網路與防火牆](05-網路與防火牆.md) · 6. 🟠 Ubuntu：ufw |
| portcon / genfscon / fs_use | 政策內建的「埠 → type」「特殊檔案系統（proc、sysfs）→ type」「各檔案系統怎麼取得標籤（xattr / 固定值 / 依建立者）」規則 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| postfix | 功能完整的 MTA，可收可送、可排隊重試 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| `postgresql-setup --initdb` | 🔵 Fedora 打包的 PostgreSQL 初始化腳本，建立 `/var/lib/pgsql/data` 資料目錄 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| postinst | 🟠 Debian 套件安裝後自動執行的腳本 | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| `postrotate` / `sharedscripts` / HUP | 輪替後執行的腳本 / 多個檔案只跑一次腳本 / 送給程式的「重開檔案」信號 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| power-profiles-daemon / tuned-ppd | 提供「省電 / 平衡 / 效能」切換的服務；🔵 42 起改用 tuned 的相容實作 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| PPA / COPR | 個人套件庫：使用者上傳原始碼，由 Launchpad / Fedora 建置系統代為編譯並提供套件庫 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| PPA（Personal Package Archive） | 🟠 Launchpad 上任何人都能建立的個人套件庫，Canonical 的建置農場代為編譯出各版 Ubuntu 的 `.deb` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.3 社群套件庫：PPA vs COPR |
| predictable interface names | systemd 依 PCI／韌體位置命名網卡（`enp0s3`、`ens18`、`eno1`）的規則 | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| preempt / nopreempt | 搶佔：priority 較高的節點復活時是否立刻搶回 VIP | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| preseed / debian-installer | Debian 傳統安裝程式（d-i）與它的問答預填格式 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| primary / replica | primary 是唯一接受寫入的節點；replica 透過複製接收變更，通常只供讀 | [10-高可用設計](10-高可用設計.md) · 6. 資料庫高可用 |
| primary / secondary | primary 是可讀寫的一端；secondary 只接收複製、不能掛載 | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| priority | 同一 hook 上多條 chain 的執行順序 | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| priority / `-X` | 同名模組可並存多個優先權，最高者生效；`-X` 指定安裝到哪個優先權 | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `priority=` / `exclude=` | 🔵 `.repo` 檔內的欄位：priority 數字越小越優先（預設 99），exclude 列出該 repo 不提供的套件 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| priority（`-p`） | syslog 的 8 級嚴重度：emerg alert crit err warning notice info debug | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| PrivDrop | rsyslog 啟動後放棄 root、改用低權限使用者執行 | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| process substitution | bash 把 `>(cmd)` 換成一個暫時的檔名（如 `/dev/fd/63`），寫進去的資料就成為 `cmd` 的 stdin；`<(cmd)` 則反向，讀它等於讀 `cmd` 的 stdout | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 1.4 tee 的其他實用場景 |
| process substitution（`>( )` / `<( )`） | 把一個指令的 stdin / stdout 偽裝成檔名，讓只接受檔案參數的程式也能接管線 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| profile | 一份文字檔（`/etc/apparmor.d/`），以「執行檔路徑」為開頭，列出它能讀寫執行哪些路徑、能開哪些網路、能用哪些 capability；沒列的一律拒絕 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| profile / label（context） | AppArmor 的政策檔 / SELinux 貼在每個物件上的標籤 | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| profile（XCCDF profile） | DataStream 內的一組規則選集，如 `xccdf_org.ssgproject.content_profile_cis` | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| Prometheus | 拉取式（pull）時序資料庫兼告警規則引擎 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| Prometheus textfile collector | node_exporter 讀取指定目錄下 `.prom` 檔的機制，讓腳本能匯出自訂指標 | [11-備份與災難復原](11-備份與災難復原.md) · 10.3 備份監控 |
| promote | 把一台 replica 升級為 primary 的動作 | [10-高可用設計](10-高可用設計.md) · 6. 資料庫高可用 |
| `Prompt=`（`release-upgrades`） | 🟠 `/etc/update-manager/release-upgrades` 的設定值：`lts` 只提示 LTS→LTS、`normal` 提示每個半年版、`never` 不提示 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🟠 Ubuntu：`do-release-upgrade` |
| PromQL | Prometheus 的查詢語言，用於儀表板與告警規則的 `expr` | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| Promtail / Grafana Alloy | Loki 的官方收集端；Alloy 是 Promtail 的後繼（Promtail 已進入維護模式） | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| promtool | Prometheus 附的檢查工具（`check config` / `check rules`） | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| protected_symlinks / hardlinks / fifos / regular | 在全域可寫且有 sticky bit 的目錄（`/tmp`）內，限制 root 程式跟隨他人建立的 symlink、hardlink、FIFO 或一般檔案 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| protocol A / B / C | 寫入何時算完成：A = 寫進本機就完成（非同步）、B = 送到對端記憶體、C = 對端寫進磁碟才完成（同步） | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| Proxmox HA | Proxmox VE 內建的 HA 管理器，host 掛了自動在別台重啟 VM | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| Proxy / Mirror | Proxy 是安裝程式對外連線經過的代理伺服器；Mirror 是套件庫的鏡像站 | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| ProxyJump（`ssh -J`） | 先連跳板、在跳板上開一條到目標的 TCP 通道、再在通道內做一次完整的「本機 ↔ 目標」SSH | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| ProxySQL / MaxScale | MySQL 專用的智慧代理（讀寫分離、依節點狀態路由） | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| prune / compact | prune 依保留策略標記過期 archive；compact 才真正回收空間 | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| PSI（Pressure Stall Information） | 核心提供的資源壓力指標：程序因等記憶體而停滯的時間比例 | [04-系統管理](04-系統管理.md) · 3.1 OOM Killer |
| PSK | Pre-Shared Key：家用／小型網路常見的「一組密碼大家共用」認證方式（`key-management: psk`） | [05-網路與防火牆](05-網路與防火牆.md) · 3.4 Wi-Fi（Desktop 通常用 NM GUI；Server 也可） |
| PTP / linuxptp | Precision Time Protocol（IEEE 1588），靠網卡硬體時戳達到微秒級精度；`linuxptp` 是 Linux 實作 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 5. 時間服務：當 NTP 伺服器 |
| ptrace | 讓一個程序讀寫、控制另一個程序的系統呼叫，除錯器（gdb、strace）都靠它 | [08-安全強化](08-安全強化.md) · 6. 核心與系統層 |
| ptrace_scope（Yama） | Yama 安全模組的開關：`0` 同使用者可任意 attach、`1` 只能 attach 自己的子程序、`2` 只有 root、`3` 完全禁止 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| PV / VG / LV | LVM 的三個物件：原料裝置 / 儲存池 / 從池切出的邏輯卷（06 章 §3） | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| PV / VG / LV 與 metadata archive | LVM 的三層（實體卷、卷群組、邏輯卷）；`/etc/lvm/archive` 是每次變更前自動備份的 metadata | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| PV label | PV 開頭的標籤（§1） | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| `pvmove` | 把某個 PV 上的 PE 線上搬到 VG 內其他 PV | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.6 其他 |
| `pvresize` | 讓 PV 的 metadata 認到底下裝置的新大小 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.2 線上擴充（最常用；已實測） |
| PV（Physical Volume） | 被 LVM 接管的區塊裝置（分割區、整顆磁碟或解鎖後的 LUKS 裝置），`pvcreate` 建立 | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| PXE | 讓機器一開機就從網路取得開機程式與安裝程式的機制（§5.3） | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| PXE / HTTP Boot | 從網路載入開機檔的兩種機制：PXE 用 DHCP + TFTP，HTTP Boot 用 DHCP + HTTP(S)（§10） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `pxelinux.0` | syslinux 的 BIOS 版網路開機程式 | [14-UEFI進階](14-UEFI進階.md) · 10. PXE / HTTP Boot 與網路安裝（UEFI 版） |
| `python3-dnf-plugin-snapper` | 讓 dnf 在交易前後自動呼叫 snapper 拍快照的外掛 | [11-備份與災難復原](11-備份與災難復原.md) · 6.2 Btrfs 快照（🔵 Fedora Workstation 預設） |
| qcow2 | QEMU 的磁碟映像格式，支援稀疏存放、快照與以另一個映像為基底（backing file） | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| qcow2 外部快照 / overlay | `--disk-only` 快照把之後的寫入導到新的 overlay 檔，原檔成為唯讀基底 | [11-備份與災難復原](11-備份與災難復原.md) · 6.4 虛擬機 / 雲端快照 |
| qdevice / qnetd | 在第三台跑的仲裁服務（`corosync-qnetd`），向叢集投第三票 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| qdisc（fq / fq_codel） | 佇列規則：決定封包從核心送出到網卡的排程；`fq` 依流公平排程，`fq_codel` 再加主動丟包抑制 bufferbloat | [09-性能調校](09-性能調校.md) · 5. 網路 |
| QEMU | 使用者空間的機器模擬器，負責虛擬主機板、磁碟、網卡、顯示 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| `qemu-guest-agent` | 虛擬機內的代理程式，讓 KVM 主機能查 IP、凍結檔案系統做快照、優雅關機 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| `qemu-img` / backing file | qcow2（§1.1）映像工具；`-b` 建立以另一個映像為「基底」的差異映像 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| Quadlet | Podman 4.4+ 的 systemd 整合：把 `.container` 檔自動轉成 systemd unit（§3.2） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| quorum | 多數決：叢集必須有超過半數節點互相看得到才能運作，所以節點要奇數 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| quorum / no-quorum-policy | Corosync 計票是否過半；`no-quorum-policy` 決定沒過半時資源怎麼辦（stop / ignore） | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| Quorum queues | RabbitMQ 以 Raft 演算法複製的佇列類型 | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| Raft / Paxos | 分散式共識演算法：多數節點同意才算寫入成功，並選出唯一 leader | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| RAID | 用多顆碟組成一個帶冗餘（或只求速度）的邏輯裝置 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| RAID LV（raid1 / 5 / 6 / 10） | LVM 透過核心 dm-raid 模組（借用 md 的 RAID 引擎）在單一 LV 內做冗餘 | [15-LVM進階](15-LVM進階.md) · 2. 條帶化（Striped）與 RAID LV |
| RAID 等級 | 資料如何分布：0 條帶（無冗餘）、1 鏡像、5 單同位、6 雙同位、10 鏡像再條帶 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| randomize_va_space（ASLR） | Address Space Layout Randomization：每次執行把堆疊、函式庫、堆積放在隨機位址 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| `RandomizedDelaySec=` | 在排定時間後加一段隨機延遲 | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| `RateLimitIntervalSec=` / `RateLimitBurst=` | 同一服務在一個區間內最多幾筆，超過就丟棄並記一筆「Suppressed」 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| RBD / CephFS / RGW | Ceph 的三種介面：RBD = 區塊裝置（VM 磁碟）、CephFS = POSIX 檔案系統、RGW = S3 / Swift 相容的物件閘道 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| `rc-manager` | NM 產生 `/etc/resolv.conf` 的方式（`symlink`、`file`、`resolvconf`…） | [05-網路與防火牆](05-網路與防火牆.md) · 4.5 NetworkManager 全域設定 |
| RCE | Remote Code Execution，攻擊者透過服務漏洞在伺服器上執行任意指令 | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| rclone | 支援數十種雲端與協定的檔案同步 CLI（「雲端的 rsync」） | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| `rclone sync` | 讓目標與來源一致（會刪目標多出的檔） | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| `rd.break` | 🔵 dracut 專用參數：在 initramfs 階段、切換根目錄之前中斷 | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `rd.lvm.lv=vg/lv` | 🔵 dracut 的核心參數：只啟用指定 LV | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| RDB / AOF | Redis 的兩種持久化：RDB 是定期整份記憶體快照（`dump.rdb`，`BGSAVE` 觸發）；AOF 是每筆寫入命令的追加日誌 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| readahead | 核心偵測到循序讀時預先多讀進 page cache 的量（`read_ahead_kb`） | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| Reallocated / Pending sector | 已被韌體重配到備用區的壞磁區數 / 讀取失敗、等待重配的可疑磁區數 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| `rear recover` | 在救援環境內執行：重建分割區、LVM、RAID、LUKS、檔案系統，還原資料，重裝 GRUB | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| rear（Relax-and-Recover） | 產生「含本機磁碟佈局的救援開機媒體 + 資料備份」並能一鍵重建的裸機復原工具 | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| `reboot-required` / `needs-restarting` | 🟠 套件安裝後若需要重開機會建立 `/var/run/reboot-required`；🔵 `dnf needs-restarting -r` 檢查核心 / glibc / systemd 是否更新過並回傳退出碼 | [02-初始設定](02-初始設定.md) · 8. 系統更新與基本工具 |
| `receive -F` | 接收端先強制回滾到最新共同快照再套用 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| recidive | 內建的「累犯」jail，資料來源是 fail2ban 自己的日誌 | [08-安全強化](08-安全強化.md) · 4. 入侵防禦：Fail2ban（已實測） |
| recovery mode | 🟠 GRUB「Advanced options」裡的選單式救援，提供 fsck / network / root shell 等選項 | [12-監控與故障排除](12-監控與故障排除.md) · 3.1 進入救援環境 |
| Red Hat | IBM 旗下的企業 Linux 公司，systemd、NetworkManager、SELinux、firewalld 等的主要開發者 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Red Hat 工具鏈 | `.rpm` 格式、`rpm` / `dnf`（Fedora 41+ 為重寫的 dnf5）、SELinux、firewalld、NetworkManager、systemd、chrony、tuned、Flatpak、Btrfs 預設 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| RED 方法 | 針對服務的檢查法：看請求速率（Rate）、錯誤率（Errors）、延遲（Duration） | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| refpolicy | Reference Policy：SELinux 上游用巨集寫成的政策原始碼專案，Fedora 的 `selinux-policy` 套件是它的下游 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| refpolicy / setools / setroubleshoot / udica 的上游 | 分別由 Tresys → 社群、Tresys、Red Hat、Red Hat 維護，都先進 Fedora 再進 RHEL | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| refpolicy 巨集（macro） | 用 m4 寫的規則樣板：一次呼叫展開成一組配套規則（type 宣告 + attribute + 常見 allow） | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| `registries.conf` | `/etc/containers/registries.conf`，Podman 決定短名稱（如 `nginx`）要去哪些 registry 找的設定 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| relabel / `restorecon` / `.autorelabel` | 依 SELinux 政策重設所有檔案的安全標籤（16 章） | [11-備份與災難復原](11-備份與災難復原.md) · 8.3 手動重建流程（無映像時） |
| release notes | 每個版本的官方變更說明 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| reload vs restart | reload 送 SIGHUP 讓 sshd 重讀設定、既有連線不斷；restart 把程序砍掉重來 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| remediate（自動修復） | 依每條規則附帶的修復腳本（bash / Ansible）直接改系統 | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| remote | rclone 設定檔裡的一個雲端連線定義（`b2:`、`gdrive:`） | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| remote / Flathub | remote 是 Flatpak 的套件來源（對應 §1 的套件庫），Flathub 是最大的公共 remote | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 4. 通用套件格式：Snap 與 Flatpak |
| remount ro | 核心偵測到檔案系統錯誤或 I/O 錯誤後，自動把它改成唯讀以免擴大損壞 | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| remove / purge | remove 只刪程式檔、保留設定檔；purge（🟠）連 `/etc` 下的設定檔一起刪 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| `remove-retired-packages` | 🔵 工具，列出並移除已從 Fedora 下架、不再更新的套件 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| renderer | Netplan YAML 裡的欄位，指定把設定交給 `networkd` 還是 `NetworkManager` | [05-網路與防火牆](05-網路與防火牆.md) · 1. 網路堆疊總覽 |
| Replica Set | MongoDB 的複製組：1 primary + N secondary，成員之間自行選舉 primary | [10-高可用設計](10-高可用設計.md) · 6.4 其他 |
| repmgr / pgpool-II | repmgr = 較簡單的複製管理與 failover 工具；pgpool-II = 連線池 + 讀寫分離 + 負載平衡 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| repokey / keyfile | 加密金鑰的存放模式：repokey 存在 repo 內（靠 passphrase 保護）；keyfile 存在本機 `~/.config/borg/keys` | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| repository / BORG_REPO | 存放去重區塊與封存清單的位置（`ssh://user@host/./path`） | [11-備份與災難復原](11-備份與災難復原.md) · 5. borgbackup |
| repository / RESTIC_REPOSITORY | 存放所有加密區塊、索引與 snapshot 的位置；用環境變數或 `-r` 指定 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| repository（repo） | restic / borg 存放去重區塊、索引與快照清單的目錄或遠端位置 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| `require { }` | 引用「別的模組定義的 type / class」 | [16-SELinux進階](16-SELinux進階.md) · 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測） |
| `rescue.target` | 單人救援：掛好檔案系統、只啟動 root shell，不啟網路與服務（需 root 密碼） | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `resize2fs` / `xfs_growfs` | ext4 / XFS 各自的線上放大工具（前者吃裝置、後者吃掛載點） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.2 線上擴充（最常用；已實測） |
| resolvectl / dig +trace | systemd-resolved 的查詢工具 / 從根伺服器逐層追蹤 DNS | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| resource | 由叢集管理的「一個服務單位」：VIP、檔案系統、daemon、DRBD 角色 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| resource agent / OCF | 操作資源的標準化腳本（start / stop / monitor），OCF（Open Cluster Framework）是其規格；`ocf:heartbeat:IPaddr2` = heartbeat 提供者的 IPaddr2 agent | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| resource（r0） | 一組 DRBD 複製設定：對外的 `device`（/dev/drbd0）、底層 `disk`（LV）、兩端 `address` | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| REST API（:8008） | Patroni 提供的 HTTP 介面：`/primary` 只在本機是 primary 時回 200、`/replica` 反之 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| rest-server --append-only | restic 官方的 HTTP 後端伺服器，append-only 模式下客戶端只能新增不能刪 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| Restart= / RestartSec= | 程序退出後 systemd 自動重啟的條件與等待秒數 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| restic | 單一二進位、區塊級去重、加密、多後端的備份工具 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| restore / mount / dump | restore 還原到目錄；mount 用 FUSE 把所有 snapshot 掛成可瀏覽的目錄；dump 把單檔輸出到 stdout | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| restorecon | 依 SELinux 政策的預設規則，把檔案標籤重設為「應該的值」 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `restorecon -n` / `fixfiles` | dry run 只列出會改什麼 / 整批重標與檢查的包裝工具（`-F onboot` 排程開機重標） | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| restorecon / chcon | 依 fcontext 表重貼標籤 / 直接手動貼標籤 | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| restorecon / semanage | `restorecon` 依政策預設把檔案標籤重設；`semanage` 修改政策的持久設定（`port` 加埠標籤、`fcontext` 加自訂路徑的預設標籤） | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| revert | 刪除 `/etc` 下該 unit 的所有 drop-in 與完整副本 | [04-系統管理](04-系統管理.md) · 1.2 單元檔位置與優先權 |
| RHEL | Red Hat Enterprise Linux，付費企業版，每版支援 10 年 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| RHEL 系 | 以 Fedora → RHEL 為主軸的家族（RHEL、Rocky、Alma、Fedora），dnf / .rpm、SELinux | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| rich rule | 一句話語法的細緻規則：可組合來源、service、動作、log、limit | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| ring buffer | 網卡與核心之間的環狀 DMA 緩衝區，網卡收到封包先放這裡等核心取走 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| rkhunter / chkrootkit | 兩個 rootkit 掃描器：檢查已知 rootkit 檔案、可疑的隱藏程序與埠 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| Rocky Linux / AlmaLinux | 以 RHEL 原始碼重建、與 RHEL 二進位相容的免費發行版 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| role | context 第二欄：一組 domain 的集合，只對程序有意義（物件一律 `object_r`） | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| role / `sysadm_r` | role 是一組可用 domain；`sysadm_r` 是能進 `sysadm_t`（真正管理員 domain）的 role | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| rollback | 把系統退回「某筆交易完成當時」的狀態，中間所有交易一併反向 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.1 交易歷史與回滾（🔵 Fedora 獨有優勢） |
| rolling update（滾動更新） | 一次只更新一台：下線 → 更新 → 健康檢查通過 → 上線 → 下一台 | [10-高可用設計](10-高可用設計.md) · 7.1 應用無狀態化 |
| root | UID 0 的超級使用者，核心對它不做任何權限檢查 | [02-初始設定](02-初始設定.md) · 3. 使用者與 sudo |
| root 鎖定 | 不設 root 密碼、root 不能直接登入的安全預設 | [01-系統安裝](01-系統安裝.md) · 4. 🔵 Fedora 44 互動式安裝（Anaconda） |
| root 預留空間 | ext4 預設保留 5% 只給 root 寫 | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| `root_squash` | export 選項：把客戶端的 root 對應成伺服器上的 nobody | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| `rootflags=subvol=` | 核心參數，指定開機時把哪個子卷當根目錄 | [11-備份與災難復原](11-備份與災難復原.md) · 6.2 Btrfs 快照（🔵 Fedora Workstation 預設） |
| rootkit | 藏在系統裡、隱藏自身與攻擊者活動的惡意程式，常替換 `ps`、`ss`、`sshd` 或載入核心模組 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| rootless | 以一般使用者身分、不需 root 執行容器；靠 user namespace 把容器內的 root 映射到主機的普通 UID | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| ROP gadget | Return-Oriented Programming：利用核心或程式裡既有的指令片段拼出攻擊碼 | [08-安全強化](08-安全強化.md) · 6. 核心與系統層 |
| `rotate N` / `daily` / `size` / `maxsize` | 保留幾份 / 週期 / 超過大小才輪替（不看週期）/ 到週期或超過大小就輪替 | [07-日誌管理](07-日誌管理.md) · 4. logrotate |
| `routing-policy` ／ `ipv4.routing-rules` | Netplan／nmcli 裡對應 `ip rule` 的永久化欄位 | [05-網路與防火牆](05-網路與防火牆.md) · 9.2 Policy routing（多 WAN / 來源路由） |
| `rp_filter` | reverse path filtering：核心檢查「這個來源 IP 的封包，回去時是否會從同一張卡出去」，不是就丟 | [05-網路與防火牆](05-網路與防火牆.md) · 10. 網路除錯流程 |
| `rpm -E %fedora` | 展開 RPM 巨集 `%fedora` 得到版本號 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| `rpm -K` | 🔵 用 rpmdb 裡已匯入的公鑰驗證 `.rpm` 檔簽章與摘要的指令 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| RPM Fusion | 社群維護的第三方 RPM 套件庫，提供 Fedora 因授權不收錄的軟體（NVIDIA 驅動、編解碼器） | [01-系統安裝](01-系統安裝.md) · 4.2 🔵 Fedora Workstation |
| `rpmbuild` / `myapp-selinux` / Ansible `community.general.sefcontext` | 把模組打成 RPM 隨應用安裝 / 用 Ansible 佈署 fcontext 與模組 | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| rpmdb / `--rebuilddb` | 🔵 rpm 的本機資料庫（§1）；`rpm --rebuilddb` 從現有內容重新建立索引 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 10. 套件系統故障排除 |
| RPO | Recovery Point Objective：災難發生時最多能接受「丟掉多久」的資料 | [11-備份與災難復原](11-備份與災難復原.md) · 1.2 RPO 與 RTO |
| RPO / RTO | 可接受的資料遺失時間 / 可接受的復原時間 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| rsnapshot | 用 rsync + hardlink 做輪替快照（daily / weekly / monthly）的工具 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| RSS / PSS / USS | 程序記憶體的三種算法：RSS 把共用函式庫重複計入、PSS 把共用部分按比例分攤、USS 只算獨佔 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| rsync | 只傳輸差異部分的檔案同步工具，透過 SSH 在本機與遠端之間複製目錄 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| rsync + lsyncd | lsyncd 用 inotify 監看目錄變動並即時呼叫 rsync 同步到另一台 | [10-高可用設計](10-高可用設計.md) · 5.2 其他選項 |
| rsyslog | 傳統 syslog 守護程式，把訊息依規則寫成純文字檔或轉送遠端 | [00-差異速查表](00-差異速查表.md) · 4. 日誌 |
| `RSYSLOG_FileFormat` | rsyslog 內建的輸出模板：高精度 ISO 8601 時間戳（含毫秒與時區） | [07-日誌管理](07-日誌管理.md) · 9. 日誌相關故障排除 |
| `rsyslogd -N1` | 只驗證設定語法、不啟動的模式 | [07-日誌管理](07-日誌管理.md) · 3.2 自訂規則範例 |
| `rt_tables` | 把路由表的數字編號對應到可讀名稱的檔案（`100 wan2`） | [05-網路與防火牆](05-網路與防火牆.md) · 9.2 Policy routing（多 WAN / 來源路由） |
| RTC / 硬體時鐘 | 主機板上的即時時鐘；Linux 預設視它為 UTC，Windows 視它為本地時間 | [14-UEFI進階](14-UEFI進階.md) · 11. 雙系統與多 ESP |
| RTC（硬體時鐘） | 主機板上靠電池走的時鐘，關機時仍在計時，開機時核心從它讀出初始時間 | [02-初始設定](02-初始設定.md) · 2. 時區、時間與語系 |
| RTO | Recovery Time Objective：從災難到服務恢復最多能接受停多久 | [11-備份與災難復原](11-備份與災難復原.md) · 1.2 RPO 與 RTO |
| run queue | 等待 CPU 排程的程序佇列，`vmstat` 的 `r` 欄就是它的長度 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| runbook | 逐步可照打的操作手冊（誰做什麼、怎麼驗證） | [10-高可用設計](10-高可用設計.md) · 8. HA 測試（每季演練清單） |
| runtime | Snap / Flatpak 各自提供的共用基底函式庫集合（如 `core22`、`org.freedesktop.Platform`），應用宣告自己依賴哪一個 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 4. 通用套件格式：Snap 與 Flatpak |
| runtime vs `--permanent` | firewalld 有兩份設定：runtime 立即生效但重開消失；permanent 只寫檔，要 `--reload` 才載入成 runtime | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| runtime ／ permanent | runtime 是核心裡現在生效的規則，permanent 是存在 XML 裡的規則 | [05-網路與防火牆](05-網路與防火牆.md) · 7. 🔵 Fedora：firewalld |
| RuntimeWatchdogSec | systemd（PID 1）定期餵 watchdog 的間隔；PID 1 卡住就不餵 → 重開機 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| rustup | Rust 官方的工具鏈管理器，裝在 `~/.cargo`，可切換 stable / nightly | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| SaaS | 整個應用由供應商營運，你只使用（GitLab.com、Google Workspace） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| Samba / SMB / CIFS | SMB 是 Windows 的檔案共享協定（CIFS 是它的舊名，Linux 掛載時仍用 `-t cifs`）；Samba 是 Linux 上實作 SMB 的伺服器軟體 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9. 網路儲存 |
| `samba_share_t` / `samba_enable_home_dirs` | 🔵 SELinux 允許 smbd 存取目錄的標籤 / 家目錄開關 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| sanoid / syncoid | sanoid 依策略自動建與清快照；syncoid 用 send / receive 自動同步到遠端 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| SBAT | BootHole 之後引進的「元件世代號」撤銷機制，一筆就能擋掉所有舊版 shim / GRUB（§4.4） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| sbctl | Arch 生態的一站式工具：產生自有 PK / KEK / db、登錄進韌體、簽檔並記住要簽哪些檔 | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| sbsigntools（`sbsign` / `sbverify`） | 對 PE 檔加簽 / 驗簽的工具組（🟠 套件名 `sbsigntool`、🔵 `sbsigntools`） | [14-UEFI進階](14-UEFI進階.md) · 4.3 自簽 EFI 執行檔（自訂 GRUB / UKI / systemd-boot） |
| SCAP | Security Content Automation Protocol：NIST 制定的一組標準格式（XCCDF 寫檢查清單、OVAL 寫檢查方法、DataStream 打包） | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| schema 驗證 | 用格式描述檔（JSON schema）或專用工具（`pykickstart` 的 `ksvalidator`）在本機檢查設定檔是否合法 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| `scontext` / `tcontext` | AVC 的 source context（發動的程序 domain）與 target context（被存取物件的 type） | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| scrape / scrape_interval | Prometheus 主動去 exporter 抓一次數據的動作與週期（15 秒） | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| scrub | 線上讀取全部資料並比對 checksum 的校驗 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.3 檢查與修復 |
| `sd_notify()` | 程式主動透過 socket 告知 systemd「我準備好了」的 API | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| sealert / aa-logprof | 🔵 分析 AVC 拒絕並建議修法 / 🟠 依日誌互動式補 AppArmor 規則 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| Secure Boot | UEFI 的簽章驗證功能：只執行被信任金鑰簽過的開機檔 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| Secure Boot / shim / MOK | UEFI 只執行有簽章檔案的機制 / 被 Microsoft 簽過的第一階段載入器 / 使用者自己登錄的簽章金鑰（01 章 §1.5） | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| Security Violation（0x1A） | UEFI 的 `EFI_SECURITY_VIOLATION` 狀態碼：韌體或 shim 拒絕執行某個檔案 | [14-UEFI進階](14-UEFI進階.md) · 4.4 Secure Boot 相關故障 |
| security 通道 | 發行版把「只修安全漏洞、不加功能」的更新單獨標記：🟠 是 `noble-security` 這個套件來源，🔵 是 dnf 更新通告（advisory）裡 `type=security` 的那些 | [08-安全強化](08-安全強化.md) · 1.1 自動安全更新 |
| `sed -i` / `awk` | 串流編輯器（`-i` 就地寫回檔案）/ 依欄位處理文字的小語言 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 5. 其他常見指令 |
| seed ISO / `cloud-localds` | 把 `user-data` + `meta-data` 包成 NoCloud 格式小 ISO 的工具（來自 `cloud-image-utils`；`genisoimage` / `xorriso` 也能做） | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| segment / segtype | LV 內一段連續 LE 的對應方式（linear、striped、raid1、thin…） | [15-LVM進階](15-LVM進階.md) · 1. 內部結構 |
| `seinfo` | setools 的政策統計 / 查詢工具（§3 詳述） | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| SELinux | 🔵 Fedora 預設啟用的強制存取控制（MAC）機制（16 章） | [01-系統安裝](01-系統安裝.md) · 7. WSL2 安裝（Windows） |
| SELinux / 標籤（label） | 🔵 以**標籤**為單位的 MAC：每個程序、檔案、埠、socket 都帶一個安全上下文，政策以標籤對標籤定義允許的存取（type enforcement） | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| SELinux boolean / fcontext | 🔵 允許 nfsd 讀家目錄的開關（`use_nfs_home_dirs`）/ 把目錄標成可分享的類型（`public_content_rw_t`） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| SELinux boolean / 檔案標籤 | 🔵 SELinux 是核心層的強制存取控制：每個檔案與程序都帶標籤，政策決定誰能碰誰；boolean 是政策內可開關的預設選項（如 `httpd_can_network_connect`） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| SELinux user | context 第一欄：登入身分對應到的 SELinux 身分（`system_u`、`unconfined_u`、`staff_u`…），與 Linux 帳號不是同一件事 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| SELinux 埠標籤 / AVC | 🔵 SELinux 限制服務只能綁特定埠類型；AVC 是它的拒絕紀錄 | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| SELinux 埠標籤（`ssh_port_t`） | 🔵 SELinux 政策不只標檔案，也給每個埠號標類型；sshd 只被允許 bind 標為 `ssh_port_t` 的埠 | [02-初始設定](02-初始設定.md) · 4.3 更改 SSH Port（含 SELinux / socket 差異） |
| SELinux 標籤（`ssh_home_t`） | 🔵 Fedora 每個檔案都帶一個安全標籤（`ls -Z` 可見），sshd 只被政策允許讀標為 `ssh_home_t` 的檔案 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `selinux-policy-devel` / Makefile | 提供 `/usr/share/selinux/devel/Makefile` 與所有 `.if` 介面的套件 | [16-SELinux進階](16-SELinux進階.md) · 5. 自訂政策模組（已實測建置流程） |
| `selinux-policy-targeted` | Fedora 打包的 refpolicy 下游：把 refpolicy 每個服務模組編好、裝進政策庫的 RPM | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| `SELINUX=disabled` | 之後檔案不打標，回 enforcing 要全盤重標；Fedora 37+ 也不再是真關閉 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| semanage | 管理「政策的可調部分」的指令：`fcontext`、`port`、`boolean`、`login`、`user` 子命令 | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| semanage / semodule | `semanage` 修改本機政策庫的 fcontext / port / boolean / login…；`semodule` 安裝、移除、重建政策模組 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| `semanage export` | 把本機所有 fcontext / port / boolean / login 修改匯成一份可重放的文字 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| `semanage fcontext -l -C` / `semanage export` / `import` | 只列本機新增的規則 / 匯出所有本機修改成可重放的指令 / 在另一台重放 | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| `semanage login` | 維護「Linux 帳號 → SELinux user（+ level 範圍）」對應表（存於 `seusers`） | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| `semanage port -a` / `-m` | 把埠加進某個 port type / 把已被別的 type 佔用的埠改成另一個 type | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| `semanage user` | 維護「SELinux user → 可用 role + level 範圍」 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| `semodule` | 安裝 / 移除 / 列出模組、重建政策（`-B`）的工具 | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| `semodule -lfull` / `semanage … -l -C` | 列出模組與優先權 / 只列偏離發行版預設的設定 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| `semodule_package -m … -f …` | 把 `.mod`（必要）與 `.fc`（`-f`，可選）打包成 `.pp` | [16-SELinux進階](16-SELinux進階.md) · 5.2 模組的編譯、安裝、管理 |
| `send -R -I` | `-R` 遞迴含所有子 dataset 與屬性；`-I` 送兩個快照之間的所有增量快照 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| `send` / `receive` | 把子卷（或兩個快照間的差異）序列化成串流 / 從串流重建子卷 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| Sentinel | 獨立的監控程序，多個 Sentinel 投票確認主節點死亡後自動 promote 從節點，並告訴客戶端新主在哪 | [10-高可用設計](10-高可用設計.md) · 6.3 Redis / Valkey |
| `sepolicy` | `policycoreutils` 的高階查詢工具，輸出人類可讀的摘要或整份 man page | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| `sepolicy generate` | `policycoreutils-devel` 的骨架產生器，依程式類型（`--init` / `--dbus` / `--cgi` / `--user`…）產生五個檔 | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| service | 描述「怎麼啟動、監看、重啟一個程式」的 unit 類型 | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| service（firewalld） | 預先定義的「服務名 → 埠 / 協定」對照（`/usr/lib/firewalld/services/*.xml`），如 `https` = 443/tcp、`cockpit` = 9090/tcp | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| `sesearch` | 依 source domain / target type / class / permission 條件搜尋政策規則 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| session | 一次登入（SSH、tty、桌面）所對應的 logind 物件 | [04-系統管理](04-系統管理.md) · 1.6 使用者層級服務 |
| `set -e` / `-u` / `-o pipefail` | 嚴格模式三件套：任一指令失敗即結束 / 用到未定義變數即報錯 / 管線任一段失敗就算整條失敗 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| `set -e` / 嚴格模式 | 讓 shell 在任何指令的 exit code 非 0 時立刻結束腳本 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| set ／ map | 具名集合（IP、埠、介面…）／鍵值對照表，可含區間，查詢是 O(1) | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| set-property / systemd-run | `set-property` 對既有 unit 寫入 drop-in 永久設限（`--runtime` 只到重開機）；`systemd-run` 把一次性指令放進指定 slice 執行 | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| `setenforce 0` 解決問題後就放著 | 等於沒有 SELinux；重開機後又回 enforcing 再壞一次 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| `setenforce 0/1` | 執行期切換 permissive / enforcing 的指令，不寫入 `/etc/selinux/config` | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| `setfacl` / `getfacl` | 設定 / 讀取 ACL 的工具（`acl` 套件） | [04-系統管理](04-系統管理.md) · 2.3 ACL（細緻權限） |
| setools | 一套政策分析工具（`sesearch`、`seinfo`、`sediff`…），Fedora 套件名 `setools-console` | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| setroubleshoot / sealert | 監看 AVC 並翻譯成「原因 + 建議指令」的服務（setroubleshootd）與它的 CLI（sealert） | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| setroubleshoot-server / setroubleshootd / `sealert` | 套件 / 常駐分析服務 / CLI：把 AVC 對照政策，產生「可能原因 + 建議指令 + 信心度」 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| `setsebool -P` / `semanage boolean -l` | 永久切換 boolean / 列出所有 boolean 與說明 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| `sfdisk -d` | 以文字匯出分割表 | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| `sfdisk -d` / `vgcfgbackup` | 匯出分割表 / 匯出 LVM 卷群組中繼資料的指令 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| SHA-512 密碼雜湊 | 以 `$6$` 開頭的 crypt 格式雜湊，`openssl passwd -6` 或 `mkpasswd -m sha-512` 產生 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| SHA256 雜湊 | 對整個檔案算出的 64 個十六進位字元指紋，內容改一個位元結果就完全不同 | [01-系統安裝](01-系統安裝.md) · 1.2 校驗映像完整性 |
| `SHA256SUMS` / `CHECKSUM` 檔 | 官方公布的「檔名 → SHA256」清單（🟠 `SHA256SUMS`、🔵 `Fedora-…-CHECKSUM`） | [01-系統安裝](01-系統安裝.md) · 1.2 校驗映像完整性 |
| shared-secret | 兩端建立連線時驗證用的共享密碼 | [10-高可用設計](10-高可用設計.md) · 5.1 DRBD（區塊層級同步複製，兩節點） |
| shell（bash） | 讀你打的命令列、做展開與重新導向、再啟動程式的直譯器 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| shim | 一個極小、由 Microsoft 簽署的第一階段載入器，內嵌發行版（Canonical / Fedora）自己的憑證 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| shim / MokManager | 由 Microsoft 簽署的第一階段載入器 / 它附帶的開機時 MOK 登錄介面 | [08-安全強化](08-安全強化.md) · 6.5 Secure Boot 下的自訂核心模組 |
| shim fallback（fbx64.efi + BOOTX64.CSV） | 從後備路徑開機時，shim 轉交給 fbx64.efi，它讀 CSV 自動重建 Boot####（§2） | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| `shimx64.efi` / `grubx64.efi` | Secure Boot 下 UEFI 機器 PXE 必須先抓的兩個檔，即 §1.5 的 shim 與 GRUB 的網路開機版本 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| shimx64.efi / grubx64.efi / mmx64.efi | 三件套：Microsoft 簽的 shim、發行版簽的 GRUB、MokManager | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| si / so | `vmstat` 的 swap in / swap out：每秒從 swap 換入 / 換出的量 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| `sign-file` | 核心原始碼附的簽模組工具，用私鑰對單一 `.ko` 加簽 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| single user / rescue 模式 | 只起最小系統、直接給 root shell 的開機目標，用來救援 | [08-安全強化](08-安全強化.md) · 6. 核心與系統層 |
| `sizing-policy: all` | autoinstall `storage.layout` 的選項：把整個 VG 分配給 `/` | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| slab | 核心自己的物件快取（dentry、inode、網路 buffer 等） | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| SLA（Service Level Agreement） | 與客戶 / 使用者簽的服務水準**承諾**，含指標、目標值、量測方式、違約賠償 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| slew vs step（makestep） | slew 是「讓時鐘走快或走慢」慢慢追上，不會出現時間倒退；step 是直接把時間改掉 | [02-初始設定](02-初始設定.md) · 2.1 時間同步（NTP） |
| slice | systemd 用來把 cgroup 分層的 unit 類型（`system.slice`、`user.slice`、`user-1000.slice`） | [04-系統管理](04-系統管理.md) · 3.1 OOM Killer |
| slice / service / scope | systemd 的三種 cgroup 單位：slice 是分組容器、service 是 systemd 自己啟動的程序、scope 是外部啟動後被納管的程序（如登入 session） | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| SLI（Service Level Indicator） | 實際量測的指標（成功請求比例、延遲 P99、可用時間比例） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| SLO（Service Level Objective） | 內部設定的目標值（如「30 天可用性 ≥ 99.9%」） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| SMART | 硬碟韌體內建的自我監測資料（壞軌重配數、溫度、通電時數） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| SMART / nvme smart-log | SATA 磁碟 / NVMe 的自我監測資料 | [12-監控與故障排除](12-監控與故障排除.md) · 9. 硬體診斷 |
| SMART / smartctl | 磁碟的自我監測資料 / 讀取它的工具 | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| smartd | 定期讀 SMART、屬性惡化時寄信或記錄的 daemon | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| SMB 版本（SMB1 / 2 / 3.1.1） | 協定世代：SMB1 已知漏洞多（WannaCry 利用它）；3.1.1 有加密與前置驗證完整性 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| `smb.conf` | Samba 唯一的設定檔：全域參數與每個 `[share]` 區段 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| `smbd` / `nmbd` | Samba 的兩個 daemon：`smbd` 處理檔案分享與驗證，`nmbd` 提供 NetBIOS 名稱瀏覽 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| SMBIOS Type 11 字串 | 主機板（或 hypervisor）透過 SMBIOS 表傳給 OS 的 OEM 字串；stub 會讀 `io.systemd.stub.kernel-cmdline-extra` 當額外參數 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| `smbpasswd` | 管理 Samba 自己的密碼資料庫 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| SMTP relay | 代為轉送郵件的外部 SMTP 伺服器（公司郵件伺服器、Gmail、SES…），需帳號密碼認證 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 6. 郵件通知（讓 cron / 監控 / fail2ban 能寄信） |
| snap | Canonical 的自包含套件格式，由常駐服務 `snapd` 管理，Desktop 用它裝 Firefox 等應用 | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| Snap / Flatpak | 與發行版無關的通用套件格式，把程式連同相依打包並隔離執行 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| snapd | 🟠 負責下載、掛載、自動更新（refresh）snap 的常駐服務 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 4. 通用套件格式：Snap 與 Flatpak |
| snapper | 管理 Btrfs / LVM 快照的工具，可掛勾 dnf / apt 在更新前自動拍快照 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| snapshot | 一次 `backup` 產生的時間點紀錄，含來源路徑、主機、tag | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| `snapshot -r` | 遞迴對 dataset 及其所有子 dataset 建快照 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| SNTP | Simple NTP，NTP 的簡化子集：只跟一個來源、不做複雜的漂移估算、不能當伺服器 | [02-初始設定](02-初始設定.md) · 2.1 時間同步（NTP） |
| socket activation | 由 systemd 先佔住埠，有連線進來才啟動對應的 service | [02-初始設定](02-初始設定.md) · 4.1 安裝與啟用 |
| soft / hard limit | soft 是實際生效值、程序可自行調高到 hard；hard 是天花板，只有 root 能提高 | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| soft lockup / hung task | 核心偵測到某顆 CPU 超過 20 秒沒排程 / 某程序在 D 狀態超過 120 秒時的警告 | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| softirq / netdev_max_backlog | softirq 是核心處理網卡中斷後半段（拆封包、交協定堆疊）的機制；`netdev_max_backlog` 是每顆 CPU 待處理封包的佇列上限 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| Software Selection / add-on | 選擇基礎環境（Fedora Server Edition）與附加群組：Guest Agents 是虛擬機代理程式，Headless Management 就是 Cockpit | [01-系統安裝](01-系統安裝.md) · 4.1 Fedora Server |
| sos / sosreport | Red Hat 起源的診斷打包工具，收集設定、日誌、硬體、指令輸出成一個 tar.xz | [12-監控與故障排除](12-監控與故障排除.md) · 10. 收集診斷資訊給支援 / 事後分析 |
| `spc_t`（super privileged container） | 幾乎不受限的容器 domain，等同關掉 SELinux 隔離 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| split DNS | 不同網域走不同 DNS 伺服器（公司網域走 VPN 內部 DNS，其他走公網） | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| SPOF | Single Point of Failure，架構中「只有一份、壞了就全停」的元件 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| SSE4.2 / POPCNT | CPU 指令集擴充：向量運算與位元計數指令 | [01-系統安裝](01-系統安裝.md) · 1.4 硬體需求（實務建議） |
| SSG（SCAP Security Guide） | ComplianceAsCode 專案產出的 SCAP 內容集，每個發行版一個 DataStream 檔（🟠 `ssg-debderived`、🔵 `scap-security-guide` 套件） | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| SSH | Secure Shell，加密的遠端登入 / 指令執行 / 檔案傳輸協定，預設 TCP 22 | [02-初始設定](02-初始設定.md) · 4. SSH 伺服器 |
| SSH host key | `/etc/ssh/ssh_host_*_key`，sshd 用來向 client 證明「我是這台主機」的金鑰對 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| SSH 憑證（certificate） | 由 CA 私鑰對「使用者公鑰 + 身分 + 有效期 + 允許的帳號（principal）」簽出的檔案（`id_ed25519-cert.pub`） | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| ssh-agent | 在工作機背景保管「已解密的私鑰」的程序，`ssh` 透過一個 socket 請它代為簽名 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| ssh-audit | 第三方工具，從外部連線列出伺服器支援的演算法並標出弱項 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| ssh-copy-id | 客戶端小腳本：用密碼登入一次，把公鑰附加進 authorized_keys 並把權限設好 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| ssh-keygen | OpenSSH 產生、檢視、轉換金鑰與簽發憑證的工具 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `ssh.socket` | systemd 的 socket 啟動單元：由 systemd 先聽 22 埠，有連線才拉起 sshd | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `ssh.socket` / `ssh.service` | 🟠 Ubuntu 的兩個 unit：前者 enabled、後者 disabled，是 socket activation 的標準組合 | [02-初始設定](02-初始設定.md) · 4.1 安裝與啟用 |
| `ssh_sysadm_login` | 是否允許 `sysadm_r` 直接透過 SSH 登入的 boolean | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| sshd | OpenSSH 的伺服器 daemon，設定檔 `/etc/ssh/sshd_config` 與 `sshd_config.d/` | [02-初始設定](02-初始設定.md) · 4. SSH 伺服器 |
| `sshd -t` / `sshd -T` | `-t` 只檢查語法（錯誤時非 0 退出）；`-T` 印出所有選項的**最終生效值** | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| sshd_config.d/ drop-in | sshd 先讀 `/etc/ssh/sshd_config.d/*.conf` 再讀主檔，**同一參數以第一次出現為準** | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| ssh（客戶端） | 連線用的指令，設定在 `~/.ssh/config` 與 `/etc/ssh/ssh_config` | [02-初始設定](02-初始設定.md) · 4. SSH 伺服器 |
| SSID | 無線網路的名稱（`access-points:` 底下的鍵） | [05-網路與防火牆](05-網路與防火牆.md) · 3.4 Wi-Fi（Desktop 通常用 NM GUI；Server 也可） |
| SST | State Snapshot Transfer，新節點加入時整份資料的完整複製（`wsrep_sst_method=mariabackup`，埠 4444） | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| standby | 節點暫時不承載資源但仍留在叢集中 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| start / stop / restart / reload | 對「現在」的操作：啟動、停止、重啟、不中斷地重讀設定 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| start limit | systemd 的防護：同一 unit 在短時間內（預設 10 秒 5 次）啟動失敗太多次就拒絕再啟動 | [04-系統管理](04-系統管理.md) · 1.1 基本操作 |
| StartLimit / NRestarts | systemd 對 unit 短時間內重啟次數的上限；`NRestarts` 是已重啟次數 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| StartLimitIntervalSec / StartLimitBurst | 在某段時間內最多允許重啟幾次，超過就放棄 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| stats socket / stats 頁 | `stats socket` 是本機 Unix socket 管理介面（`show stat`、`disable server`）；`stats uri` 是 HTTP 狀態頁（8404 埠） | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| stdin / stdout / stderr | 每個程式啟動時預設已打開的三條資料流：標準輸入（fd 0）、標準輸出（fd 1）、標準錯誤（fd 2） | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| stdout / stderr 擷取 | systemd 服務的標準輸出與錯誤輸出由 systemd 直接接進 journald | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| step-ca / smallstep、mkcert | 前者是可跑 ACME 的自架 CA 伺服器（讓內網也能用 certbot 自動續期）；後者是開發機一鍵建本機 CA 並裝進信任庫的工具 | [08-安全強化](08-安全強化.md) · 9.2 內部 CA / 自簽 |
| stickiness / cookie | 連線黏著：HAProxy 插入 `cookie SRV`，同一使用者之後都送到同一台 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| STONITH / fence agent | STONITH 是「把對方關機」的動作；fence agent 是對特定硬體 / 平台執行這動作的腳本 | [10-高可用設計](10-高可用設計.md) · 4. 叢集管理：Pacemaker + Corosync |
| `stop` | 命中後終止這筆訊息的後續比對 | [07-日誌管理](07-日誌管理.md) · 3. rsyslog |
| `Storage=` | journal 放哪：`persistent`（`/var/log/journal`，重開機保留）、`volatile`（`/run`，重開機消失）、`auto`（目錄存在就持久） | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| STP | Spanning Tree Protocol：交換器之間偵測並阻斷迴圈的協定 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| `strace` | 追蹤程序發出的系統呼叫 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| strace / ltrace / gdb | 追系統呼叫 / 追函式庫呼叫 / 除錯器 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| stratum | NTP 的層級：0 是原子鐘 / GPS，1 是直接接它的伺服器，每經一層加 1，數字越大越不可信 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 5. 時間服務：當 NTP 伺服器 |
| `StreamDriver="gtls"` | 用 GnuTLS 加密連線的串流驅動；`AuthMode="x509/name"` 要求驗證對方憑證名稱 | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| stress-ng | 對 CPU、I/O、記憶體等子系統施加人工負載的工具 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| StrictModes | sshd 選項（預設 `yes`）：家目錄、`.ssh`、`authorized_keys` 任一個能被他人寫入，就整份公鑰檔忽略不讀 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| striped（條帶化） | 把連續 LE 輪流分到 N 個 PV，等同 RAID0 | [15-LVM進階](15-LVM進階.md) · 2. 條帶化（Striped）與 RAID LV |
| stub resolver | resolved 在 `127.0.0.53:53` 開的極簡 DNS 服務：只接本機查詢、轉給上游、快取結果 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| Subiquity | Ubuntu Server 的文字介面安裝程式（§1.1），20.04 起取代 debian-installer，步驟固定為線性流程 | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| Subiquity / Anaconda | 🟠 Ubuntu Server / 🔵 Fedora 的安裝程式，分別在 §3、§4 詳述 | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| Subiquity / Ubuntu Desktop Installer / Anaconda | 安裝程式：Subiquity 是 Ubuntu Server 的文字介面安裝程式，Desktop 另用一套圖形安裝程式；Anaconda 是 Red Hat 家族共用的安裝程式 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| subject / object | subject 是發出動作的程序；object 是被動作的東西（檔案、目錄、埠、socket、另一個程序…） | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| subvolume（子卷） | Btrfs 內可獨立掛載、獨立快照的目錄樹（🔵 預設有 `root`、`home`） | [11-備份與災難復原](11-備份與災難復原.md) · 6.2 Btrfs 快照（🔵 Fedora Workstation 預設） |
| sudo | 讓一般帳號「以 root（或其他使用者）的身分執行一條指令」的工具，做不做得到由 sudoers 規則決定 | [02-初始設定](02-初始設定.md) · 3. 使用者與 sudo |
| `sudo` 群組 | 🟠 Ubuntu 授權執行 `sudo` 的群組（🔵 對應 `wheel`） | [01-系統安裝](01-系統安裝.md) · 3. 🟠 Ubuntu Server 24.04 互動式安裝（Subiquity） |
| `sudo` 群組 / `wheel` 群組 | 被允許用 `sudo` 提權的使用者群組 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| sudo 群組（🟠 `sudo` / 🔵 `wheel`） | `/etc/sudoers` 預設授權可執行 `sudo` 的群組 | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| sudoers | sudo 的規則檔 `/etc/sudoers` 與 `/etc/sudoers.d/`（語法見 §3.2） | [02-初始設定](02-初始設定.md) · 3. 使用者與 sudo |
| sudoers / sudoers.d | sudo 的政策檔：誰可以用誰的身分執行什麼；`/etc/sudoers` 是主檔，`/etc/sudoers.d/*` 是被 `@includedir` 載入的片段 | [08-安全強化](08-安全強化.md) · 2.2 sudo 強化 |
| sudoers `TYPE=` / `ROLE=` | sudo 執行時指定要轉到的 domain 與 role | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| sudoers 規則語法 | `使用者 主機=(目標使用者:目標群組) 標籤: 指令`，例如 `deploy ALL=(ALL) NOPASSWD:ALL` | [02-初始設定](02-初始設定.md) · 3.2 sudo 規則 |
| SUID / SGID | 檔案權限位元：執行時以檔案擁有者 / 群組的身分執行（`-perm -4000` / `-2000`） | [08-安全強化](08-安全強化.md) · 2.4 帳號清查 |
| SUID / SGID / sticky | 三個特殊位元：執行時換成檔案擁有者身分 / 換成檔案群組（設在目錄上則新檔繼承群組）/ 目錄內只有擁有者能刪自己的檔 | [04-系統管理](04-系統管理.md) · 2.2 檔案權限 |
| suid_dumpable | SUID 程式崩潰時是否產生 core dump | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| Suites / Components | Suites 是版本代號加通道（`noble` 基礎、`noble-updates` 一般更新、`noble-security` 安全性更新、`noble-backports` 回移的新版）；Components 就是 §1 的元件（main / universe …） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| superblock（metadata 1.2） | 寫在每顆成員碟開頭 4 KiB 處的陣列描述 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| superusers / password_pbkdf2 / `--unrestricted` | GRUB 設定：管理員名稱 / 以 PBKDF2 雜湊儲存的密碼 / 標記「此選單項不需密碼即可正常開機」 | [08-安全強化](08-安全強化.md) · 6.4 開機安全 |
| sVirt | libvirt 用 MAC（🔵 SELinux、🟠 AppArmor）為每台 VM 的 QEMU 程序與映像檔配上專屬標籤 / profile 的機制 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| sVirt / `svirt_t` / `virt_image_t` | libvirt 把同一套 MCS 隔離套到 KVM：每台 VM 的 qemu 程序是 `svirt_t:s0:cX,cY`，磁碟映像是 `virt_image_t:s0:cX,cY` | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| swap | 記憶體不夠時把不常用的分頁暫放到磁碟的空間，可以是分割區、LV 或一般檔案 | [01-系統安裝](01-系統安裝.md) · 2. 分割區規劃 |
| swap / swappiness | swap 是匿名頁的溢出空間（磁碟交換檔或 🔵 zram）；`swappiness`（0～200）決定核心多偏好換出匿名頁而非丟 page cache | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| swap 檔 / 分割區 / LV | 放 swap 的三種地方：一般檔案（🟠 `/swap.img`）、獨立分割區、LVM 的 LV | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| switchover / failover | switchover = 計畫性切換，先確認 replica 追上再換（零遺失）；failover = primary 已死時的強制切換 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| SYN backlog / somaxconn（listen backlog） | 兩個等候佇列：`tcp_max_syn_backlog` 放握手進行中的連線，`somaxconn` 放握手完成、等應用 `accept()` 的連線 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| `sync` / `no_subtree_check` | 寫入落盤才回應 / 不檢查檔案是否在 export 子樹內 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.1 NFS |
| `sync_action` / 一致性檢查 | 定期讀取所有成員比對是否一致 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| synchronous_mode | 至少一台 replica 確認收到才 commit，切換時保證零資料遺失 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| sysbench | CPU / 記憶體 / 資料庫的簡單基準工具 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| sysctl | 兩個意思：核心在 `/proc/sys/` 下暴露的執行期可調參數，以及讀寫它們的同名工具 | [04-系統管理](04-系統管理.md) · 5.5 sysctl 核心參數 |
| sysctl / `/etc/sysctl.d/` | 讀寫 `/proc/sys/` 下核心參數的指令；`sysctl.d/*.conf` 是開機時依檔名排序套用的設定檔 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| `sysinit.target` / `basic.target` | 開機早期的兩個里程碑：檔案系統與 udev 就緒 / 基本服務（socket、timer、路徑）就緒 | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| syslog / `syslog(3)` / `/dev/log` | syslog 是傳統的日誌協定與訊息格式（facility + priority + 文字）；`syslog(3)` 是 C 函式、`logger` 是命令列版；它們都把訊息寫進 `/dev/log` 這個 socket | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| syslog identifier `sudo` | `sudo` 每次執行都以 identifier `sudo` 寫一筆「誰、在哪、執行什麼」 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| syslog identifier（`-t`） | 程式寫 syslog 時自報的名稱（`SYSLOG_IDENTIFIER` 欄位） | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| sysrq | 鍵盤魔術鍵 / `/proc/sysrq-trigger`，可直接叫核心重開機、kill 全部程序、dump 記憶體 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| sysstat / sar | 提供 `sar`、`iostat`、`mpstat`、`pidstat` 的套件；`sar` 靠背景收集器每 10 分鐘存一份歷史 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| `systemctl --failed` | 列出開機時啟動失敗的 systemd 服務 | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| systemctl / journalctl | 前者是對 systemd 下指令的 CLI，後者讀取 systemd 的日誌服務 journald 收集的日誌 | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| `systemctl edit` / override | 為某個 unit 建立 `/etc/systemd/system/<unit>.d/override.conf` 覆寫片段，不動套件原檔 | [02-初始設定](02-初始設定.md) · 4.3 更改 SSH Port（含 SELinux / socket 差異） |
| `systemctl reboot --firmware-setup` | 透過 UEFI 變數 `OsIndications` 要求下次重開直接進韌體設定 | [14-UEFI進階](14-UEFI進階.md) · 5.1 GRUB2（兩者預設） |
| systemctl show | 印出 unit 的所有屬性（結束碼、環境變數、限制值） | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| systemd | 兩者共用的 init 系統與服務管理器 | [01-系統安裝](01-系統安裝.md) · 7. WSL2 安裝（Windows） |
| systemd target | systemd 的啟動里程碑（`rescue` / `emergency` / `multi-user` / `graphical`），決定要啟動哪些 unit | [12-監控與故障排除](12-監控與故障排除.md) · 3. 開機故障 |
| systemd timer | 取代 cron 的排程 unit（§4.1 的 unit 之一），`.timer` 到點就啟動同名 `.service` | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| systemd timer / Persistent | 用 `.timer` 單元取代 cron；`Persistent=true` 讓錯過的排程在開機後補跑 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| systemd-analyze | systemd 附的開機分析工具：`blame` 列各 unit 耗時、`critical-chain` 顯示關鍵路徑、`plot` 畫成 SVG 時間軸 | [09-性能調校](09-性能調校.md) · 9. 開機與服務啟動時間 |
| `systemd-analyze blame` / `critical-chain` / `plot` | 依開機時各 unit 的時間戳，列出啟動耗時排名、拖慢開機的因果鏈、畫成 SVG | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| `systemd-analyze pcrs` | 列出每個 PCR 的用途與目前值（systemd 255+） | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| systemd-analyze verify | 檢查 unit 檔語法與引用的路徑是否存在 | [12-監控與故障排除](12-監控與故障排除.md) · 7. 服務與應用 |
| `systemd-analyze verify` / `security` | 前者檢查單元檔語法與引用，後者依沙箱選項給出 0～10 的暴露分數 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| systemd-boot | systemd 附帶的極簡 UEFI 開機載入器（前身 gummiboot），沒有腳本語言與模組 | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| `systemd-boot-efi` / `systemd-boot-unsigned` | 提供 `systemd-bootx64.efi` 與 `linuxx64.efi.stub` 的套件（🟠 / 🔵 名稱不同） | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| systemd-boot（gummiboot） | systemd 專案的極簡 UEFI 載入器：只讀 ESP、沒有腳本語言、選單來自 entry 檔；前身叫 gummiboot | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| `systemd-cgtop` | 像 `top` 但以 cgroup（也就是 service / slice）為單位顯示資源 | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| systemd-cgtop / systemd-cgls | 依 cgroup 即時顯示資源用量 / 樹狀列出 cgroup 與其程序 | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| `systemd-cryptenroll` | systemd 提供、把 TPM2 / FIDO2 金鑰登錄進 LUKS2 金鑰槽的工具 | [01-系統安裝](01-系統安裝.md) · 2.4 全碟加密（LUKS） |
| `systemd-journal` / `adm` 群組 | 可讀系統 journal 的群組（兩者共通）/ 🟠 Debian 慣例的日誌讀取群組 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| `systemd-journal-upload` / `systemd-journal-remote` | journald 原生的傳送端 / 接收端，以 HTTP(S) 傳整筆結構化 journal | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| systemd-networkd | systemd 內建的輕量網路管理程式，適合伺服器 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| systemd-nspawn / machinectl | systemd 內建的容器執行器，把一個目錄樹或映像當成容器開機；`machinectl` 是管理 CLI | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| `systemd-oomd` | systemd 提供的使用者空間 OOM 守護程序，依 PSI 提早介入，以 cgroup 為單位整組殺 | [04-系統管理](04-系統管理.md) · 3.1 OOM Killer |
| systemd-oomd / oomctl | systemd 的使用者空間 OOM daemon，依 cgroup 的記憶體壓力（PSI）提早整組殺掉服務；`oomctl` 查它的狀態 | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| `systemd-pcrphase` | systemd 在開機各階段（initrd 結束、進入 sysinit 等）往 PCR 11 / 15 延伸標記的服務 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| systemd-resolved | systemd 的本機 DNS 快取與轉發程式 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| systemd-resolved / resolvectl | 兩邊預設都啟用的本機 DNS 快取與轉發 daemon，`resolvectl status` 看每個介面實際用哪些 DNS | [02-初始設定](02-初始設定.md) · 5. 網路基本設定（詳見第 05 章） |
| `systemd-run` | 把任意指令包成臨時 service（加 `--on-active=` 則包成臨時 timer）的工具 | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| systemd-stub | UKI 最前面的 EFI 程式，被韌體 / 載入器執行後解開各區段、把 initramfs 與參數交給核心 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| `systemd-sysctl.service` / `sysctl --system` | 開機時套用所有 sysctl.d 檔案的服務 / 手動重套用全部的指令 | [04-系統管理](04-系統管理.md) · 5.5 sysctl 核心參數 |
| systemd-timesyncd | systemd 內建的輕量 SNTP 客戶端，設定檔 `/etc/systemd/timesyncd.conf` | [02-初始設定](02-初始設定.md) · 2.1 時間同步（NTP） |
| systemd-timesyncd / chrony | NTP 時間同步：timesyncd 是 systemd 內建的簡易客戶端；chrony 是 Red Hat 主導的完整實作，可兼作伺服器 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `systemd-tmpfiles` | 依 `tmpfiles.d` 規則建立 / 清理目錄的工具 | [07-日誌管理](07-日誌管理.md) · 9. 日誌相關故障排除 |
| `systemd.unit=` | 核心參數：指定這次開機的 default.target | [04-系統管理](04-系統管理.md) · 5.6 開機流程與 target |
| `SystemMaxUse=` / `SystemKeepFree=` / `SystemMaxFileSize=` | 持久 journal 的總上限 / 至少留給檔案系統的空間 / 單檔上限 | [07-日誌管理](07-日誌管理.md) · 2.1 journald 設定 |
| table | 規則的最外層容器，以 family 區分處理哪種封包：`inet`（IPv4+IPv6 共用）、`ip`、`ip6`、`arp`、`bridge` | [05-網路與防火牆](05-網路與防火牆.md) · 8. nftables 原生（進階、兩者共通） |
| tag | 附在 snapshot 上的標籤（`--tag daily`） | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| tag / digest | tag 是映像的可變別名（`nginx:1.27` 會隨修補版換內容）；digest 是內容的 sha256，永不改變 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.2 Quadlet（Podman 4.4+，兩者皆可） |
| tag / `volume_list` | 給 LV 貼標籤；lvm.conf 的 `volume_list` 只允許列出的 VG / tag 被啟用 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| target | 沒有實體動作、只用來把一群 unit 綁在一起、代表「開機到達某個階段」的 unit 類型 | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| targeted policy | Fedora 預設的 SELinux 政策：只把網路服務等「目標」程序關進限制域，一般使用者程序不受限 | [02-初始設定](02-初始設定.md) · 7. 強制存取控制：AppArmor 與 SELinux |
| targeted 政策 | Fedora 預設的政策：只把網路服務等「目標」關進各自 domain，一般使用者程序在 `unconfined_t` 幾乎不受限 | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| task / module | task 是 playbook 裡的一個步驟；每個 task 呼叫一個 module——實際做事的 Python 程式（`apt`、`copy`、`user`…） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| TasksMax | 該 cgroup 可建立的程序＋執行緒數上限 | [09-性能調校](09-性能調校.md) · 8. cgroup v2 資源控制（兩者皆為 cgroup v2，實測 `cgroup2fs`） |
| `tclass` / `{ permission }` | 被存取物件的 class 與被拒的動作 | [16-SELinux進階](16-SELinux進階.md) · 4. 讀懂 AVC 與系統性的除錯流程 |
| TCO（總擁有成本） | 生命週期內硬體 + 授權 + 人力 + 停機損失 + 退場成本的總和 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| TCP buffer（tcp_rmem / tcp_wmem） | 每條 TCP 連線的接收 / 傳送緩衝（最小 / 預設 / 最大三個值），上限另受 `rmem_max` / `wmem_max` 限制 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| tcp_syncookies | SYN flood 時不在核心記憶體保留半開連線，改用帶簽章的序號回應 | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| tcpdump | 把經過網卡的封包抓下來印出的工具 | [05-網路與防火牆](05-網路與防火牆.md) · 2. 共通的觀察指令（iproute2） |
| tcpdump / Wireshark | 命令列抓包 / 圖形化分析 | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| tdata / tmeta | pool 的資料區 / metadata 區（記「thin volume 的哪個虛擬區塊 → pool 的哪個 chunk」） | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| Teleport / step-ca | 把「簽發短效憑證 + SSO 登入 + 稽核錄影」包成產品的工具 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| template / `dynaFile` | template 定義輸出格式或檔名字串；`dynaFile` 讓 omfile 依 template（含 `%HOSTNAME%` 等屬性）動態決定檔名 | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| Terraform / OpenTofu、Packer、etckeeper | 分別是建基礎設施（VM、雲端資源）、建映像、把 `/etc` 放進 git 追蹤的工具 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| textfile collector | 讀取指定目錄內 `*.prom` 檔案並原樣輸出的 collector | [12-監控與故障排除](12-監控與故障排除.md) · 1.1 node_exporter（主機指標） |
| TFTP | 極簡的 UDP 檔案傳輸協定，無認證、無目錄列表 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| thin pool | 先從 VG 切出的「實體空間池」LV（內含資料區與 metadata 區） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.5 Thin Provisioning |
| thin volume | 掛在 pool 上、只有「虛擬大小」的 LV | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.5 Thin Provisioning |
| thin 快照 | 複製 origin 的 metadata 指標、共用所有未改動 chunk 的新 thin volume | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| thin_check / thin_repair | 檢查 / 修復 tmeta 的工具（🟠 thin-provisioning-tools；🔵 device-mapper-persistent-data） | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| third-party software | 安裝時勾選即安裝專有驅動（NVIDIA、部分 Wi-Fi 韌體）與多媒體編解碼器 | [01-系統安裝](01-系統安裝.md) · 3.1 🟠 Ubuntu Desktop 安裝重點 |
| THP（Transparent Huge Pages） | 核心在背景自動把連續的 4 KB 頁合併成 2 MB 大頁 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| Tier 分級 | 依 RPO / RTO 把服務分等：Tier 0 是其他一切都依賴的基礎服務 | [11-備份與災難復原](11-備份與災難復原.md) · 10.1 文件內容 |
| TIME_WAIT / tcp_tw_reuse | 連線關閉後主動關閉方保留的狀態（預設 60 秒，埠被佔住）；`tcp_tw_reuse` 允許出站連線重用這類埠 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| timedatectl | systemd 的時間 / 時區管理指令，背後是 `systemd-timedated` 服務 | [02-初始設定](02-初始設定.md) · 2. 時區、時間與語系 |
| Timeout | 韌體開機選單等待秒數 | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| timer / socket / mount | 分別是「定時觸發」「有連線時才啟動」「掛載一個檔案系統」的 unit 類型 | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| timer 單元 | 只負責「何時觸發」的 unit，本身不執行指令 | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| `timers.target` | 所有已 enable 的 timer 掛在其下的 target | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| timestamp_timeout | sudo 記住密碼的分鐘數（預設 15） | [08-安全強化](08-安全強化.md) · 2.2 sudo 強化 |
| TLS | Transport Layer Security，HTTPS、SMTPS、LDAPS 底下那層加密與身分驗證協定（SSL 的後繼） | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| TLS 1.0 / 1.1 / 1.2 / 1.3 | TLS 協定版本；1.0 / 1.1 已於 2021 年被 RFC 8996 正式廢止，1.3 拿掉所有不安全的舊套件 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| TLS 私鑰 / SSH host key | 服務憑證的私鑰 / 主機的 SSH 身分金鑰 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| tmpfs | 存在記憶體中的檔案系統，重開機即清空 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| tmpfs / `/dev/shm` | 存在記憶體的檔案系統 / POSIX 共享記憶體的掛載點，所有人可寫 | [08-安全強化](08-安全強化.md) · 6.2 檔案系統掛載選項 |
| tmux / screen | 終端多工器：程序掛在它底下，SSH 斷線後仍繼續執行 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🟠 Ubuntu：`do-release-upgrade` |
| Toolbox | Fedora 開發的工具：用 Podman 建一個與主機共用家目錄、可 sudo 的開發用容器 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| Toolbox / Distrobox | 用容器（podman）開一個「像完整發行版」的互動環境，共用家目錄與硬體 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| topologySpreadConstraints / 多可用區 | 要求 Pod 分散到不同節點或可用區（機房） | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| TOTP | Time-based One-Time Password（RFC 6238）：由共享密鑰與目前時間算出的 6 位數碼，每 30 秒換一次 | [08-安全強化](08-安全強化.md) · 2.3 兩步驟驗證（TOTP） |
| TPG / portal | Target Portal Group：一組監聽位址（IP:3260）加驗證 / ACL 設定 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.3 iSCSI |
| TPM 2.0 | 主機板上的安全晶片，會記錄開機每一階段的 hash（量測），並能保管金鑰 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| TPM 2.0 / PCR / 量測開機 | TPM 是主機板安全晶片；PCR 是它裡面只能「延伸」不能改寫的暫存器；量測開機是每層執行前把下一層 hash 延伸進 PCR（§8） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| TPM 備援全碟加密 | 用 TPM2 保管 LUKS 金鑰、免密碼開機的桌面版實作（§1.5、§2.4） | [01-系統安裝](01-系統安裝.md) · 3.1 🟠 Ubuntu Desktop 安裝重點 |
| TPM2 | 主機板安全晶片，記錄開機鏈各階段的量測值並保管金鑰（01 章 §1.5） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| tpm2-tools（`tpm2_pcrread` 等） | 直接操作 TPM 的低階 CLI | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| tracepoint / kprobe | eBPF 程式的兩種掛載點：tracepoint 是核心預先埋好的穩定事件，kprobe 可掛在任意核心函式入口 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| transmit-hash-policy | LACP 模式下決定「某條連線固定走哪條成員線」的雜湊依據（`layer3+4` = 看 IP + 埠） | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| trap | 指定 shell 收到某訊號或某事件（如 EXIT）時要執行的指令 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| trap / 訊號 / EXIT | 訊號是核心送給程序的通知（如 Ctrl-C 的 INT）；`trap cmd SIG` 指定收到時執行 cmd；`EXIT` 是 bash 的偽訊號，代表 shell 結束 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| TRIM / discard / `fstrim` | 告訴 SSD「這些區塊已釋放」的指令 / 檔案系統即時發送它的掛載選項 / 批次發送它的工具 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| `TrustedUserCAKeys` | sshd 選項：指向 CA 公鑰檔，凡是它簽出的憑證都接受 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| tuned | Red Hat 的效能設定檔守護程式，依 profile 調整核心參數與 CPU 調速 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| tuned-adm | 操作 tuned 的命令列工具：列出、切換、驗證、建議 profile | [09-性能調校](09-性能調校.md) · 7. tuned（🔵 Fedora 預設；🟠 Ubuntu 可安裝，已實測） |
| tuned-ppd / power-profiles-daemon | 桌面「省電 / 平衡 / 效能」電源模式的 D-Bus 介面；`tuned-ppd` 是 tuned 提供的相容實作 | [09-性能調校](09-性能調校.md) · 7. tuned（🔵 Fedora 預設；🟠 Ubuntu 可安裝，已實測） |
| Type #1 entry / Type #2 entry | Type #1 是 `loader/entries/*.conf` 純文字檔（與 BLS 相同）；Type #2 是直接放在 `EFI/Linux/` 的 UKI，不需任何設定檔 | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| Type #2 entry / `EFI/Linux/` | systemd-boot 規範：放在 ESP `EFI/Linux/` 的 UKI 不需 entry 檔就會被列出 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| type / domain | type 是標籤的核心欄位；程序的 type 習慣稱 domain（`httpd_t`），檔案的 type 稱 file type（`httpd_sys_content_t`） | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| type enforcement（TE） | 「哪個 domain 對哪個 type 可以做什麼」的規則模型，所有 `allow` 規則都長這樣 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| `Type=` | 告訴 systemd「主程序是哪一個、何時算啟動完成」 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| `type_transition` / `filetrans_pattern()` | 決定新檔預設標籤的規則 / 在模組裡寫這種規則的 refpolicy 巨集 | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| type_transition（轉換規則） | 「A domain 執行 B exec type → 進入 C domain」或「A domain 在 B 目錄建檔 → 新檔自動標 C type」 | [16-SELinux進階](16-SELinux進階.md) · 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測） |
| Ubuntu / Canonical | Ubuntu 是 Debian 衍生版；Canonical 是開發它並靠支援服務獲利的公司 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| Ubuntu Pro | Canonical 的訂閱服務（個人最多 5 台免費），內含 ESM、Livepatch、Landscape 與合規工具 | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| `ubuntu-drivers` / `akmod` | 🟠 偵測並安裝專有驅動的工具；🔵 `akmod-*` 是 RPM Fusion 提供、隨核心更新自動重編模組的套件 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| `ubuntu-drivers` / `akmod-nvidia` | 🟠 `ubuntu-drivers` 偵測硬體並從 restricted 元件挑合適的專有驅動；🔵 `akmod-nvidia` 是 RPM Fusion（§3.4）的 NVIDIA 驅動，由 akmods 在每次 kernel 升級後自動重編 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| `ubuntu-restricted-extras` | 一個 meta 套件，一次裝齊受限元件（編解碼器、Microsoft 核心字型、unrar 等） | [01-系統安裝](01-系統安裝.md) · 3.1 🟠 Ubuntu Desktop 安裝重點 |
| udev 規則 | 裝置出現時自動執行的規則檔（`/etc/udev/rules.d/`） | [09-性能調校](09-性能調校.md) · 4. 儲存 I/O |
| udev 規則（69-dm-lvm.rules） | 裝置出現時觸發 `pvscan --cache` 進而啟用 VG 的事件機制 | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| udica | 讀 `podman inspect` 的 volume / 埠 / capability，產生「`container_t` + 剛好需要的權限」的 CIL 模組 | [16-SELinux進階](16-SELinux進階.md) · 7. 容器與 SELinux |
| UEFI | 取代舊 BIOS 的主機板韌體標準，負責開機的第一步 | [01-系統安裝](01-系統安裝.md) · 1.5 UEFI、Secure Boot 與 TPM |
| UEFI / ESP | UEFI 是主機板韌體標準；ESP 是它唯一會讀取開機檔的 FAT32 分割區（`/boot/efi`）；詳見 01 章 §1.5 | [04-系統管理](04-系統管理.md) · 5.7 systemd-boot（UEFI 替代 GRUB） |
| UEFI HTTP Boot | UEFI 2.5 起的原生功能：DHCP 直接回 HTTP URL，韌體自己下載開機檔 | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| UEFI Shell / edk2 | UEFI 的命令列環境，可手動執行 `.efi`、看變數；edk2 是 UEFI 參考實作，提供 `Shell.efi` | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| UEFI 開機項（NVRAM）/ efibootmgr | 主機板 NVRAM 裡的開機項清單（Boot0000…）與管理它的工具 | [12-監控與故障排除](12-監控與故障排除.md) · 3.3 重裝開機載入器 |
| ufw | Uncomplicated Firewall，🟠 Ubuntu 的簡易前端：`default` 定預設策略、`allow` / `deny` 加規則、`enable` 啟用 | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| ufw / firewalld | 防火牆前端：ufw 是 Ubuntu 的簡易指令式工具；firewalld 是 Red Hat 的區域（zone）＋服務式守護程式 | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| ufw / firewalld / nftables | 🟠 / 🔵 的防火牆前端，底層都是 nftables | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| ufw vs firewalld | 🟠 / 🔵 各自的防火牆前端（§7、05 章） | [01-系統安裝](01-系統安裝.md) · 8. 安裝後檢查清單 |
| ugo / rwx | 傳統 Unix 權限：三組身分（擁有者 u、群組 g、其他 o）× 三種權限（讀 r、寫 w、執行 x） | [04-系統管理](04-系統管理.md) · 2.2 檔案權限 |
| UID 0 | Linux 只看數字判斷 root：任何 UID 為 0 的帳號都是 root，不管名字叫什麼 | [08-安全強化](08-安全強化.md) · 2.4 帳號清查 |
| UKI | 核心 + initramfs + 核心參數 + os-release 打包成一個 PE 檔的開機映像（§1） | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| UKI / ukify / systemd-stub | Unified Kernel Image：把核心、initramfs、核心參數、os-release 打包成一個可簽署的 `.efi`；`ukify` 是打包工具，`systemd-stub` 是包在最前面、負責啟動的 EFI 程式（§7） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| `ukify` | systemd 的 UKI 打包工具，可同時用 `--secureboot-*` 簽章、`inspect` 檢視內容 | [14-UEFI進階](14-UEFI進階.md) · 7. UKI（Unified Kernel Image） |
| `ulimit` | shell 內建指令，顯示或調整「目前 shell 與其子程序」的資源上限 | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| umask | 新建檔案時「預設拿掉」的權限遮罩，由 shell 或 PAM 設定 | [04-系統管理](04-系統管理.md) · 2.2 檔案權限 |
| `umask=0077` / `shortname=winnt` | vfat 掛載選項：前者讓 FAT 上所有檔案只有 root 可讀，後者決定 8.3 短檔名的大小寫呈現 | [14-UEFI進階](14-UEFI進階.md) · 6. initramfs 與 UEFI 相關設定 |
| unattended-upgrades | 🟠 Debian 系的自動更新套件：`/etc/apt/apt.conf.d/20auto-upgrades` 是總開關、`50unattended-upgrades` 定義允許的來源 | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| `unattended-upgrades` / `dnf-automatic` | 定期自動套用（安全）更新的服務 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| `unattended-upgrades` / `dnf5-automatic` | 🟠 / 🔵 的自動安全更新服務 | [07-日誌管理](07-日誌管理.md) · 7. 應用程式日誌慣例 |
| `unconfined_service_t` | systemd 啟動「政策不認識的可執行檔（`bin_t`）」時進入的 domain，幾乎不受限 | [16-SELinux進階](16-SELinux進階.md) · 6. 為自家服務建立 confined domain（sepolicy generate，已實測） |
| `unconfined_u` / `user_u` / `staff_u` / `sysadm_u` | 不受限 / 最受限的一般使用者 / 可提權的員工 / 直接就是管理員 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| unconfined（`unconfined_t` / `unconfined_u`） | 「不受限」的 domain / SELinux user：政策幾乎全部放行，只留極少數限制 | [16-SELinux進階](16-SELinux進階.md) · 1. 運作模型：為什麼是「標籤」 |
| undo | 把「某一筆」交易反向執行：裝的移除、升的降回 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.1 交易歷史與回滾（🔵 Fedora 獨有優勢） |
| unicast / multicast | VRRP 通告的送法：multicast 是預設（同網段群播），unicast 指名對方 IP | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| unit | systemd 管理的最小單位，依副檔名分類：`.service`（程序）、`.socket`（監聽點）、`.timer`（排程）等 | [02-初始設定](02-初始設定.md) · 4.1 安裝與啟用 |
| unit（單元） | systemd 管理的最小對象，每個 unit 對應一份 INI 格式的單元檔，副檔名決定類型 | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| unlock | 移除上次中斷留下的 repo 鎖 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| unmanaged-devices | 告訴 NM「這些介面不歸你管」的清單，可用介面名樣式或 MAC | [05-網路與防火牆](05-網路與防火牆.md) · 4.5 NetworkManager 全域設定 |
| unprivileged user namespace | 一般使用者不需 root 就能建立的隔離命名空間，瀏覽器 sandbox 與 rootless 容器都靠它 | [08-安全強化](08-安全強化.md) · 5.1 🟠 AppArmor |
| unprivileged_bpf_disabled | 禁止非 root 使用 BPF 系統呼叫（在核心內執行使用者提供的小程式，用於封包過濾、追蹤） | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| unprivileged_userfaultfd | 是否允許非 root 使用 userfaultfd（由使用者空間處理缺頁） | [08-安全強化](08-安全強化.md) · 6.1 sysctl 強化（`/etc/sysctl.d/99-hardening.conf`，兩者共通） |
| update-crypto-policies | 切換 / 顯示目前策略的指令（`crypto-policies-scripts` 套件） | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| `update-grub` / `grub2-mkconfig` | 重新產生 GRUB 選單設定 | [11-備份與災難復原](11-備份與災難復原.md) · 8.3 手動重建流程（無映像時） |
| `update-secureboot-policy` | 🟠 `shim-signed` 附的工具，產生 / 重生 MOK（`/var/lib/shim-signed/mok/`）並觸發登錄 | [14-UEFI進階](14-UEFI進階.md) · 4.2 第三方模組與 MOK（DKMS / akmods） |
| updates-testing | 🔵 更新先進入測試通道、集滿回饋後才推進 `updates` 的機制（見 §1 的元件） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| UPG（User Private Group） | 建帳號時順便建一個同名、只有本人的主群組 | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| `uquota` / `gquota` / `pquota`（XFS） | XFS 的對應掛載選項，配額內建於 metadata | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 8. 磁碟配額（已實測 ext4 與 XFS） |
| URE（不可修復讀取錯誤） | 磁碟回報「這個磁區讀不出來」 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| usb-storage | USB 隨身碟 / 外接硬碟的驅動模組 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| usbguard | 依裝置 ID 建立 USB 白名單的守護程式 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| USE 方法 | Brendan Gregg 提出的資源檢查法：對每一種硬體資源都問使用率（Utilization）、飽和度（Saturation）、錯誤（Errors）三個問題 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| use_pty | 強制 sudo 在新的偽終端（pty）內執行指令，讓子程序碰不到呼叫者原本的終端 | [08-安全強化](08-安全強化.md) · 2.2 sudo 強化 |
| user service | 放在 `~/.config/systemd/user/`（或 `/usr/lib/systemd/user/`）的 unit | [04-系統管理](04-系統管理.md) · 1.6 使用者層級服務 |
| user-data / `#cloud-config` | 使用者提供的初始化內容；以 `#cloud-config` 開頭的 YAML 是最常用格式 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| `user-data` / `meta-data` | NoCloud 的兩個檔：前者是 cloud-config 設定本體，後者放 `instance-id` 等實例識別 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| `user_exec_content` 等 boolean | 控制 confined 使用者能否執行家目錄裡的程式 | [16-SELinux進階](16-SELinux進階.md) · 8. Confined 使用者與 MLS/MCS（進階） |
| useradd | shadow-utils 的低階建帳號指令，只做參數指定的事，預設**不**建家目錄、不設密碼 | [02-初始設定](02-初始設定.md) · 3.1 建立管理員帳號 |
| `useradd` / `usermod` / `userdel` | shadow-utils 提供的底層指令，不互動、適合腳本 | [04-系統管理](04-系統管理.md) · 2.1 帳號管理 |
| `usermod -aG` | 把既有帳號「附加」進群組的指令 | [02-初始設定](02-初始設定.md) · 3.1 建立管理員帳號 |
| USG | Ubuntu Security Guide：Ubuntu Pro 附的合規工具，把 SSG + oscap 包成 `usg audit` / `usg fix` | [08-安全強化](08-安全強化.md) · 10. 合規檢查與自動化強化 |
| USG / CIS | USG 是 Ubuntu 的合規工具；CIS 是它對照的業界安全基準 | [08-安全強化](08-安全強化.md) · 1.2 Live patch 與延伸支援 |
| `usrquota` / `grpquota`（ext4） | 掛載選項：啟用使用者 / 群組配額，配額表存在檔案系統根目錄的 `aquota.*` | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 8. 磁碟配額（已實測 ext4 與 XFS） |
| UTC vs local time | RTC 存的是 UTC 還是本地時間的兩種模式（`timedatectl` 的 `RTC in local TZ`） | [02-初始設定](02-初始設定.md) · 2. 時區、時間與語系 |
| `utmp` / `who` / `w` | 目前登入中的 session 紀錄（`/run/utmp`）/ 列出誰在線 / 再加上他們在跑什麼 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| UUID / LABEL | 檔案系統（或 LUKS、RAID）寫在自身內容裡的唯一識別碼 / 人類可讀名稱 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| `valid users` / `create mask` | 限制只有指定使用者或群組（`@smbusers`）能存取 / 新檔案的權限遮罩 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9.2 Samba（SMB / CIFS） |
| Valkey | Redis 在 2024 年改為非開源授權後，由 Linux 基金會維護的相容分支 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 8. 常見軟體安裝速查 |
| vdev | pool 內的冗餘單位：單碟、mirror、raidz | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.5 ZFS（🟠 Ubuntu 原生支援） |
| VDO LV（`-V`） | 掛在 vpool 上、對外呈現邏輯大小的 LV | [15-LVM進階](15-LVM進階.md) · 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生） |
| VDO（Virtual Data Optimizer） | Red Hat 的區塊層重複資料刪除 + 壓縮 + 精簡配置引擎 | [15-LVM進階](15-LVM進階.md) · 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生） |
| Vector | 用 Rust 寫的高效能日誌與指標管線：收集、轉換、路由到多種目的地 | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| Ventoy | 把 USB 做成「放 ISO 檔的隨身碟」的開機管理器，開機時列出裡面所有 ISO 供選擇 | [01-系統安裝](01-系統安裝.md) · 1.3 製作開機 USB |
| venv | Python 內建的虛擬環境：在指定目錄建一份獨立的 `site-packages` 與 `pip`，`activate` 後安裝都進那裡 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 7. 語言生態系套件管理（兩者共通） |
| versionlock | 🔵 dnf5 內建的鎖版本清單（`/etc/dnf/versionlock.toml`），列在清單內的套件升級時被排除 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.5 版本釘選與優先權 |
| veth | virtual ethernet：成對出現的虛擬網卡，一端在容器內、一端在宿主，Docker／Podman／LXD 用它把容器接到網路 | [05-網路與防火牆](05-網路與防火牆.md) · 4.5 NetworkManager 全域設定 |
| VFree | `vgs` 顯示的 VG 剩餘空間 | [11-備份與災難復原](11-備份與災難復原.md) · 6.1 LVM 快照（兩者；伺服器常用） |
| VG / LV | Volume Group 是一群實體磁碟合成的儲存池；Logical Volume 是從池裡切出的卷（15 章） | [11-備份與災難復原](11-備份與災難復原.md) · 6.1 LVM 快照（兩者；伺服器常用） |
| VG UUID / PV UUID | 每個 VG 與 PV 的唯一識別碼，寫在 metadata / label 裡 | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| vgcfgbackup / vgcfgrestore | 手動匯出 / 把某份副本寫回所有 PV | [15-LVM進階](15-LVM進階.md) · 6. Metadata 備份與還原（已實測） |
| `vgcfgrestore` | 把某份 metadata 副本寫回 VG 的指令 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.6 其他 |
| vgexport / vgimport | 在 metadata 上標記「此 VG 已交出」/ 取消標記 | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| `vgextend` / `lvextend` | 把新 PV 加入 VG / 放大某個 LV（配合 `--resizefs` 同時放大上面的檔案系統） | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| vgimportclone | 為克隆碟上的 PV / VG 產生新 UUID 並改名後匯入 | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| vgimportdevices | 🔵 掃描新碟並把找到的 VG 加進 devices file | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| `vgreduce --removemissing` | 把已經不存在的 PV 從 metadata 中移除 | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| vgsplit / vgmerge | 把某些 PV（及其上完整的 LV）拆成新 VG / 把兩個 VG 合一 | [15-LVM進階](15-LVM進階.md) · 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測） |
| VG（Volume Group） | 一個或多個 PV 合併成的儲存池，`vgcreate` 建立、`vgextend` 加入新 PV | [01-系統安裝](01-系統安裝.md) · 2.2 LVM 建議 |
| VIP | Virtual IP，不綁死在某台主機、可在節點間漂移的服務 IP | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| virsh | libvirt 的 CLI：開關機、快照、`dumpxml`、`console` 都由它 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| `virt-install` | libvirt 的命令列建 VM 工具；`--import` 表示「磁碟已有系統，不跑安裝程式」 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| virt-install / virt-clone / virt-manager | 分別是建 VM 的 CLI、複製 VM 的 CLI、桌面 GUI（🟠 `virtinst` / 🔵 `virt-install` 套件提供前兩者） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| virt-manager / GNOME Boxes | libvirt 的圖形前端：前者面向管理員，後者面向桌面使用者 | [01-系統安裝](01-系統安裝.md) · 6. 雲端 / 虛擬機映像 |
| virt-sysprep | libguestfs 工具，在 VM 關機狀態下離線清除 machine-id、host key、日誌等身分資訊 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 2. cloud-init（兩者共通） |
| VirtualBox / Vagrant / Proxmox VE | 桌面型 hypervisor／用描述檔自動建開發 VM 的工具／以 Debian 為基礎的獨立虛擬化平台 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| VirtualDomain | Pacemaker 的 resource agent，把一台 KVM VM 當成叢集資源在 host 之間啟停 | [10-高可用設計](10-高可用設計.md) · 7.4 虛擬化 / 容器層 |
| visudo | 帶檔案鎖與**語法檢查**的 sudoers 編輯器；`visudo -c` 只檢查不編輯、`-f` 可指定檔案 | [02-初始設定](02-初始設定.md) · 3.2 sudo 規則 |
| VLAN | IEEE 802.1Q：在乙太網框加標籤，讓一條實體線承載多個互相隔離的網段 | [05-網路與防火牆](05-網路與防火牆.md) · 3.3 Bonding、VLAN、Bridge（已用 `netplan generate` 驗證） |
| `vm.swappiness` | 核心多積極把頁面換出（0～200，預設 60） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 7. Swap |
| vmcore | 保存下來的主核心記憶體映像（`/var/crash/<date>/`） | [12-監控與故障排除](12-監控與故障排除.md) · 8. 核心當機分析（kdump） |
| `vmlinuz` / `initrd` | 壓縮後的 Linux 核心 / 安裝環境的 initramfs（§2.1） | [01-系統安裝](01-系統安裝.md) · 5.3 PXE / 網路開機重點 |
| vpool（VDO pool LV） | 實際佔 VG 空間的 VDO 池 | [15-LVM進階](15-LVM進階.md) · 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生） |
| VRRP | Virtual Router Redundancy Protocol，多台主機協商「誰持有 VIP」的標準協定（IP 協定 112） | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| vrrp_instance / virtual_router_id | 一組 VRRP 設定（一個 VIP 群組）；`virtual_router_id` 是這組的編號 | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| vrrp_script / track_script | `vrrp_script` 定義檢查腳本與 `interval`、`fall`、`rise`、`weight`；`track_script` 把它掛到某個 instance | [10-高可用設計](10-高可用設計.md) · 2. VIP 漂移：Keepalived（VRRP） |
| VT-x / AMD-V | Intel / AMD CPU 的硬體虛擬化指令集（`/proc/cpuinfo` 的 `vmx` / `svm`） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| wait-online | `systemd-networkd-wait-online`（🟠）/ `NetworkManager-wait-online`（🔵）：等網路真正連上才讓 `network-online.target` 完成 | [09-性能調校](09-性能調校.md) · 9. 開機與服務啟動時間 |
| WAL | Write-Ahead Log，PostgreSQL 每筆變更先寫入的交易日誌 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| WAL / binlog | PostgreSQL / MariaDB 的交易日誌，記錄每一筆變更 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| WatchdogSec / sd_notify | 服務層 watchdog：程式必須每隔一段時間呼叫 `sd_notify(WATCHDOG=1)` 報平安，逾時 systemd 就殺掉重啟 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| Wayland / X11 | 顯示伺服器協定：X11 是 1980 年代的舊架構，Wayland 是取代它、由合成器直接管畫面的新協定 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| webhook | 用 HTTP POST 把訊息推到 Slack / Teams / 自家服務的 URL | [12-監控與故障排除](12-監控與故障排除.md) · 1.4 簡易腳本監控 + 通知 |
| wg-quick ／ PostUp | 讀 conf 檔建立整個介面的腳本（systemd 單元 `wg-quick@`）／介面起來後執行的指令 | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| `wheel` 群組 | 🔵 Fedora / RHEL 系授權執行 `sudo` 的群組（🟠 對應 `sudo` 群組） | [01-系統安裝](01-系統安裝.md) · 4. 🔵 Fedora 44 互動式安裝（Anaconda） |
| Windows Boot Manager | Windows 的 UEFI 載入器（`EFI/Microsoft/Boot/bootmgfw.efi`）與其 NVRAM 項 | [14-UEFI進階](14-UEFI進階.md) · 11. 雙系統與多 ESP |
| WireGuard | 核心 5.6 起內建的 VPN 協定與介面類型（`wg0`），以 UDP 傳輸、Curve25519 金鑰認證 | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| witness / qdevice | 不跑服務、只投一票的第三方仲裁節點（Pacemaker 叫 qdevice） | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| wpa_supplicant | 負責與無線基地台完成 WPA／WPA2／WPA3 認證與加密握手的 daemon | [05-網路與防火牆](05-網路與防火牆.md) · 3.4 Wi-Fi（Desktop 通常用 NM GUI；Server 也可） |
| `writemostly` | 標記某副本「盡量只寫不讀」 | [15-LVM進階](15-LVM進階.md) · 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層） |
| WSL / 容器 | 沒有真實韌體的環境 | [14-UEFI進階](14-UEFI進階.md) · 12. UEFI 故障排除 |
| `wsl.conf` | 每個發行版內的 `/etc/wsl.conf`，設定 systemd、掛載、網路等 WSL 專屬行為 | [01-系統安裝](01-系統安裝.md) · 7. WSL2 安裝（Windows） |
| WSL2 | Windows Subsystem for Linux 第 2 版：在 Windows 內建的輕量 Hyper-V 虛擬機中跑真正的 Linux 核心 | [01-系統安裝](01-系統安裝.md) · 7. WSL2 安裝（Windows） |
| wsrep | Write-Set Replication，Galera 在 MariaDB 內的 API 與參數前綴（`wsrep_on`、`wsrep_provider` …） | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| `wtmp` / `btmp` / `lastlog` | 三個二進位登入紀錄檔（成功登入、失敗登入、每帳號最後登入） | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| `wtmp` / `last` | 成功登入與登出的二進位紀錄（`/var/log/wtmp`）/ 讀它的指令 | [07-日誌管理](07-日誌管理.md) · 6. 登入與安全相關日誌 |
| www-data | 🟠 Ubuntu 上 nginx / Apache / PHP-FPM 的執行帳號（🔵 Fedora 為 `nginx` / `apache`） | [08-安全強化](08-安全強化.md) · 5. 強制存取控制 |
| `x-systemd.automount` | 掛載選項：先建一個 autofs 掛載點，第一次存取時才真的掛（懶掛載） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.2 建立與掛載 |
| x86-64-v1 / v2 | x86-64 的「微架構等級」：v1 是 2003 年的基本指令集，v2 額外要求 SSE4.2、POPCNT、SSSE3 等擴充（約 2009 年 Nehalem 之後的 CPU 都有） | [01-系統安裝](01-系統安裝.md) · 1.4 硬體需求（實務建議） |
| `xargs` | 把 stdin 的內容轉成後面那個指令的參數 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 5. 其他常見指令 |
| xattr | 檔案的擴充屬性，SELinux 標籤（`security.selinux`）就存在這裡 | [11-備份與災難復原](11-備份與災難復原.md) · 3. rsync |
| xattr `security.selinux` | 檔案標籤實際存放的擴充屬性 | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| XBOOTLDR / `$BOOT` | Extended Boot Loader Partition：ESP 太小時另建的第二個分割（GPT 類型 `ea00`），規範允許 entry 與核心放這裡；`$BOOT` 是規範對「放核心的分割」的統稱 | [14-UEFI進階](14-UEFI進階.md) · 5.3 systemd-boot（極簡替代方案，只支援 UEFI） |
| XFS | 高效能日誌式檔案系統，擅長大檔與平行 I/O，只能擴不能縮 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| YAML | 以縮排表示階層的設定檔格式 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| Zabbix / Nagios / Icinga / Checkmk | 傳統 agent + server 式監控 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| ZFS | 源自 Solaris 的 copy-on-write 檔案系統兼卷管理，功能最完整 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| zone | firewalld 的信任等級群組（`public`、`internal`、`trusted`…），每張網卡屬於一個 zone，規則掛在 zone 上 | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| zram | 核心在記憶體內建立的「壓縮區塊裝置」，當 swap 用 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 7. Swap |
| zram / `zram-generator` | 在記憶體中劃出一塊壓縮區當 swap 裝置；🔵 由 `zram-generator` 服務在開機時自動建立 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| zstd 壓縮 | Btrfs 的透明壓縮演算法之一，`compress=zstd:1` 表示最快的等級 | [01-系統安裝](01-系統安裝.md) · 2.3 檔案系統選擇 |
| "A start job is running" | systemd 等某個 unit（多半是掛載或 wait-online）完成的提示，預設等 90 秒 | [12-監控與故障排除](12-監控與故障排除.md) · 3.2 常見開機問題 |
| `#cloud-config` | `user-data` 第一行的魔術標頭，告訴 cloud-init「這是 YAML 設定而不是 shell 腳本」 | [01-系統安裝](01-系統安裝.md) · 5.1 🟠 Ubuntu autoinstall 範例 |
| `%ghost` 檔 | RPM 規格中「屬於套件、但不隨套件安裝」的檔案，通常是留給使用者自己建立的設定檔 | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| `%post` / `--log` | 安裝完成後在新系統內（chroot）執行的 shell 區段，`--log` 把輸出存到指定檔案 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| %wa / %st | `vmstat` / `top` 的 CPU 時間分類：`wa`（iowait）是 CPU 閒著等磁碟 I/O 的比例，`st`（steal）是被 hypervisor 拿走的比例 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| `%群組` | 前綴 `%` 表示這條規則套用到整個群組的成員 | [02-初始設定](02-初始設定.md) · 3.2 sudo 規則 |
| `&&` / `\|\|` | 短路運算：`a && b` 在 a 成功時才執行 b；`a \|\| b` 在 a 失敗時才執行 b | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| `&>`、`\|&` | bash 專用簡寫：`&> file` 等於 `> file 2>&1`；`\|&` 等於 `2>&1 \|` | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 2. 重新導向與管線 |
| `(allow src tgt (class (perm …)))` | CIL 的 allow 規則，等同 `.te` 的 `allow src tgt:class { perm };` | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| `(boolean …)` / `(booleanif …)` | 定義 boolean / 依 boolean 開關的條件規則 | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| `(portcon tcp 埠 (context))` | 在模組內把埠綁到 port type | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| `(typeattributeset cil_gen_require T)` | 宣告「T 由別的模組定義，這裡只是引用」 | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| `(typetransition …)` | 檔案建立或程序執行時的自動標籤 / domain 轉換規則，可指定檔名 | [16-SELinux進階](16-SELinux進階.md) · 5.3 CIL：更簡潔的小型規則（已實測） |
| `:omusrmsg:*` | 輸出到所有登入使用者的終端 | [07-日誌管理](07-日誌管理.md) · 3.1 安裝與預設 |
| `:z` / `:Z` | 掛載 volume 時要求引擎把主機目錄重新標成容器可讀的 SELinux 標籤（`z` 多容器共用、`Z` 單一容器專屬） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.1 Docker vs Podman |
| `:Z` / `:z`（Podman） | 容器掛載選項：自動把該目錄貼上容器專用標籤（Z 私有、z 多容器共享） | [08-安全強化](08-安全強化.md) · 5.2 🔵 SELinux |
| `<` | 把檔案接到程式的 stdin | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 2. 重新導向與管線 |
| `[ ]`（`test`）/ `[[ ]]` | 產生 exit code 的判斷指令：`[` 是 POSIX 的 `test` 程式；`[[` 是 bash 內建關鍵字，不做分詞、支援 `=~` | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 4. 條件與錯誤處理慣用語 |
| `[Install]` 段 | 描述 `enable` 時要掛到哪個 target | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| `[Service]` 段 | 描述怎麼啟動與限制：`Type=`、`ExecStart=`、`Restart=`、資源與沙箱選項 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| `[Unit]` 段 | 描述說明與相依：`Description=`、`After=`、`Wants=` | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| `~/.ssh/authorized_keys` | 伺服器端每個帳號各自的公鑰清單，一行一把 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| `~/.ssh/config` | 客戶端的每主機設定檔：`Host` 別名 → 實際主機名、帳號、金鑰、跳板、埠 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| 「SELinux 拖慢系統」 | AVC 快取命中率 > 99%，開銷通常 < 2% | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| 一致性 | 檔案系統的結構（inode、目錄、空間位圖）彼此吻合 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.3 檢查與修復 |
| 一致性快照（fsfreeze） | 平台做快照前，由 agent 呼叫 `fsfreeze` 暫停檔案系統寫入並把緩衝 flush 到磁碟，快照完再解凍 | [02-初始設定](02-初始設定.md) · 9.5 虛擬機 Guest Agent |
| 三層目錄 | `/usr/lib`（套件）、`/run`（執行期自動產生）、`/etc`（管理員），後者優先 | [04-系統管理](04-系統管理.md) · 1.2 單元檔位置與優先權 |
| 上游 / 下游 | 上游是原始碼或發行版的來源；下游取用上游成果再加工發布 | [00-差異速查表](00-差異速查表.md) · 00 - Ubuntu 與 Fedora 差異速查表 |
| 上游 DNS（per-link DNS） | resolved 真正去問的外部 DNS 伺服器，逐張網卡記錄 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| 不可變（immutable）發行版 | 系統目錄唯讀、以整份映像為單位更新與回滾的變體：🟠 Ubuntu Core 靠 snap，🔵 Silverblue / CoreOS 靠 rpm-ostree / bootc | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| 並聯（parallel）冗餘 | 多個同功能節點任一存活即可（LB 後面的兩台應用） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 中斷合併（coalescing） | 網卡累積多個封包才發一次中斷，用一點延遲換 CPU | [09-性能調校](09-性能調校.md) · 5. 網路 |
| 中間人攻擊（MITM） | 攻擊者站在使用者與伺服器之間轉發並讀改流量 | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| 串流複製 | PostgreSQL 原生功能：primary 把 WAL（交易日誌）即時串流給 replica 重放 | [10-高可用設計](10-高可用設計.md) · 6.1 PostgreSQL：Patroni + etcd + HAProxy（業界標準） |
| 串聯（serial）相依 | 服務 A 需要 B 才能運作（應用需要 DB、DNS、網路） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 主從複製（replica） | Redis 原生功能，主節點把寫入非同步送到從節點 | [10-高可用設計](10-高可用設計.md) · 6.3 Redis / Valkey |
| 主控台 / Live 媒體 | 主控台是本機螢幕鍵盤或 BMC / 雲端序列埠；Live 媒體是可開機的安裝 USB | [12-監控與故障排除](12-監控與故障排除.md) · 3. 開機故障 |
| 交換檔（swapfile） | 放在檔案系統內的一般檔案當 swap 用 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 7. Swap |
| 交易（transaction） | 把一次安裝 / 移除牽涉到的所有套件當成一個整體記錄 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| 休眠（hibernate） | 把整個記憶體內容寫進 swap 後關機，下次開機還原 | [01-系統安裝](01-系統安裝.md) · 2.1 建議配置（伺服器） |
| 佇列（`queue.*`） | action 前的緩衝區：`LinkedList` 放記憶體、`saveOnShutdown` 關機時落地到磁碟 | [07-日誌管理](07-日誌管理.md) · 3.3 集中式：rsyslog 遠端傳送 / 接收 |
| 位元級映像 | 與來源逐位元相同的複本 | [11-備份與災難復原](11-備份與災難復原.md) · 8.2 Clonezilla / dd |
| 低階工具 `dpkg` / `rpm` | 對單一套件檔解包、執行安裝腳本、寫入本機資料庫的工具，不上網、不解相依 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 使用率 / 飽和 / 錯誤 | 使用率＝資源忙碌時間的比例；飽和＝排隊等資源的工作量；錯誤＝資源回報的失敗次數 | [09-性能調校](09-性能調校.md) · 1. 觀測工具總覽（USE / RED 方法） |
| 使用者實例（`systemd --user`） | 每位登入使用者各自擁有的一個 systemd 程序，以該使用者身分管理自己的 unit | [04-系統管理](04-系統管理.md) · 1.6 使用者層級服務 |
| 使用者限制 | 無（profile 綁程式） | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 保留（kept back） | 🟠 `apt upgrade` 發現某套件的新版需要「新增或移除其他套件」時，選擇不動它、在輸出裡列為 kept back 的狀態 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| 信任庫（trust store） | 系統集中存放「信任的 CA 根憑證」的地方：🟠 `/usr/local/share/ca-certificates/` + `update-ca-certificates`、🔵 `/etc/pki/ca-trust/source/anchors/` + `update-ca-trust` | [08-安全強化](08-安全強化.md) · 9.2 內部 CA / 自簽 |
| 信任欄位（`_` 開頭） | 由 journald 從核心取得、程式無法偽造的欄位：`_PID`、`_UID`、`_COMM`、`_SYSTEMD_UNIT`、`_TRANSPORT` | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| 信號（signal）：TERM / KILL / HUP | 核心送給程序的通知：TERM 請它自行結束、KILL 由核心直接終止不給機會、HUP 慣例上表示「重讀設定」 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| 假設（hypothesis） | 對根因的猜測，必須可被一個指令驗證或排除 | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 健康檢查 | 定期探測節點是否還能正常服務（ping、TCP 連線、HTTP 回 200） | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| 健康檢查 DNS（GSLB） | 依健康探測結果動態回應不同 IP 的 DNS 服務（Route 53、Cloudflare LB） | [10-高可用設計](10-高可用設計.md) · 7.3 網路層冗餘 |
| 偽檔案系統 | `/proc`、`/sys`、`/dev`、`/run` 這類由核心即時產生、不在磁碟上的目錄 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| 備份（backup） | 存放在另一個地方、保留多個時間點、可獨立還原的資料副本（restic / borg） | [11-備份與災難復原](11-備份與災難復原.md) · 1. 策略 |
| 備援 SSH 埠 | 升級期間另開一個 sshd（🟠 `do-release-upgrade` 自動開 1022） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| 備援 sshd（1022 埠） | 升級程式在 SSH 環境下額外啟動的第二個 sshd，監聽 1022 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🟠 Ubuntu：`do-release-upgrade` |
| 元件（component） | 官方套件庫依授權與支援等級再分的子區：🟠 main（Canonical 支援）/ universe（社群維護）/ restricted（非自由驅動）/ multiverse（專利或授權受限）；🔵 fedora（發行時凍結的基礎版）/ updates（正式更新）/ updates-testing（測試中的更新） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 內部 CA（私有 CA） | 自己建立的一組 CA 金鑰與根憑證，專門簽內網服務的憑證 | [08-安全強化](08-安全強化.md) · 9.2 內部 CA / 自簽 |
| 全域可寫（world-writable） | 其他人（other）有寫入權限的檔案（`-perm -0002`） | [08-安全強化](08-安全強化.md) · 2.4 帳號清查 |
| 全盤重標 | 不需要 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 公有雲（IaaS） | 向雲端租用 VM、儲存、網路，按用量計費 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 公鑰 / keyring / 指紋 | 驗證簽章用的官方公鑰（🟠 從 keyserver 抓；🔵 從 `fedora.gpg` 匯入本機 keyring），指紋是公鑰的雜湊 | [01-系統安裝](01-系統安裝.md) · 1.2 校驗映像完整性 |
| 冗餘 | 可壞掉幾顆成員碟而不丟資料 | [15-LVM進階](15-LVM進階.md) · 2. 條帶化（Striped）與 RAID LV |
| 冗餘 N+1 / 2N | N+1 = 比實際需要多備一台；2N = 整套再複製一份（雙機房等級） | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| 冪等（idempotent） | 同一份 playbook 重跑多次，結果與跑一次相同；module 先比對現況，已符合就回報 ok 而不動 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| 冷儲存 | 存取費高、取回慢（數小時到一天）但存放極便宜的儲存層級 | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| 分割區 / GPT | 把一顆磁碟切成數個固定區段；GPT 是 UEFI 時代的分割表格式（取代 MBR，支援 > 2 TB 與超過 4 個主分割區） | [01-系統安裝](01-系統安裝.md) · 2. 分割區規劃 |
| 分割區（partition） | 依分割表把一顆實體碟切出的連續區段 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| 分割表（partition table） | 寫在磁碟開頭、記錄每個分割區起訖位置與類型的資料結構 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| 分層排查 | 由下而上（硬體 → 核心 → 儲存 → 網路 → 服務 → 應用）或由外而內（客戶端 → 網路 → 主機 → 程序）逐層縮小範圍 | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 分散式儲存 | 資料自動切片並複製到 3+ 節點，任一節點壞掉自動修復（Ceph、GlusterFS） | [10-高可用設計](10-高可用設計.md) · 5. 共享儲存與資料複製 |
| 分散（distribution） | 多台小機器各司其職 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 分階段（phased）建置 | 先建最小可用版本驗證，再依實際負載升級設計 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 列表型設定 | `ExecStart=`、`Environment=` 這類可以寫多次、值會累積的鍵 | [04-系統管理](04-系統管理.md) · 1.2 單元檔位置與優先權 |
| 前置條件（precondition） | 開始設計之前必須成立的事實：有擁有者、有預算、有時程、問題陳述清楚、資料分級已知 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 加密（at rest） | 資料在存入 repo 前就在來源端加密，目標端看不到內容 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| 加權評分（decision matrix） | 列出評估準則、給權重、對每個選項打分後加總 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 勒索軟體 | 入侵後加密所有可寫入的資料（含掛載中的備份目標）再勒索贖金的惡意程式 | [11-備份與災難復原](11-備份與災難復原.md) · 1. 策略 |
| 匿名頁（anonymous pages） | 程序的 heap / stack 等不對應任何檔案的記憶體（`/proc/meminfo` 的 AnonPages） | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| 區塊儲存（block） | 以磁碟區塊為單位提供、由使用端自己建檔案系統的儲存（磁碟、LV、DRBD、Ceph RBD） | [10-高可用設計](10-高可用設計.md) · 5. 共享儲存與資料複製 |
| 區塊層級複製 | 在區塊層把每次寫入同步到另一台（DRBD） | [10-高可用設計](10-高可用設計.md) · 5. 共享儲存與資料複製 |
| 區塊裝置（block device） | 核心以固定大小區塊隨機存取的裝置；`/dev/sda`、`/dev/md0`、`/dev/mapper/*`、`/dev/vg/lv` 都是 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 1. 觀察儲存狀態 |
| 升級流程（escalation） | 第一線處理不了時該通知誰、多久沒回應就往上找誰 | [11-備份與災難復原](11-備份與災難復原.md) · 10.1 文件內容 |
| 半安裝狀態 | 🟠 dpkg 已解開檔案但安裝腳本失敗或相依未滿足，套件在 `/var/lib/dpkg/status` 停在 `half-installed` / `unpacked` 的狀態 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| 原卷（origin） | 被拍快照的那個 LV | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.4 快照（備份前必做；已實測含合併還原） |
| 去重（檔案級 / 區塊級） | 相同內容只存一份：檔案級以整個檔案比對（hardlink）；區塊級把檔案切塊比對，改一點只存那一塊 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| 參數展開（`${VAR:-default}`、`${VAR:?msg}`） | 變數展開的擴充語法：未設定時給預設值 / 未設定時印出訊息並結束 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| 反引號 | 指令替換的舊寫法 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| 可否換用對方 | 可裝 SELinux（`selinux-basics`、`selinux-policy-default` 2.20240202，Debian refpolicy），不建議 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 可用性等級（Tier） | 依「停機造成的損失」把系統分級，每級對應允許的年停機時數與必要的冗餘 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 可用性（availability） | 一段期間內「服務可用」的時間或請求比例，以 % 表示 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 可移除媒體路徑 | `EFI/BOOT/BOOTX64.EFI`，規範保證韌體在沒有任何有效 Boot#### 時會嘗試它（§2） | [14-UEFI進階](14-UEFI進階.md) · 3. NVRAM 開機項：efibootmgr |
| 合併（merge） | `lvconvert --merge` 把快照存的舊區塊寫回原卷 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.4 快照（備份前必做；已實測含合併還原） |
| 合規（CIS/STIG） | AppArmor enforce 即可 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 合規（compliance） | 外部規範（PCI-DSS、ISO 27001、個資法、CIS 基準）對設定與紀錄的強制要求 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 同步 / 非同步複製 | 同步 = 寫入等副本確認才成功（RPO ≈ 0）；非同步 = 先成功再送副本（可能丟最後幾筆） | [11-備份與災難復原](11-備份與災難復原.md) · 1.2 RPO 與 RTO |
| 告警規則（rule_files / for / severity） | `rule_files` 指向規則檔；`for` 是條件要持續多久才觸發；`severity` 是自訂的嚴重度標籤 | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| 唯讀快照（`-r`） | 建立後不能修改的快照 | [11-備份與災難復原](11-備份與災難復原.md) · 6.2 Btrfs 快照（🔵 Fedora Workstation 預設） |
| 商業支援 | 付費取得供應商支援、延長生命週期與合規工具（Ubuntu Pro、RHEL 訂閱） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 商用元件 | 需付費授權的軟體（商用 DB、備份套件、LB 設備） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 啟用（activation） | 把 LV 的 LE → PE 表載入 device-mapper，產生 `/dev/vg/lv` | [15-LVM進階](15-LVM進階.md) · 7. 啟用、鎖定與 initramfs |
| 單一租戶 | 一套系統只服務一個客戶 / 團隊 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 單元檔（unit file） | 描述一個 unit 的 INI 檔，分 `[Unit]`、`[Service]`、`[Install]` 等段 | [04-系統管理](04-系統管理.md) · 1.2 單元檔位置與優先權 |
| 單向門 / 雙向門（one-way / two-way door） | 不可逆（改要重裝或搬資料）vs 可逆（換掉成本低）的決策 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 回滾（rollback） | 把卷還原到快照當下的狀態 | [11-備份與災難復原](11-備份與災難復原.md) · 6. 快照（一致性與快速回滾） |
| 圖形化寫入工具 | 幫你挑裝置、附確認畫面的 `dd` 包裝（🟠 Startup Disk Creator、Rufus、balenaEtcher；🔵 Fedora Media Writer） | [01-系統安裝](01-系統安裝.md) · 1.3 製作開機 USB |
| 在 permissive 測完就上線 | permissive 只記錄，enforcing 才會擋；某些 AVC 在 permissive 下不會出現（第一次拒絕後的後續動作） | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| 基準 / 資料庫（`aide.db` / `aide.db.new`） | `--init` 產生的檔案快照；`--check` 拿目前狀態與它比 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| 基準（baseline） | 正常狀態下記錄的一組數據（`sar -A`），之後所有比對的參照 | [09-性能調校](09-性能調校.md) · 10. 壓力測試與基準 |
| 增量備份 | 只備份上次以來變動的部分 | [11-備份與災難復原](11-備份與災難復原.md) · 1.2 RPO 與 RTO |
| 壅塞控制（CUBIC / BBR） | TCP 決定送多快的演算法：CUBIC 以丟包為訊號，BBR 以量測頻寬與 RTT 為訊號 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| 壓縮（compression） | 區塊寫入前先壓縮 | [15-LVM進階](15-LVM進階.md) · 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生） |
| 外掛（cockpit-machines / -podman / -storaged / -selinux） | 各自加一個頁面：管 libvirt VM（§4）、Podman 容器（§3）、磁碟 / LVM、SELinux | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 8. 多主機管理：Cockpit |
| 多 ESP | 一顆磁碟或一台機器上有多個 EFI System Partition | [14-UEFI進階](14-UEFI進階.md) · 11. 雙系統與多 ESP |
| 多佇列 / RPS / RFS | 多佇列網卡把封包依流分到多個 ring buffer 與 IRQ；RPS / RFS 是在單佇列網卡上用軟體把處理分散到多核心 | [09-性能調校](09-性能調校.md) · 5. 網路 |
| 多租戶（共用） | 一套系統服務多個客戶 / 團隊，靠帳號、cgroup、容器或命名空間隔離 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 大版本升級 | 從 24.04 升 26.04、從 44 升 45 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| 套件庫（repository） | 放套件檔與索引的伺服器，由本機設定檔指向它 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| 套件歷史 | 套件管理器記錄的安裝 / 升級 / 移除紀錄（🟠 `/var/log/apt/history.log`、🔵 `dnf history`） | [12-監控與故障排除](12-監控與故障排除.md) · 2. 故障排除方法論 |
| 套件清單 | 系統上手動安裝了哪些套件的文字清單（`apt-mark showmanual` / `dnf repoquery --userinstalled`） | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| 套件群組 `@^` / `@` / `-` | `%packages` 內的前綴：`@^` 指定環境（environment）、`@` 加群組、`-` 排除套件 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| 套件（`.deb` / `.rpm`） | 把程式檔案、設定檔、安裝腳本與「相依清單」打成一個檔案的格式；🟠 `.deb` 依 Debian **政策手冊**（Debian Policy，規定套件怎麼打包、檔案該放哪的規範文件）打包，🔵 `.rpm` 由 Red Hat 定義 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 媒體 | 存放資料的實體型態：磁碟、磁帶、雲端物件儲存 | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| 子 shell | shell 另外 fork 出的一份自己，用來執行 `( )`、`$( )` 與管線的每一段 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 子卷（subvolume） | Btrfs 內部可各自掛載、各自快照的邏輯目錄樹（🔵 預設有 `root` 與 `home` 兩個） | [01-系統安裝](01-系統安裝.md) · 2.3 檔案系統選擇 |
| 子策略（`:NO-SHA1` 等 `.pmod`） | 疊在主策略上的增減片段，用冒號串接 | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| 孤兒相依（autoremove） | 當初只因為別的套件需要而被自動裝入、現在已沒有任何套件需要的套件 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| 安全更新（security update） | 只修漏洞、不加功能的套件版本：🟠 來自 `-security` 套件庫（如 `noble-security`），🔵 由套件庫更新元資料標記 `type=security` | [02-初始設定](02-初始設定.md) · 9.1 自動安全更新（詳見第 08 章） |
| 安全群組 / NAT | 雲端主機外的虛擬防火牆 / 位址轉換 | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| 完整覆寫（`edit --full`） | 把整份單元檔複製到 `/etc` 再改 | [04-系統管理](04-系統管理.md) · 1.2 單元檔位置與優先權 |
| 容器 volume 用 `--privileged` | 關掉全部隔離 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| 容器平台（Kubernetes 等） | 以容器為部署單位、由編排器排程與自癒的平台 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 容器整合 | Docker/Podman 預設 `docker-default` profile | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 容器映像層 / volume | 映像層是可從 Dockerfile 重建的唯讀層；volume 才是容器的持久資料 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| 容量規劃（capacity planning） | 估算 CPU、記憶體、儲存、網路在生命週期內的需求並預留成長 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 密碼檔 / RESTIC_PASSWORD_FILE | 解開 repo 的主密碼所在檔案 | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| 密碼登入（PAM） | Cockpit 透過 PAM 驗系統帳號密碼，與 SSH 的 `PasswordAuthentication` 設定無關 | [02-初始設定](02-初始設定.md) · 9.3 Cockpit 網頁管理介面 |
| 實測 RTO / RPO | 演練中實際量到的還原時間與資料遺失量 | [11-備份與災難復原](11-備份與災難復原.md) · 10.2 演練情境（至少每半年） |
| 實體機（bare metal） | 作業系統直接裝在硬體上 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 封包過濾（netfilter / nftables） | 核心內依規則決定每個封包放行或丟棄的機制；nftables 是現行的規則語言與工具 | [02-初始設定](02-初始設定.md) · 6. 防火牆基本啟用（詳見第 05 章） |
| 專案配額（project quota） | XFS 獨有：以「目錄樹」為單位限制總量，不分使用者 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 8. 磁碟配額（已實測 ext4 與 XFS） |
| 對齊（alignment） | 分割區起點落在磁碟實體區塊（4 KiB）或 SSD 抹除區塊的整數倍位置 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| 對齊（`pe_start`） | PV 上第一個 PE 的起始位移（預設 1 MiB） | [15-LVM進階](15-LVM進階.md) · 1.1 PE 大小與對齊 |
| 屬性（property）：`$programname`、`$msg` | rsyslog 為每筆訊息解析出的欄位：程式名稱、訊息本文、`$fromhost-ip` 來源 IP 等 | [07-日誌管理](07-日誌管理.md) · 3.2 自訂規則範例 |
| 巢狀虛擬化（nested） | 讓 VM 裡面再跑 KVM | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 4. 虛擬化：KVM / libvirt（兩者共通） |
| 工作負載（workload） | 主機實際跑的東西的型態：web / API、資料庫、檔案服務、批次、容器平台、桌面 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 已刪除但仍開啟的檔案 | 檔案被 `rm` 後只要還有程序持有描述子，區塊就不會釋放 | [12-監控與故障排除](12-監控與故障排除.md) · 4. 磁碟與檔案系統 |
| 帳號 / UID | 使用者帳號是 `/etc/passwd` 的一筆紀錄，核心只認它的數字 UID | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| 序列主控台（serial console） | 透過序列埠（`ttyS0`）而非螢幕輸出開機訊息與登入提示 | [04-系統管理](04-系統管理.md) · 5.2 GRUB 與開機參數 |
| 序列埠 console / IPMI | `console=ttyS0` 讓核心把訊息也送到序列埠；IPMI 是伺服器主機板的遠端管理介面，可把序列埠內容轉成網路存取（SOL） | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| 建置相依 / `-dev` 套件 | 編譯時才需要、執行時不需要的東西：標頭檔（`.h`）、靜態庫、`pkg-config` 描述檔；🟠 命名為 `libxxx-dev`、🔵 為 `xxx-devel` | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 6. 原始碼編譯 |
| 建議套件 / 弱相依 | 套件 metadata 裡「有它更好、沒有也能跑」的軟性相依：🟠 稱 Recommends（`apt` 預設會裝），🔵 稱 weak deps（`install_weak_deps` 預設為 True） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| 後端（backend） | repo 的儲存類型：本機路徑、`sftp:`、`s3:`、`rclone:` | [11-備份與災難復原](11-備份與災難復原.md) · 4. restic（推薦；已實測） |
| 後端（remote） | repo 實際存放的位置類型：本機、SFTP、S3、rclone 支援的任何雲端 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| 微碼（microcode） | CPU 內部的可更新指令實作，Spectre / Meltdown 緩解靠它 | [14-UEFI進階](14-UEFI進階.md) · 9. 韌體更新：fwupd / LVFS |
| 快取 | 高階工具下載後尚未刪除的套件檔與索引 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 快照 | 某一時刻的檔案系統狀態，可回滾或當備份來源 | [00-差異速查表](00-差異速查表.md) · 5. 儲存與檔案系統 |
| 快照（Btrfs） | 子卷在某一瞬間的 COW 副本，本身也是子卷 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.4 Btrfs（🔵 Fedora Workstation 預設） |
| 快照（LVM / Btrfs / VM） | 升級前的檔案系統或 VM 時間點副本（11 章、§4） | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 10. 發行版升級實務清單（承 03 章 §9） |
| 快照（snapshot） | 一個記錄「原卷從某一瞬間起被改掉的區塊之舊內容」的特殊 LV | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.4 快照（備份前必做；已實測含合併還原） |
| 憑證（certificate） | 一份被 CA 簽章的檔案，內容是「這把公鑰屬於 example.com」 | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| 應用自有日誌檔 vs journal | 應用自己開檔寫 `/var/log/<svc>/` / 交給 systemd 擷取 stdout 進 journal | [07-日誌管理](07-日誌管理.md) · 7. 應用程式日誌慣例 |
| 把資料放 `/home/x` 給 nginx 讀並 `chmod 777` | 標籤是 `user_home_t`，DAC 開再大也沒用 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| 指令 vs 區段 | 檔案前半是一行一個的指令（`lang`、`network`、`part`…）；後半是 `%packages` / `%pre` / `%post` 到 `%end` 的區段 | [01-系統安裝](01-系統安裝.md) · 5.2 🔵 Fedora Kickstart 範例 |
| 指令替換（`$( )`） | shell 先執行括號內的指令，把它的 stdout 當字串放回命令列 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 指標（metrics） | 帶時間戳的數值序列（如每 15 秒一筆 CPU 使用率） | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| 指紋（fingerprint） | 公鑰的 SHA256 雜湊（`SHA256:...`），人可核對的短識別碼 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| 掛載點（mount point） | 一個檔案系統被接到目錄樹的位置，例如 `/var`、`/home` | [01-系統安裝](01-系統安裝.md) · 2. 分割區規劃 |
| 控制機 / 受管機 / agentless | 控制機是裝了 Ansible 的那台；受管機是被設定的機器；agentless 指受管機不需常駐任何代理程式 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 1. Ansible（設定管理，兩者共通） |
| 提權（privilege escalation） | 從低權限帳號（www-data、一般使用者）取得 root | [08-安全強化](08-安全強化.md) · 6. 核心與系統層 |
| 搜尋網域（search domain） | 查短主機名時自動補上的尾碼（`search: [example.com]` → `db` 變 `db.example.com`） | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| 搬移檔案 | 路徑變了 profile 就不適用 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 支援週期 | 發行版承諾提供安全性更新的期間：🟠 LTS 5 年、🔵 每版約 13 個月（下下版釋出後一個月） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 9. 發行版大版本升級 |
| 政策庫（policy store） | `/var/lib/selinux/targeted/active/`：semanage / semodule 的實際存放處（`modules/`、`ports.local`、`file_contexts.local`、`booleans.local`…） | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| 政策模組 / priority | 政策由數百個模組組成（一個服務一個）；同名模組可同時存在多個優先權，數字大的生效 | [16-SELinux進階](16-SELinux進階.md) · 2. Targeted 政策的組成 |
| 政策語言 | AppArmor profile（路徑 + 權限字母） | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 救援 ISO（`OUTPUT=ISO`） | rear 做出的可開機映像，內含本機核心、驅動、佈局描述與 `rear recover` | [11-備份與災難復原](11-備份與災難復原.md) · 8.1 Relax-and-Recover（rear，兩者皆有套件） |
| 救援金鑰（recovery key） | `systemd-cryptenroll --recovery-key` 產生的隨機長密碼，佔一個 keyslot | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| 整機映像 | 含分割區、開機載入器與所有資料的整顆碟複本 | [11-備份與災難復原](11-備份與災難復原.md) · 2. 工具比較 |
| 日誌式檔案系統（journaling） | 每次修改 metadata 前先把「要做什麼」寫進日誌區，斷電後重播日誌就能回到一致狀態 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.1 選擇 |
| 日誌重播（log replay） | 掛載時把日誌區中尚未落盤的操作補做完 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.3 檢查與修復 |
| 日誌（logs） | 逐筆事件的文字記錄 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| 早期使用者空間 → 切換根目錄 | initramfs 裡的 init 找到並掛載真正的根檔案系統後，`switch_root` 過去再啟動 systemd | [04-系統管理](04-系統管理.md) · 5.3 initramfs |
| 映像（image） | 整顆磁碟或整台機器的複本，含分割區與開機環境（rear / Clonezilla / dd） | [11-備份與災難復原](11-備份與災難復原.md) · 1. 策略 |
| 時區（tzdata） | 「UTC 與本地時間的換算規則」資料庫（`/usr/share/zoneinfo`），`/etc/localtime` 指向其中被選用的那一份 | [02-初始設定](02-初始設定.md) · 2. 時區、時間與語系 |
| 時序（time series） | 一個指標名稱＋一組標籤（instance、job…）對應的時間數列 | [12-監控與故障排除](12-監控與故障排除.md) · 1.2 Prometheus + Alertmanager + Grafana |
| 最後成功時間戳 | 每次備份成功時記錄的 Unix 時間 | [11-備份與災難復原](11-備份與災難復原.md) · 10.3 備份監控 |
| 最近變更 | 上次正常到現在之間發生的部署、升級、設定修改 | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 服務名稱 | service unit 的名字（`nginx.service`，`.service` 可省略） | [04-系統管理](04-系統管理.md) · 1. systemd 服務管理 |
| 本機套件檔 | 自己下載到磁碟上的 `.deb` / `.rpm`，不在任何套件庫索引裡 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 5. 安裝本機套件檔與其他格式 |
| 本機資料庫 | 記錄「這台裝了哪些套件、什麼版本、每個檔案屬於誰」的檔案：🟠 純文字 `/var/lib/dpkg/status`，🔵 sqlite 格式的 **rpmdb** | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 校驗和 / 自我修復 | 每個區塊帶校驗和，讀到損毀時從鏡像或 RAID-Z 的另一份自動修復 | [11-備份與災難復原](11-備份與災難復原.md) · 6.3 ZFS（🟠） |
| 核心 lockdown | 核心的安全模式：`integrity` 禁止 root 修改執行中的核心（載未簽署模組、寫 `/dev/mem`、kexec 未簽核心），`confidentiality` 再禁止讀取核心記憶體 | [08-安全強化](08-安全強化.md) · 6.4 開機安全 |
| 核心參數 / `inst.ks=` | 開機時附加給 Linux 核心、由安裝程式讀取的參數；`inst.ks=` 告訴 Anaconda 去哪抓 Kickstart | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| 核心參數（cmdline） | GRUB 交給核心的一行文字（`quiet`、`console=`、`systemd.unit=`…），開機後見於 `/proc/cmdline` | [04-系統管理](04-系統管理.md) · 5. 核心與開機管理 |
| 核心套件 | 🟠 `linux-generic`（GA）與 `linux-generic-hwe-24.04`（HWE，見 §1）；🔵 `kernel` + `kernel-core` | [00-差異速查表](00-差異速查表.md) · 3. 系統設定與服務 |
| 核心模組 | 可動態載入的驅動與功能（`.ko` 檔） | [04-系統管理](04-系統管理.md) · 5. 核心與開機管理 |
| 核心模組（`.ko`） | 可在執行期載入 / 卸載的核心程式碼：驅動、檔案系統、網路功能 | [04-系統管理](04-系統管理.md) · 5.4 核心模組 |
| 核心（kernel）/ `vmlinuz` | Linux 核心本體，以套件形式安裝到 `/boot/vmlinuz-<版本>` | [04-系統管理](04-系統管理.md) · 5. 核心與開機管理 |
| 核心（vmlinuz）/ 核心模組 | 核心映像由發行版簽署；模組是可動態載入的驅動，樹內模組隨核心簽好 | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| 根因（root cause） | 移除後症狀不再出現、且能解釋所有觀察的那個原因 | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 框架決策（framing decision） | 決定整個設計空間的方向性選擇：自建或託管、實體或雲端、集中或分散、哪個發行版家族 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 條帶（stripe） | RAID 卡或 striped LV 把資料切成的固定大小片段，輪流寫到各成員碟 | [15-LVM進階](15-LVM進階.md) · 1.1 PE 大小與對齊 |
| 模型 | 路徑 profile | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 模板 unit（`@`）與 `%i` / `%n` / `%H` | 檔名帶 `@` 的 unit 可用 `name@instance` 實例化；`%i` 展開為實例名、`%n` 為完整 unit 名、`%H` 為主機名 | [12-監控與故障排除](12-監控與故障排除.md) · 1.4 簡易腳本監控 + 通知 |
| 模組簽章驗證 | Secure Boot 開啟（且 lockdown 生效）時，核心只載入「簽章能被核心信任的憑證驗證」的 `.ko` | [08-安全強化](08-安全強化.md) · 6.5 Secure Boot 下的自訂核心模組 |
| 模組自動載入（autoload） | 核心遇到未知協定 / 檔案系統時，透過 `modprobe` 自動載入對應模組 | [08-安全強化](08-安全強化.md) · 6.3 停用不需要的服務與協定 |
| 模組黑名單 | `/etc/modprobe.d/` 裡禁止自動載入某模組的設定 | [04-系統管理](04-系統管理.md) · 5. 核心與開機管理 |
| 模組（`im*` / `om*`） | rsyslog 的功能都是模組：`im` 開頭是輸入、`om` 開頭是輸出 | [07-日誌管理](07-日誌管理.md) · 3. rsyslog |
| 檔案儲存（file） | 提供現成檔案系統、多節點可同時掛載（NFS、GlusterFS、CephFS） | [10-高可用設計](10-高可用設計.md) · 5. 共享儲存與資料複製 |
| 檔案共享 vs 區塊共享 | NFS / SMB 共享檔案系統（伺服器管檔案）；iSCSI 共享區塊裝置（客戶端管檔案系統） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 9. 網路儲存 |
| 檔案描述子（fd） | 程式用來指稱已開啟檔案或資料流的整數編號 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 檔案描述子（file descriptor） | 程序開啟的每個檔案、socket、pipe 都佔一個整數編號 | [09-性能調校](09-性能調校.md) · 6. 應用層與檔案描述子 |
| 檔案描述符（fd） | 程序每開一個檔案 / socket 就佔用一個整數編號的描述符 | [04-系統管理](04-系統管理.md) · 2.4 資源限制（ulimit / limits.conf） |
| 檔案系統 | 決定資料如何在區塊裝置上組織的格式（ext4、XFS、Btrfs、ZFS；§2.3） | [01-系統安裝](01-系統安裝.md) · 2. 分割區規劃 |
| 檔案系統快照 | 在 LVM / ZFS / 虛擬機層把整個磁碟狀態凍結一份，與套件管理員無關 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2.1 交易歷史與回滾（🔵 Fedora 獨有優勢） |
| 檔案級備份 | 以檔案為單位備份（restic / borg / rsync），還原時要有一個能跑的系統來執行還原工具 | [11-備份與災難復原](11-備份與災難復原.md) · 8. 整機映像與裸機復原（Bare-metal Recovery） |
| 權威 DNS / TTL | 權威 DNS 是網域的來源伺服器；TTL 是快取多久後才重新查詢 | [10-高可用設計](10-高可用設計.md) · 7.3 網路層冗餘 |
| 殭屍 / 孤兒 | 殭屍：已結束但父程序沒回收退出狀態的程序（狀態 Z）；孤兒：父程序先死、被 PID 1 收養的程序 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| 殭屍（Z 狀態） | 已結束但父程序尚未 `wait()` 回收的程序，只剩 PID 表項 | [12-監控與故障排除](12-監控與故障排除.md) · 5. 記憶體與 CPU |
| 決策關卡（gate） | 階段之間的審查點，通過才進下一階段 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 沙盒（sandbox） | 限制應用只能存取被授權的檔案、裝置與網路的隔離機制：Snap 用 AppArmor + seccomp，Flatpak 用 bubblewrap（namespace 隔離）+ portals（透過桌面環境代為開檔、存取裝置） | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 4. 通用套件格式：Snap 與 Flatpak |
| 沙箱選項 | `ProtectSystem=`、`ProtectHome=`、`PrivateTmp=`、`NoNewPrivileges=` 等，用 namespace 與 seccomp 限制程式看得到、改得動的範圍 | [04-系統管理](04-系統管理.md) · 1.3 撰寫服務單元（範例：`scripts/examples/myapp.service`） |
| 注入（inject）/ 還原（solve） | 本章腳本把故障做出來 / 拆掉的兩個動作 | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 溝通模板 | 對內對外的通知範本（發生什麼、預計多久、下次更新時間） | [11-備份與災難復原](11-備份與災難復原.md) · 10.1 文件內容 |
| 演練 | 在維護時段刻意製造故障，驗證自動切換是否如預期 | [10-高可用設計](10-高可用設計.md) · 8. HA 測試（每季演練清單） |
| 演練情境 | 一種假想災難與它對應的還原路徑 | [11-備份與災難復原](11-備份與災難復原.md) · 10.2 演練情境（至少每半年） |
| 演練紀錄 | 每次演練的日期、情境、實測 RTO / RPO、發現的問題 | [11-備份與災難復原](11-備份與災難復原.md) · 10.1 文件內容 |
| 無主檔案 | 擁有者 UID / GID 在 `/etc/passwd`、`/etc/group` 裡已不存在的檔案 | [08-安全強化](08-安全強化.md) · 2.4 帳號清查 |
| 無人值守安裝 | 把安裝程式會問的每個問題預先寫在檔案裡，開機後全自動跑完的安裝方式 | [01-系統安裝](01-系統安裝.md) · 5. 無人值守安裝（Unattended Installation） |
| 無狀態 / 有狀態 | 無狀態 = 節點本身不保存使用者資料（session、上傳檔），任一台可隨時被替換；有狀態 = 節點上有唯一的資料 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| 無縫重載 | `systemctl reload` 時新程序接手監聽 socket，舊程序處理完既有連線才退出 | [10-高可用設計](10-高可用設計.md) · 3. 負載平衡：HAProxy |
| 版本字串 | 套件的完整版本識別：🟠 `上游版本-打包版本`（如 `1.24.0-2ubuntu7`），🔵 `版本-release.發行版`（如 `1.26.3-1.fc44`）；「打包版本 / release」是發行版自己改打包方式時遞增的號碼 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.6 只安裝特定版本 |
| 版本控制（versioning） | bucket 保留每個物件的舊版本 | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| 版本鎖定 | 阻止某套件被升級 | [00-差異速查表](00-差異速查表.md) · 2. 套件管理 |
| 物件儲存 | 以 HTTP API 存取、按用量計費、幾乎無限容量的雲端儲存（S3、GCS、Azure Blob、B2） | [11-備份與災難復原](11-備份與災難復原.md) · 9. 異地與雲端 |
| 物件儲存（object） | 透過 HTTP API 存取（S3 相容：MinIO、Ceph RGW、雲端 S3），沒有「掛載」這件事 | [10-高可用設計](10-高可用設計.md) · 5. 共享儲存與資料複製 |
| 物理備份 | 以一致的方式直接複製資料目錄，還原時原樣放回 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| 環境（environment） | dev / staging / prod 等隔離的部署層級 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 生命週期（lifecycle） | 系統從上線到退役的預計時間，以及期間的升級節奏 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 產生新政策 | `aa-genprof`（互動） | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 異地（off-site） | 放在另一個機房或雲端、與正本不共用電力與網路的副本 | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| 症狀（symptom） | 使用者或監控觀察到的現象（「連不上」「變慢」「磁碟滿」） | [17-故障排查情境演練](17-故障排查情境演練.md) · 17 - 故障排查情境演練 |
| 登入 shell（`nologin` / `false`） | `/etc/passwd` 第七欄；設成 `/usr/sbin/nologin` 或 `/bin/false` 的帳號不能互動登入 | [08-安全強化](08-安全強化.md) · 2.4 帳號清查 |
| 登入前橫幅（banner） | 認證**之前**顯示的文字：本機 console 讀 `/etc/issue`，SSH 由 sshd 的 `Banner` 選項送出（慣例指向 `/etc/issue.net`） | [02-初始設定](02-初始設定.md) · 9.2 登入橫幅與 MOTD |
| 發行版 CA | 🟠 Canonical CA / 🔵 Fedora Secure Boot CA，用來簽 GRUB、核心與樹內模組 | [14-UEFI進階](14-UEFI進階.md) · 4.1 金鑰層級 |
| 白箱 / 黑箱 | 白箱＝從系統內部讀指標（node_exporter）；黑箱＝從外部模擬使用者探測（連不連得到、回應多久） | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| 監聽位址 | 服務綁定的 IP：`0.0.0.0` / `::` 收所有介面，`127.0.0.1` 只收本機 | [12-監控與故障排除](12-監控與故障排除.md) · 6. 網路 |
| 相依（dependency） | 套件在 metadata 裡宣告「我要先有 X 才能跑」的清單 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 硬體 watchdog / softdog | 硬體 watchdog 是主機板（IPMI / BMC）上的計時器，沒被定期餵就強制重開機；`softdog` 是核心用軟體模擬的版本 | [10-高可用設計](10-高可用設計.md) · 7.2 systemd 層級自癒 |
| 硬體計數器（PMU） | CPU 內建的效能監控單元，能計數 cycles、instructions、cache-misses 等事件 | [09-性能調校](09-性能調校.md) · 1.1 進階：perf 與 eBPF |
| 磁碟佈局 | 分割表、LVM、RAID、LUKS 的結構與參數 | [11-備份與災難復原](11-備份與災難復原.md) · 8. 整機映像與裸機復原（Bare-metal Recovery） |
| 社群版 | 由社群維護、無付費支援的發行版或版本（Ubuntu 非 Pro、Fedora、Rocky / Alma） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 程序 / PID / PPID | 執行中的程式實例；PID 是其編號、PPID 是父程序編號 | [04-系統管理](04-系統管理.md) · 3. 程序管理 |
| 策略（DEFAULT / LEGACY / FUTURE / FIPS / BSI / NEXT） | 內建的幾個等級：LEGACY 相容舊裝置、DEFAULT 現行安全、FUTURE 為未來十年、FIPS 只留 FIPS 140 核准的演算法 | [08-安全強化](08-安全強化.md) · 3.1 🔵 Fedora crypto-policies（系統層級加密策略） |
| 管理員群組（`sudo` / `wheel`） | 被 sudoers 預設規則放行的群組：🟠 Debian 系用 `sudo`，🔵 Red Hat 系沿用 BSD 的 `wheel`（「big wheel」= 大人物） | [02-初始設定](02-初始設定.md) · 3.1 建立管理員帳號 |
| 管線（`\|`） | 把左邊程式的 stdout 直接接到右邊程式的 stdin | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 簽章式 | 靠「已知惡意樣本的特徵」比對 | [08-安全強化](08-安全強化.md) · 7. 檔案完整性與惡意軟體 |
| 簽章（signature） | 檔案系統、RAID、LVM 各自寫在分割區開頭的識別標記（magic bytes + UUID） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 2. 分割區 |
| 系統容器 | 跑完整 init（systemd）與多個服務的容器，對使用者像一台輕量 VM，但共用主機核心 | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 3.3 系統容器：LXD / Incus（🟠）與 systemd-nspawn / Toolbox（🔵） |
| 系統帳號 / 服務帳號 | UID 小於 1000、無密碼、shell 為 `nologin` 的帳號，專給 daemon 用 | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| 索引過期 | 本機 metadata（§1）比套件庫上的舊，導致「找不到套件」或裝到舊版 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 2. 日常操作對照 |
| 結構化欄位 / metadata | journald 為每筆訊息附加的 `鍵=值` 欄位，除了訊息本文還有來源程序、單元、開機 ID 等 | [07-日誌管理](07-日誌管理.md) · 2. journalctl（兩者完全相同） |
| 維運模型（operating model） | 誰維運、幾人、幾點可以動、變更要不要審、有沒有 on-call | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 網路分割 | 節點之間互相看不到但都還活著的狀態（用 iptables DROP 模擬） | [10-高可用設計](10-高可用設計.md) · 8. HA 測試（每季演練清單） |
| 網路埠控制 | 無 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 線上 / 離線升級 | 線上＝在正常執行的系統上替換套件，服務照跑；離線＝重開進特殊環境、沒有服務在跑時替換 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 9. 發行版大版本升級 |
| 編解碼器（codec）/ H.264 | 播放或編碼特定影音格式的程式庫；H.264 是最常見但有專利的影片格式 | [01-系統安裝](01-系統安裝.md) · 3.1 🟠 Ubuntu Desktop 安裝重點 |
| 群組 / GID | `/etc/group` 的一筆紀錄，讓多個帳號共享權限 | [04-系統管理](04-系統管理.md) · 2. 使用者、群組與權限 |
| 腦裂（split-brain） | 網路分割後兩邊各以為對方死了，同時當 primary 寫入，資料分叉 | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| 臨時單元（transient unit） | 不存在磁碟上、由指令即時建立、結束後自動消失的 unit | [04-系統管理](04-系統管理.md) · 1.5 臨時單元與其他實用指令 |
| 自建（self-hosted） | 在自己控制的 Linux 主機上安裝並維運整個系統 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 自我測試（short / long） | 硬碟韌體自己掃描碟面 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| 自簽憑證 | 用憑證自己的私鑰簽自己，沒有任何 CA 背書 | [08-安全強化](08-安全強化.md) · 9. TLS 憑證 |
| 萬用憑證（wildcard） | `*.example.com`，一張憑證涵蓋所有子網域 | [08-安全強化](08-安全強化.md) · 9.1 Let's Encrypt（certbot，兩者同名） |
| 虛擬化（KVM / VMware / Proxmox） | 一台實體機切成多台 VM，由 hypervisor 管理 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 被觸發的 service | 真正做事的單元，通常 `Type=oneshot` | [04-系統管理](04-系統管理.md) · 1.4 systemd timer（取代 cron） |
| 裝置 ID（IDTYPE：sys_wwid / sys_serial / mpath_uuid / loop_file…） | devices file 用來辨識裝置的「內容識別」而非路徑 | [15-LVM進階](15-LVM進階.md) · 8. Devices file 與過濾（🟠🔵 行為差異） |
| 裸機復原（bare-metal recovery） | 在一台全新、空白的硬體上從零把系統與資料還原回來 | [11-備份與災難復原](11-備份與災難復原.md) · 8. 整機映像與裸機復原（Bare-metal Recovery） |
| 複製（同步 / 非同步） | 同步 = 寫入要等副本確認才回報成功（不丟資料、延遲高）；非同步 = 先回報再送副本（快、可能丟最後幾筆） | [10-高可用設計](10-高可用設計.md) · 1. 架構原則 |
| 規則 / selector / action | 一條規則 = 篩選條件 + 動作；傳統寫法 `facility.priority 目的地`，新式（RainerScript）寫法 `if … then { action(…) }` | [07-日誌管理](07-日誌管理.md) · 3. rsyslog |
| 計畫性 / 非計畫性停機 | 事先公告的維護 vs 意外故障 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 託管（managed service） | 雲端或供應商代管基礎設施層（如 RDS、託管 Kubernetes），你只管應用與資料 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 設計決策紀錄（ADR） | 一頁式文件：需求 → 選項 → 決定 → 理由 → 對應章節 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 認證式複製（certification） | 交易 commit 前先把寫入集合廣播到所有節點做衝突檢查，多數認證通過才算成功 | [10-高可用設計](10-高可用設計.md) · 6.2 MariaDB Galera（多主同步複製） |
| 誤解 / 錯誤做法 | 為什麼錯 | [16-SELinux進階](16-SELinux進階.md) · 11. 常見誤解與正確做法 |
| 變數 | shell 內以 `NAME=value` 設定的名稱與值（等號兩側不可有空白） | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| 變數展開 | shell 把 `$VAR`、`${VAR}` 換成變數的值 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 資料 checksum | 每個資料區塊附校驗碼，讀取時比對以偵測靜默損毀（bit rot） | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.1 選擇 |
| 資料落地（data residency） | 法規或合約要求資料只能存放在特定國家 / 區域 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 資產清單 | 所有主機與服務的清單，含相依關係與負責人 | [11-備份與災難復原](11-備份與災難復原.md) · 10.1 文件內容 |
| 超額配置 | thin volume 虛擬大小總和大於 pool | [15-LVM進階](15-LVM進階.md) · 3. Thin Provisioning（已實測） |
| 超額配置（over-provisioning） | 所有 thin volume 虛擬大小總和大於 pool 實際大小 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 3.5 Thin Provisioning |
| 路徑等價 `semanage fcontext -e A B` | 宣告「B 底下的標籤規則與 A 相同」，一條規則覆蓋整棵樹 | [16-SELinux進階](16-SELinux進階.md) · 9. 檔案標籤的進階操作 |
| 路由網域（`~domain`） | 告訴 resolved「這個網域的查詢只送到這張網卡的 DNS」，不補尾碼 | [05-網路與防火牆](05-網路與防火牆.md) · 5. DNS：systemd-resolved（兩者共通） |
| 路由表（routing table） | 一組「目的地 → 下一跳／出口網卡」的對照；核心可有多張，`main` 是預設那張 | [05-網路與防火牆](05-網路與防火牆.md) · 9.2 Policy routing（多 WAN / 來源路由） |
| 跳板 grub.cfg | ESP 內只有幾行的 `grub.cfg`，內容是「去 `/boot` 找真正的 grub.cfg」 | [14-UEFI進階](14-UEFI進階.md) · 2. ESP 與開機檔案佈局 |
| 追蹤（traces） | 單一請求經過各服務的時間分解 | [12-監控與故障排除](12-監控與故障排除.md) · 1. 監控體系 |
| 退役套件（retired package） | 上游停止維護、Fedora 從新版套件庫移除的套件 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 🔵 Fedora：`dnf system-upgrade` |
| 透明壓縮 | 檔案系統在寫入時自動壓縮、讀取時自動解壓，應用程式無感 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 4.1 選擇 |
| 還原驗證 | 定期真的把備份還原出來比對，而不是只看備份任務回報成功 | [11-備份與災難復原](11-備份與災難復原.md) · 1.1 3-2-1-1-0 原則 |
| 邏輯備份（dump） | 把資料庫內容匯出成 SQL 語句或工具自訂格式 | [11-備份與災難復原](11-備份與災難復原.md) · 7. 資料庫備份 |
| 邏輯傾印（dump） | 把資料庫內容輸出成 SQL 或工具自訂格式的檔案 | [11-備份與災難復原](11-備份與災難復原.md) · 1.3 備份什麼 |
| 配額（quota） | 限制某使用者 / 群組 / 專案在一個檔案系統能用的區塊數與 inode 數 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 8. 磁碟配額（已實測 ext4 與 XFS） |
| 重建（resync / rebuild） | 換碟後把資料重新複製或計算到新碟 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 5. 軟體 RAID（mdadm，已實測 RAID1） |
| 重新導向 | 用 `>`、`>>`、`<`、`2>` 讓 shell 把某個 fd 改接到檔案 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 附錄 A - 手冊常用指令與 Shell 寫法說明 |
| 重複資料刪除（dedup） | 內容相同的區塊只存一份，其餘存指標 | [15-LVM進階](15-LVM進階.md) · 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生） |
| 量測 / 延伸（measure / extend） | 每層在執行下一層前，先算它的 hash 並延伸進對應 PCR | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| 量測基準 | 以時間（uptime）或以請求（成功比例）計算可用性 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 量測開機（measured boot） | 上述機制的總稱：不阻止任何東西執行，只留下不可竄改的紀錄 | [14-UEFI進階](14-UEFI進階.md) · 8. TPM 2.0 與量測開機 |
| 金鑰對（PrivateKey ／ PublicKey） | 每一端各產生一對：私鑰留在自己的 `[Interface]`，公鑰給對方寫進 `[Peer]` | [05-網路與防火牆](05-網路與防火牆.md) · 9.3 WireGuard（兩者核心內建） |
| 金鑰對（公鑰 / 私鑰） | 一對數學上配對的檔案：私鑰留在工作機、公鑰放到伺服器的 `~/.ssh/authorized_keys` | [02-初始設定](02-初始設定.md) · 4. SSH 伺服器 |
| 金鑰指紋（fingerprint） | 公鑰的 SHA256 雜湊；`LogLevel VERBOSE` 時每次登入都會記在日誌 | [08-安全強化](08-安全強化.md) · 3. SSH 強化（完整版） |
| 金鑰檔（keyfile） | 一段隨機位元組當密碼用 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 6. LUKS 磁碟加密（已實測 LUKS2） |
| 金鑰選項（key options） | 寫在 authorized_keys 公鑰前面、逗號分隔的限制條件，只對那一把金鑰生效 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| 金鑰類型 vs 簽章演算法 | 類型是數學結構（rsa、ed25519、ecdsa）；簽章演算法是登入時「怎麼用它簽」——RSA 金鑰可用 `ssh-rsa`（SHA-1）或 `rsa-sha2-256/512` 簽 | [02-初始設定](02-初始設定.md) · 4.2 金鑰登入與基本強化 |
| 錯誤預算（error budget） | (1 − SLO) × 期間，即允許的停機 / 失敗量 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 2.7 SLA 的計算概念 |
| 鎖定（lock-in）與退出策略 | 換供應商 / 換平台的難度，以及事先規劃好的搬遷路徑 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0. 設計前的決策條件與考量重點 |
| 鎖檔（lock） | 工具執行時建立的檔案（🟠 `/var/lib/dpkg/lock-frontend`），確保同一時間只有一個程序在改資料庫 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
| 鏡像（mirror） | 讓目標與來源保持一致的複本（rsync `--delete`、HA 的複製機制） | [11-備份與災難復原](11-備份與災難復原.md) · 1. 策略 |
| 鏡像（mirror）與 metalink | 鏡像是官方套件庫在各地的同步副本；metalink 是 🔵 Fedora 的鏡像清單服務，dnf 依地理位置自動挑鏡像 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.1 官方套件庫設定 |
| 開機參數 `enforcing=0` / `selinux=0` / `autorelabel=1` | 在 GRUB 核心命令列暫時 permissive / 真正關閉 / 觸發重標 | [16-SELinux進階](16-SELinux進階.md) · 10. 效能、稽核與運維 |
| 開機環境 | ESP、`/boot`、GRUB 設定與 initramfs | [11-備份與災難復原](11-備份與災難復原.md) · 8. 整機映像與裸機復原（Bare-metal Recovery） |
| 開機載入器（GRUB2 / systemd-boot） | shim 之後負責找核心與 initramfs、組核心參數、顯示選單的程式；GRUB2 功能全、systemd-boot 極簡只讀 ESP（§5） | [14-UEFI進階](14-UEFI進階.md) · 1. UEFI 與 BIOS 的差異 |
| 開源元件 | 原始碼公開、授權允許自由使用的軟體（PostgreSQL、HAProxy、restic） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 降版（downgrade） | 安裝比目前已裝更舊的版本 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 3.6 只安裝特定版本 |
| 降級攻擊 | 中間人干擾協商，讓雙方退回較弱的版本或套件 | [08-安全強化](08-安全強化.md) · 9.3 服務端 TLS 設定原則 |
| 除錯工具 | `aa-status`、`aa-logprof`、`journalctl -k -g apparmor` | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 集中式 agent | 把本機日誌送到集中伺服器的程式：`systemd-journal-remote` / `-upload`、Promtail、Vector、Filebeat | [07-日誌管理](07-日誌管理.md) · 1. 日誌架構 |
| 集中（consolidation） | 少數大機器承載多個服務 | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 0.2 框架決策：先定方向 |
| 雙引號 vs 單引號 | 雙引號內仍做變數展開與指令替換，但不做分詞與萬用字元展開；單引號內完全不展開 | [A-常用指令與語法說明](A-常用指令與語法說明.md) · 3. 指令替換與變數 |
| 雲端日誌服務 | CloudWatch Logs（AWS）、Cloud Logging（GCP）、Azure Monitor | [07-日誌管理](07-日誌管理.md) · 8. 集中式日誌方案比較 |
| 雲端映像（cloud image） | 已經裝好、可直接開機的磁碟映像（`.img` / `.qcow2`），內建 cloud-init 在第一次開機時讀取設定 | [01-系統安裝](01-系統安裝.md) · 1.1 選擇版本與映像 |
| 需求（requirement） | 系統必須滿足的條件，分功能性（做什麼）與非功能性（多快、多可靠、多安全） | [00b-設計階段的需求考量](00b-設計階段的需求考量.md) · 00b - 設計階段的需求考量 |
| 靜態 IP | 手動寫死的位址（`dhcp4: false` + `addresses:`），重開機不變 | [05-網路與防火牆](05-網路與防火牆.md) · 3.2 靜態 IP / DHCP |
| 非 LTS（中間版） | LTS 之間每 6 個月一版的過渡版本（如 24.10、25.04） | [00-差異速查表](00-差異速查表.md) · 1. 基本定位 |
| 非對稱路由 | 去程與回程走不同路徑 | [05-網路與防火牆](05-網路與防火牆.md) · 9.2 Policy routing（多 WAN / 來源路由） |
| 韌體（UEFI / BIOS） | 主機板上第一個執行的程式，負責找到並載入開機載入器 | [12-監控與故障排除](12-監控與故障排除.md) · 3. 開機故障 |
| 頁面快取（page cache） | 核心把最近讀寫的檔案內容留在記憶體 | [06-檔案系統與儲存](06-檔案系統與儲存.md) · 10. 磁碟健康與效能測試 |
| 項目 | 🟠 Ubuntu 24.04 | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 預設 ACL（default ACL） | 只能設在目錄上，新建的子檔案 / 子目錄會自動繼承成自己的 ACL | [04-系統管理](04-系統管理.md) · 2.3 ACL（細緻權限） |
| 預設 MAC | AppArmor（enforce） | [16-SELinux進階](16-SELinux進階.md) · 12. 本章差異總結 |
| 預設路由（default route） | 目的地不在任何已知網段時走的出口（`to: default, via: 閘道`） | [05-網路與防火牆](05-網路與防火牆.md) · 3.2 靜態 IP / DHCP |
| 顯示管理器（gdm / gdm3） | 登入畫面程式，登入後啟動桌面 session | [13-自動化與其他管理議題](13-自動化與其他管理議題.md) · 7. 桌面與周邊（Workstation 相關） |
| 髒頁（dirty pages） | page cache 裡已被修改、尚未寫回磁碟的頁 | [09-性能調校](09-性能調校.md) · 3. 記憶體 |
| 高階工具 `apt` / `apt-get` / `apt-cache` / `dnf` | 讀套件庫索引、算相依、下載後交給低階工具的前端；🟠 `apt` 是給人互動用的整合介面，`apt-get`（安裝／升級）與 `apt-cache`（查詢）是輸出格式穩定、給腳本用的原始工具；🔵 `dnf` 在 Fedora 41+ 即 **dnf5**，是 `yum` → `dnf4` → `dnf5` 的第三代重寫 | [03-套件與軟體安裝](03-套件與軟體安裝.md) · 1. 套件管理架構 |
