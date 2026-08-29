# 驗證紀錄

驗證日期：2026-08-28。環境：Ubuntu 24.04.4 LTS（apt 2.8、kernel HWE 7.0 候選）與 Fedora Linux 44（dnf5 5.4.3、kernel-core 7.1.10），以 systemd privileged 容器執行（見 [`scripts/lab/README.md`](scripts/lab/README.md)）。主機 Fedora 44 WSL 僅做唯讀查詢。

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
| 17 | 15 個故障情境腳本 inject → status → solve（實測差異：OOM 時 systemd 255 顯示 `Result=signal`、259 顯示 `Result=oom-kill`；Fedora 容器無 `hostname` 指令；dnf5 需 `skip_if_unavailable=0` 才會因壞 repo 中止） | ✅ | ✅ |

## 驗證過程中修正的錯誤（原稿 → 實測）

- SELinux disabled 環境下 `audit2allow` / `audit2why` 必須加 `-p /etc/selinux/targeted/policy/policy.35`；`sepolicy generate -p DIR` 的目錄要先存在；`sepolicy booleans` 需 SELinux 啟用。

- Ubuntu 24.04 `mokutil` 0.6.0 無 `--set-sbat-policy` / `--list-sbat-revocations`（Fedora 0.7.2 有）。
- `vgcfgrestore` 需先 `vgchange -an`，且 VG 含 thin pool 時必須 `--force`；Ubuntu 24.04 lvm2 2.03.16 無 `lvmdevices` 指令、devices file 預設關閉。
- `vgsplit` 要求 PV 上的 LV 不可跨越到其他 PV（striped LV 會拒絕）。

- Kickstart `logvol --size` 與 `--percent` 不可並用。
- Ubuntu 24.04 的 `cloud-init schema` 無 `autoinstall` schema-type，改用 Subiquity JSON schema。
- Fedora dnf5 的 `/etc/dnf/automatic.conf` 為 %ghost 檔，需自 `/usr/share/dnf5/dnf5-plugins/automatic.conf` 複製。
- Fedora 首次啟動前無 SSH host key，`sshd -t` 需先 `ssh-keygen -A`；`sshd -t` 需 `/run/sshd`。
- Fedora 44 已無 `redis` 套件（改 `valkey`）；無 `wrk`、`iotop`、`netdata`、`crmsh`、`patroni`。
- Ubuntu 一般使用者 umask 為 002（Fedora 022）；Ubuntu mdadm 定期檢查為 `mdcheck_start.timer` 而非 cron。
- Ubuntu rsyslogd 以 `syslog` 使用者執行，自訂日誌目錄需 `chown syslog:adm`。
- Ubuntu 24.04 `ssg-debderived` 只含到 22.04 的 SCAP 內容。
- Fedora `node-exporter` 套件的 unit 名為 `prometheus-node-exporter.service`；`kdumpctl` 在 `kdump-utils`。
- Ubuntu 24.04 無 `qemu-kvm` 套件名（用 `qemu-system-x86`）、無 `fastfetch`；Quadlet 路徑兩者皆為 `/usr/libexec/podman/quadlet`。
- Keepalived `track_script` 路徑不存在會被停用（改用 `systemctl is-active`）；HAProxy `defaults` 內的 HTTP 選項不能用 `no option` 取消，改放到 frontend。
