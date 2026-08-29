# 故障排查情境腳本（17 章）

每支腳本三個動作：`inject`（注入故障，只印「回報」等級的提示）、`status`（腳本認為的關鍵觀察值，供對照）、`solve`（還原）。⚠️ 會真的修改 sshd、fstab、resolv.conf、防火牆等設定，**只在實驗機執行**（`scripts/lab/README.md` 的 systemd 容器或測試 VM），並以 root 執行。多數情境依賴 `lab-systemd-test.sh` 部署的 `myapp.service`。

| 腳本 | 情境 | 依賴 |
|---|---|---|
| `01-disk-full.sh` | tmpfs 100%、已刪除但被開啟的檔案 | lsof |
| `02-port-conflict.sh` | myapp 埠被臨時服務佔用 | myapp.service |
| `03-nginx-bad-config.sh` | conf.d 語法錯誤，reload 不生效 | 會安裝 nginx |
| `04-ssh-lockout.sh` | AllowGroups 鎖掉所有人 | alice 帳號、sshd |
| `05-dns-broken.sh` | resolv.conf 指向不存在的 DNS | — |
| `06-bind-localhost.sh` | 服務只綁 127.0.0.1 + 防火牆未開 | myapp.service（BIND 環境變數） |
| `07-cron-not-running.sh` | 相對路徑與 `%` 陷阱（需等 1～2 分鐘） | cron / cronie |
| `08-timer-not-firing.sh` | OnCalendar 語法錯、Unit 名錯、未 enable | — |
| `09-oom-kill.sh` | MemoryMax=64M 觸發 cgroup OOM | cgroup v2 memory controller |
| `10-high-load.sh` | 4 個忙迴圈 transient unit | — |
| `11-repo-broken.sh` | 無法連線的第三方 repo | — |
| `12-thin-pool-full.sh` | thin pool 100%（loop 裝置） | lvm2、dm-thin-pool 模組 |
| `13-user-cannot-sudo.sh` | bob 不在 sudo / wheel | — |
| `14-journal-flood.sh` | 每秒數百筆日誌的 unit | — |
| `15-fstab-bad-entry.sh` | fstab 指向不存在 UUID 且無 nofail | — |

全部於 Ubuntu 24.04 與 Fedora 44 實驗容器實測（inject → status → solve）。`common.sh` 負責發行版偵測（服務名 ssh/sshd、cron/crond、ufw/firewalld）。
