#!/usr/bin/env bash
# 情境 10：主機變慢、load average 飆高 —— 找出吃 CPU 的程序與其來源
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    for i in 1 2 3 4; do systemd-run --unit=batch-job-$i --quiet --nice=0 sh -c 'while :; do :; done'; done
    echo "已注入：4 個忙碌迴圈。請從 uptime / top / systemd-cgtop 開始排查，找出它們屬於哪個 unit。";;
  solve) for i in 1 2 3 4; do systemctl stop batch-job-$i 2>/dev/null; done; echo "已清除。";;
  status) uptime; systemctl list-units 'batch-job-*' --no-pager | head -6;;
  *) usage;;
esac
