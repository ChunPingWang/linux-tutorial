#!/usr/bin/env bash
# 情境 02：myapp.service 重啟後失敗 —— 埠被另一個程序佔用
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    systemctl stop myapp 2>/dev/null
    systemd-run --unit=legacy-listener --quiet python3 -c 'import socket,time; s=socket.socket(); s.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1); s.bind(("127.0.0.1",8085)); s.listen(); time.sleep(86400)'
    sleep 1; systemctl start myapp 2>/dev/null; echo "已注入：請從 systemctl status myapp 開始排查（myapp 應為 failed 或反覆重啟）。";;
  solve) systemctl stop legacy-listener 2>/dev/null; systemctl reset-failed myapp 2>/dev/null; systemctl restart myapp; echo "已清除：myapp $(systemctl is-active myapp)";;
  status) systemctl is-active myapp legacy-listener; ss -ltnp | grep :8085;;
  *) usage;;
esac
