#!/usr/bin/env bash
# 情境 06：本機 curl 正常，其他主機連不到 —— 服務只綁 127.0.0.1 / 防火牆未開
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    sed -i '/^BIND=/d' /etc/default/myapp; systemctl restart myapp
    if [ "$FAM" = debian ]; then ufw --force enable >/dev/null 2>&1; ufw delete allow 8085/tcp >/dev/null 2>&1; else firewall-cmd --permanent --remove-port=8085/tcp >/dev/null 2>&1; firewall-cmd --reload >/dev/null; fi
    echo "已注入：從其他主機（或用容器 IP $(ip -4 -o addr show scope global | awk '{print $4}' | cut -d/ -f1 | head -1)）連 8085 失敗。請從 ss -ltnp 開始排查。";;
  solve)
    grep -q '^BIND=' /etc/default/myapp || echo "BIND=0.0.0.0" >> /etc/default/myapp; systemctl restart myapp
    if [ "$FAM" = debian ]; then ufw allow 8085/tcp >/dev/null; else firewall-cmd --permanent --add-port=8085/tcp >/dev/null; firewall-cmd --reload >/dev/null; fi
    echo "已清除：$(ss -ltn | grep :8085)";;
  status) ss -ltnp | grep :8085; if [ "$FAM" = debian ]; then ufw status | grep 8085 || echo "ufw 未放行 8085"; else firewall-cmd --list-ports; fi;;
  *) usage;;
esac
