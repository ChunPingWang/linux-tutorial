#!/usr/bin/env bash
# 情境 14：/var/log/journal 突然變大、journalctl 變慢 —— 找出狂寫日誌的程式
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    systemd-run --unit=chatty-agent --quiet sh -c 'while :; do logger -t chatty-agent "heartbeat ok seq=$RANDOM payload=$(head -c 200 /dev/zero | tr "\0" x)"; done'
    sleep 5; echo "已注入：chatty-agent 每秒寫入大量日誌。請從 journalctl --disk-usage 與「找出最吵的 unit」開始排查。";;
  solve) systemctl stop chatty-agent 2>/dev/null; journalctl --vacuum-size=50M >/dev/null 2>&1; echo "已清除。";;
  status) journalctl --disk-usage; journalctl --since -1min -o json --output-fields=SYSLOG_IDENTIFIER 2>/dev/null | grep -o '"SYSLOG_IDENTIFIER":"[^"]*"' | sort | uniq -c | sort -rn | head -3;;
  *) usage;;
esac
