# 實驗環境（驗證用）

兩種方式，統一由這裡的腳本建立（主 README「建立實驗環境」有使用說明）：

| 腳本 | 環境 | 適用 |
|---|---|---|
| `setup-lab.sh up\|shell\|status\|test\|down` | 兩台 systemd privileged 容器 | 大多數章節；本手冊的驗證環境 |
| `setup-vm.sh up\|ssh\|console\|snapshot\|status\|down` | KVM + 官方雲端映像 + cloud-init 的兩台 UEFI VM | 01 安裝、12 開機救援、14 UEFI、16 SELinux enforcing；未於 WSL2 驗證主機實際啟動，已驗證語法、cloud-config schema 與映像 URL |

容器的手動建法如下。

本手冊所有指令與腳本皆在下列兩個 **啟用 systemd 的 privileged 容器** 中驗證（WSL2 主機，共用核心 6.18；LVM 快照 / dm-crypt / md-raid / btrfs 模組由主機 `modprobe` 載入）：

```bash
docker build -t lab-ubuntu -f Dockerfile.ubuntu .
docker build -t lab-fedora -f Dockerfile.fedora .
for n in ubuntu fedora; do
  docker run -d --name lab-$n --privileged --cgroupns=host \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw --tmpfs /run --tmpfs /run/lock lab-$n
done
docker exec lab-ubuntu systemctl is-system-running   # running
```

| 腳本 | 驗證內容 |
|---|---|
| `setup-lab.sh` | 建映像、啟動兩台容器（把手冊唯讀掛在 `/manual`、腳本複製到 `/root`）、載入儲存模組、部署 myapp；`shell` / `status` / `test` / `down` |
| `lab-systemd-test.sh` | 部署 `scripts/examples/myapp.service`、`backup.timer`，確認服務可用、timer 排程、`systemd-analyze security` |
| `lab-storage-test.sh` | loop 裝置上實測 parted、LVM 建立 / 線上擴充 / 快照合併還原、ext4 縮放、mdadm RAID1、LUKS2、Btrfs 子卷快照、ext4 與 XFS 配額 |
| `lab-lvm-advanced-test.sh` | striped、thin pool / 快照 / 擴充、pvmove、vgsplit / vgexport / vgmerge、RAID1 LV、metadata 備份還原、devices file（需主機先 `modprobe dm-raid dm-mirror dm-thin-pool`） |
| `scenarios/*.sh` | 17 章的 15 個故障注入情境（見 `scenarios/README.md`） |
| `lab-backup-test.sh` | `backup-restic.sh` 備份 → 保留 → 抽樣檢查 → 還原比對，以及 `restic-backup.timer` |

容器與實體機 / VM 的差異（腳本內已處理，實機不需要）：
- 無 udev：LVM 需 `/etc/lvm/lvmlocal.conf` 設 `udev_sync=0`、`udev_rules=0`；`/dev/md0` 需 `mknod`。
- Fedora 容器映像無 SELinux policy（`getenforce` 為 Disabled）、無 `crypto-policies-scripts`、無 host key（首次 `sshd -t` 前需 `ssh-keygen -A`）。
- 網路由 Docker 代管，防火牆規則可套用但不影響外部連線。
