# SELinux 範例（16 章）

| 檔案 | 說明 |
|---|---|
| `sample-avc.log` | 兩則範例 AVC（nginx 連 8080、讀家目錄檔案），用於 `audit2allow -p policy.35 -i sample-avc.log` 與 `audit2why` |
| `nginxlocal.te` | `audit2allow -M` 產生的草稿——示範「兩條都應改用 boolean，不該裝」 |
| `local_nginx.cil` | CIL 單行規則，`semodule -i local_nginx.cil` 直接安裝 |
| `myapp_port.te` | 用 refpolicy 巨集宣告自訂 port type，`make -f /usr/share/selinux/devel/Makefile myapp_port.pp` |
| `myapp.te` / `myapp.fc` | `sepolicy generate --init /usr/local/bin/myapp -n myapp` 產生的 confined domain 骨架（預設 permissive） |
