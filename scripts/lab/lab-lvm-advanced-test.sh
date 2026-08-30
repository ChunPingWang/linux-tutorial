set -e
printf 'activation {\n\tudev_sync = 0\n\tudev_rules = 0\n\tverify_udev_operations = 0\n}\ndevices {\n\tobtain_device_list_from_udev = 0\n\tuse_devicesfile = 0\n}\n' > /etc/lvm/lvmlocal.conf
cleanup() { set +e; cd /root; umount /mnt/t1 /mnt/s1 /mnt/c1 2>/dev/null; vgremove -f vgadv vgnew vgraid >/dev/null 2>&1; dmsetup remove_all 2>/dev/null; rm -rf /dev/vgadv /dev/vgnew /dev/vgraid; losetup -D 2>/dev/null; rm -f /root/a?.img; set -e; }
cleanup; trap cleanup EXIT; cd /root
for i in 1 2 3 4 5; do truncate -s 1G a$i.img; done
L=(); for i in 1 2 3 4 5; do L+=("$(losetup -f --show a$i.img)"); done; echo "loops: ${L[*]}"
echo "--- vg with tags / PE size"; vgcreate -s 8M vgadv "${L[0]}" "${L[1]}" >/dev/null; vgchange --addtag prod vgadv >/dev/null; vgs -o vg_name,vg_size,vg_free,vg_extent_size,vg_tags vgadv
echo "--- striped LV"; lvcreate -y -L 200M -i 2 -I 64 -n lvstripe vgadv >/dev/null; lvs -o lv_name,stripes,stripe_size,segtype vgadv | grep lvstripe
echo "--- thin pool + thin volumes + thin snapshot"; lvcreate -y -L 400M -T vgadv/tpool >/dev/null; lvcreate -y -V 2G -T vgadv/tpool -n thin1 >/dev/null; mkfs.ext4 -q /dev/vgadv/thin1; mkdir -p /mnt/t1; mount /dev/vgadv/thin1 /mnt/t1; dd if=/dev/urandom of=/mnt/t1/f bs=1M count=50 status=none; lvcreate -y -s -n thin1_snap vgadv/thin1 >/dev/null; lvs -a -o lv_name,lv_size,data_percent,pool_lv,origin vgadv | grep -E "tpool|thin1"
echo "--- extend thin pool + metadata"; lvextend -L +100M vgadv/tpool 2>&1 | grep -i success; lvextend --poolmetadatasize +8M vgadv/tpool 2>&1 | grep -i success; umount /mnt/t1
echo "--- pvmove"; pvcreate -y "${L[2]}" >/dev/null; vgextend vgadv "${L[2]}" >/dev/null; if dmsetup targets | grep -qE "^(mirror|raid) "; then pvmove "${L[0]}" >/dev/null 2>&1; pvs -o pv_name,pv_used,pv_free "${L[0]}" "${L[2]}"; else echo "SKIP pvmove (no dm-mirror/dm-raid in this kernel)"; lvremove -y vgadv/lvstripe >/dev/null; lvremove -y vgadv/thin1_snap vgadv/thin1 vgadv/tpool >/dev/null; fi
echo "--- vgreduce / vgsplit / vgexport / vgimport / vgmerge"; vgsplit vgadv vgnew "${L[0]}" 2>&1 | tail -1; vgs -o vg_name,pv_count vgadv vgnew
vgexport vgnew 2>&1 | tail -1; vgs -o vg_name,vg_exported vgnew; vgimport vgnew 2>&1 | tail -1; vgmerge vgadv vgnew 2>&1 | tail -1; vgs -o vg_name,pv_count vgadv
echo "--- RAID1 LV (dm-raid)"; vgcreate vgraid "${L[3]}" "${L[4]}" >/dev/null; if dmsetup targets | grep -q "^raid "; then lvcreate -y --type raid1 -m 1 -L 200M -n lvmirror vgraid >/dev/null && lvs -a -o lv_name,segtype,sync_percent,copy_percent vgraid | head -4; else echo "SKIP raid1 LV (no dm-raid)"; fi
echo "--- cache (dm-cache, writethrough)"; if dmsetup targets | grep -q "^cache "; then lvcreate -y -L 300M -n lvslow vgadv >/dev/null; lvcreate -y -L 100M -n lvfast vgadv >/dev/null; lvconvert -y --type cache --cachevol lvfast --cachemode writethrough vgadv/lvslow 2>&1 | tail -1; lvs -a -o lv_name,segtype,cache_mode,data_percent vgadv | grep -E "lvslow"; lvconvert -y --uncache vgadv/lvslow 2>&1 | tail -1; else echo "SKIP cache (no dm-cache)"; fi
echo "--- metadata backup/restore"; vgs vgadv >/dev/null; vgcfgbackup -f /root/vgadv.cfg vgadv >/dev/null; ls /etc/lvm/archive | head -2; lvcreate -y -L 50M -n lvtmp vgadv >/dev/null; lvremove -y vgadv/lvtmp >/dev/null; vgcfgrestore -f /root/vgadv.cfg vgadv 2>&1 | tail -1; lvs -o lv_name vgadv | grep -c lvtmp || true
echo "--- filters / devices"; lvmconfig --type default devices/filter devices/use_devicesfile 2>/dev/null; lvmdevices 2>&1 | head -2; pvs --noheadings -o pv_name,pv_uuid | head -2
echo "--- lvs -a full"; lvs -a -o lv_name,segtype,lv_size,attr vgadv vgraid
echo LVM_ADV_DONE
