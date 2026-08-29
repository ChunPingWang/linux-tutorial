#!/usr/bin/env bash
# 情境 12：資料目錄寫入報 I/O error，df 卻還有空間 —— LVM thin pool 滿了
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    pkg lvm2; printf 'activation {\n\tudev_sync = 0\n\tudev_rules = 0\n\tverify_udev_operations = 0\n}\ndevices {\n\tobtain_device_list_from_udev = 0\n}\n' > /etc/lvm/lvmlocal.conf
    truncate -s 600M /root/thin.img; L=$(losetup -f --show /root/thin.img); echo $L > /run/scenario12.loop
    vgcreate vgapp $L >/dev/null; lvcreate -y -L 120M -T vgapp/tpool >/dev/null 2>&1; lvcreate -y -V 1G -T vgapp/tpool -n data >/dev/null 2>&1
    mkfs.ext4 -q /dev/vgapp/data; mkdir -p /srv/appdata; mount /dev/vgapp/data /srv/appdata
    dd if=/dev/urandom of=/srv/appdata/blob1 bs=1M count=150 status=none 2>/dev/null; sync
    echo "已注入：/srv/appdata 寫入會失敗（Input/output error）而 df 顯示還有 800M+。請從 dmesg / lvs -a 開始排查。";;
  solve) umount /srv/appdata 2>/dev/null; vgremove -f vgapp >/dev/null 2>&1; dmsetup remove_all 2>/dev/null; rm -rf /dev/vgapp; [ -f /run/scenario12.loop ] && losetup -d "$(cat /run/scenario12.loop)" 2>/dev/null; rm -f /root/thin.img /run/scenario12.loop; echo "已清除。";;
  status) df -h /srv/appdata 2>/dev/null; lvs -a -o lv_name,lv_size,data_percent,metadata_percent vgapp 2>/dev/null; echo test > /srv/appdata/probe 2>&1 && echo "寫入成功" ;;
  *) usage;;
esac
