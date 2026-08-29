#!/usr/bin/env bash
# 情境 08：systemd timer 從沒觸發 —— 只 start 沒 enable、Unit= 指錯、OnCalendar 語法
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    cat > /etc/systemd/system/cleanup.service <<'U'
[Unit]
Description=Cleanup temp files
[Service]
Type=oneshot
ExecStart=/usr/bin/find /tmp -name '*.tmp' -mmin +60 -delete
U
    cat > /etc/systemd/system/cleanup.timer <<'U'
[Unit]
Description=Hourly cleanup
[Timer]
OnCalendar=*-*-* *:00/60
Unit=clean-up.service
U
    systemctl daemon-reload; systemctl start cleanup.timer 2>/dev/null
    echo "已注入：cleanup.timer 看起來 active 但 cleanup.service 永遠不會執行；重開機後 timer 也不見了。請從 systemctl list-timers --all 開始排查。";;
  solve) systemctl disable --now cleanup.timer 2>/dev/null; rm -f /etc/systemd/system/cleanup.{service,timer}; systemctl daemon-reload; echo "已清除。";;
  status) systemctl list-timers --all --no-pager | grep -i clean; systemctl status cleanup.timer --no-pager 2>&1 | head -5; systemd-analyze verify /etc/systemd/system/cleanup.timer;;
  *) usage;;
esac
