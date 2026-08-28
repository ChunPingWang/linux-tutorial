set -e
. /etc/os-release
if [ "$ID" = ubuntu ]; then apt-get install -y -q lvm2 xfsprogs btrfs-progs mdadm cryptsetup e2fsprogs quota parted gdisk smartmontools >/dev/null 2>&1; else dnf -y -q install lvm2 xfsprogs btrfs-progs mdadm cryptsetup e2fsprogs quota parted gdisk smartmontools >/dev/null 2>&1; fi
# 容器無 udev：關閉 LVM 的 udev 同步並手動建立裝置節點（實體機 / VM 不需要）
printf 'activation {\n\tudev_sync = 0\n\tudev_rules = 0\n\tverify_udev_operations = 0\n}\ndevices {\n\tobtain_device_list_from_udev = 0\n}\n' > /etc/lvm/lvmlocal.conf
mk() { vgmknodes 2>/dev/null; dmsetup mknodes 2>/dev/null; }
cleanup() { set +e; cd /root; [ -b /dev/md0 ] || mknod /dev/md0 b 9 0; umount /mnt/data /mnt/btr /mnt/q 2>/dev/null; cryptsetup close cryptdata 2>/dev/null; vgremove -f vgtest >/dev/null 2>&1; for m in /dev/md*; do mdadm --stop $m >/dev/null 2>&1; done; dmsetup remove_all 2>/dev/null; rm -rf /dev/vgtest; losetup -D 2>/dev/null; rm -f /root/d?.img; set -e; }
cleanup; trap cleanup EXIT; cd /root
for i in 1 2 3 4; do truncate -s 1200M d$i.img; done
L1=$(losetup -f --show d1.img); L2=$(losetup -f --show d2.img); L3=$(losetup -f --show d3.img); L4=$(losetup -f --show d4.img)
echo "loops: $L1 $L2 $L3 $L4"
echo "--- parted/sgdisk"; parted -s $L1 mklabel gpt mkpart primary 1MiB 100%; parted -s $L1 set 1 lvm on; partprobe $L1 2>/dev/null || true; sleep 1; lsblk $L1 -o NAME,SIZE,TYPE | tail -2
P1=${L1}p1; [ -b $P1 ] || P1=$L1
echo "--- LVM"; pvcreate -ff -y $P1 $L2 >/dev/null; vgcreate vgtest $P1 $L2 >/dev/null; lvcreate -y -L 400M -n lvdata vgtest >/dev/null; mk
mkfs.xfs -q -f /dev/vgtest/lvdata; mkdir -p /mnt/data; mount /dev/vgtest/lvdata /mnt/data; echo hello > /mnt/data/f.txt
lvextend -L +200M -r /dev/vgtest/lvdata 2>&1; mk; true 2>&1 | grep -iE "resized|successfully" | head -2
df -h /mnt/data | tail -1
echo "--- LVM snapshot"; lvcreate -y -s -L 100M -n lvdata_snap /dev/vgtest/lvdata >/dev/null; mk; lvs -o lv_name,lv_size,snap_percent vgtest | tail -2
echo world >> /mnt/data/f.txt; lvconvert --merge vgtest/lvdata_snap 2>&1 | tail -1
umount /mnt/data; lvchange -an vgtest/lvdata; lvchange -ay vgtest/lvdata; mk; mount /dev/vgtest/lvdata /mnt/data; echo "after merge: $(cat /mnt/data/f.txt | tr '\n' ' ')"; umount /mnt/data
echo "--- ext4 resize"; lvcreate -y -L 100M -n lvext vgtest >/dev/null; mk; mkfs.ext4 -q /dev/vgtest/lvext; lvextend -L +50M -r /dev/vgtest/lvext 2>&1 | grep -iE "resized|successfully" | head -1
e2fsck -fy /dev/vgtest/lvext >/dev/null && lvreduce -y -L 100M -r /dev/vgtest/lvext 2>&1 | grep -iE "resized|successfully" | head -1
echo "--- mdadm RAID1"; mdadm --create /dev/md0 --level=1 --raid-devices=2 --metadata=1.2 --run $L3 $L4 >/dev/null 2>&1; sleep 2; [ -b /dev/md0 ] || mknod /dev/md0 b 9 0; cat /proc/mdstat | grep -E "^md0|blocks"; mdadm --detail --scan
echo "--- LUKS"; echo -n "pass123" | cryptsetup luksFormat -q --type luks2 /dev/md0 -; echo -n "pass123" | cryptsetup open /dev/md0 cryptdata -; mk; mkfs.ext4 -q /dev/mapper/cryptdata; cryptsetup luksDump /dev/md0 | grep -E "Version|cipher" | head -2; cryptsetup close cryptdata
echo "--- btrfs"; lvcreate -y -L 150M -n lvbtr vgtest >/dev/null; mk; mkfs.btrfs -q -f /dev/vgtest/lvbtr; mkdir -p /mnt/btr; mount -o compress=zstd:1 /dev/vgtest/lvbtr /mnt/btr; btrfs subvolume create /mnt/btr/data >/dev/null; echo x > /mnt/btr/data/a; btrfs subvolume snapshot -r /mnt/btr/data /mnt/btr/data-snap >/dev/null; btrfs subvolume list /mnt/btr; btrfs filesystem usage /mnt/btr 2>/dev/null | head -2; umount /mnt/btr
echo "--- quota"; lvcreate -y -L 60M -n lvq vgtest >/dev/null; mk; mkfs.ext4 -q -O quota /dev/vgtest/lvq; mkdir -p /mnt/q; mount -o usrquota,grpquota /dev/vgtest/lvq /mnt/q; quotaon /mnt/q 2>/dev/null || true; setquota -u alice 10000 12000 0 0 /mnt/q && echo "setquota ok"; repquota -v /mnt/q | grep -E "alice" || true; umount /mnt/q
echo "--- xfs quota"; lvcreate -y -L 320M -n lvxq vgtest >/dev/null; mk; mkfs.xfs -q -f /dev/vgtest/lvxq; mount -o uquota /dev/vgtest/lvxq /mnt/q; xfs_quota -x -c 'limit -u bsoft=10m bhard=12m alice' /mnt/q; xfs_quota -x -c 'report -h' /mnt/q | grep alice; umount /mnt/q
echo "--- cleanup"; mdadm --stop /dev/md0 >/dev/null 2>&1; vgremove -f vgtest >/dev/null; pvremove -ff -y $P1 $L2 >/dev/null; mdadm --zero-superblock $L3 $L4 2>/dev/null; losetup -D; rm -f d?.img; echo STORAGE_DONE
