#!/usr/bin/env bash
# 情境 05：apt/dnf 與 curl 都失敗，但 ping 8.8.8.8 通 —— DNS 壞了
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    cp -a /etc/resolv.conf /run/resolv.conf.bak 2>/dev/null
    # 模擬被工具覆寫：直接改寫內容（實體機上若是 resolved 的 symlink，改寫會落到 stub-resolv.conf；容器內是 bind mount）
    printf 'nameserver 192.0.2.53\noptions timeout:1 attempts:1\n' > /etc/resolv.conf
    echo "已注入：名稱解析會逾時。請從 getent hosts deb.debian.org / ping 1.1.1.1 開始排查。";;
  solve) [ -f /run/resolv.conf.bak ] && cat /run/resolv.conf.bak > /etc/resolv.conf; echo "已清除：$(getent hosts fedoraproject.org | head -1 || echo 仍失敗)";;
  status) cat /etc/resolv.conf; timeout 3 getent hosts fedoraproject.org || echo "解析失敗";;
  *) usage;;
esac
