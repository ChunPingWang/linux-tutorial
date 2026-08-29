#!/usr/bin/env bash
# 情境 15：加了一顆新碟到 fstab，下次重開機會卡在 emergency mode —— 開機前就抓出來
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    cp -a /etc/fstab /run/fstab.bak 2>/dev/null || touch /run/fstab.bak
    printf 'UUID=0badc0de-0000-4000-8000-000000000000  /data  ext4  defaults  0 2\n' >> /etc/fstab
    echo "已注入：/etc/fstab 多了一行指向不存在裝置且沒有 nofail 的項目。請在重開機前用 findmnt --verify / mount -a 排查。";;
  solve) cp -a /run/fstab.bak /etc/fstab; echo "已清除。";;
  status) tail -2 /etc/fstab; findmnt --verify 2>&1 | tail -3;;
  *) usage;;
esac
