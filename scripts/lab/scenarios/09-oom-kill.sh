#!/usr/bin/env bash
# 情境 09：服務每隔幾秒就重啟，日誌只有 "Main process exited, code=killed, status=9/KILL" —— OOM
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    cat > /etc/systemd/system/memhog.service <<'U'
[Unit]
Description=Report worker
[Service]
ExecStart=/usr/bin/python3 -c "import time; buf=[]; [buf.append(b'x'*(8*1024*1024)) for _ in range(40)]; time.sleep(3600)"
MemoryMax=64M
MemorySwapMax=0
Restart=always
RestartSec=3
U
    systemctl daemon-reload; systemctl start memhog; echo "已注入：memhog.service 反覆被殺。請從 systemctl status memhog 與 journalctl -k 開始排查。";;
  solve) systemctl disable --now memhog 2>/dev/null; rm -f /etc/systemd/system/memhog.service; systemctl daemon-reload; echo "已清除。";;
  status) systemctl status memhog --no-pager 2>&1 | grep -E "Active|killed|oom|Result" ; systemctl show memhog -p NRestarts -p MemoryMax -p Result; journalctl -k -n 3 --no-pager -o cat | grep -i oom;;
  *) usage;;
esac
