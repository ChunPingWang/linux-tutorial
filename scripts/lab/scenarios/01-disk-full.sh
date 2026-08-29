#!/usr/bin/env bash
# 情境 01：磁碟空間告警 —— /var/log/myapp 100%，但 du 算不出誰佔了空間
. "$(dirname "$0")/common.sh"
D=/var/log/myapp
case "$1" in
  inject)
    mkdir -p $D; mountpoint -q $D || mount -t tmpfs -o size=64m tmpfs $D
    # 一個程序打開大檔後檔案被刪除：空間不會釋放
    setsid bash -c "exec 3>$D/debug.log; while :; do head -c 1M /dev/zero >&3 2>/dev/null || sleep 3600; done" >/dev/null 2>&1 < /dev/null &
    echo $! > /run/scenario01.pid; sleep 2; rm -f $D/debug.log
    echo "已注入：$D 掛載為 64M tmpfs，一個程序持續寫入已被刪除的檔案。請從 df -h $D 開始排查。";;
  solve)
    [ -f /run/scenario01.pid ] && kill -- -"$(cat /run/scenario01.pid)" 2>/dev/null   # 殺整個程序群組（含 sleep 子程序）
    lsof +L1 2>/dev/null | awk -v d=$D '$0 ~ d {print $2}' | sort -u | xargs -r kill 2>/dev/null   # 仍握著已刪檔案的程序
    sleep 1; umount $D 2>/dev/null; rm -f /run/scenario01.pid; echo "已清除。";;
  status) df -h $D; lsof +L1 2>/dev/null | grep $D | head -3;;
  *) usage;;
esac
