#!/usr/bin/env bash
# 情境 07：cron 排程「沒有跑」—— PATH 與 % 的陷阱
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    pkg $([ "$FAM" = debian ] && echo cron || echo cronie); systemctl enable --now $CRON_SVC >/dev/null 2>&1
    mkdir -p /opt/tools; printf '#!/bin/sh\necho "report $(date)" >> /var/log/report.log\n' > /opt/tools/report.sh; chmod +x /opt/tools/report.sh
    printf '* * * * * report.sh >> /var/log/report-cron.log 2>&1\n* * * * * /opt/tools/report.sh --date=$(date +%%F) >> /var/log/report-cron.log 2>&1\n' | crontab -
    echo "已注入：兩條每分鐘的 crontab 都不會產生 /var/log/report.log。等 1～2 分鐘後從 journalctl -u $CRON_SVC 與 /var/log/report-cron.log 開始排查。";;
  solve) crontab -r 2>/dev/null; rm -f /var/log/report.log /var/log/report-cron.log; echo "已清除。";;
  status) crontab -l; journalctl -u $CRON_SVC -n 4 --no-pager -o cat | grep -v pam_unix; echo "--- /var/log/report-cron.log:"; cat /var/log/report-cron.log 2>&1 | tail -3; ls -l /var/log/report.log 2>&1;;
  *) usage;;
esac
