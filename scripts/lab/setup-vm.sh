#!/usr/bin/env bash
# setup-vm.sh — 用 KVM / libvirt + 官方雲端映像 + cloud-init 建立兩台實驗 VM（lab-vm-ubuntu、lab-vm-fedora）
# 適用需要「真正開機流程」的章節：01 安裝與分割、12 開機救援、14 UEFI / Secure Boot、16 SELinux enforcing。
# 用法：
#   bash scripts/lab/setup-vm.sh up [ubuntu|fedora|all]   # 下載映像（首次）、建 seed ISO、virt-install（UEFI 開機）
#   bash scripts/lab/setup-vm.sh ssh ubuntu|fedora        # SSH 進入（使用者 admin，金鑰 ~/.ssh/id_ed25519）
#   bash scripts/lab/setup-vm.sh console ubuntu|fedora    # 序列主控台（練習開機救援 / GRUB 時用；Ctrl+] 離開）
#   bash scripts/lab/setup-vm.sh snapshot ubuntu|fedora <名稱>   # 建快照（做危險操作前）
#   bash scripts/lab/setup-vm.sh status | down
# 需求：Linux 主機（含 /dev/kvm）；🟠 apt install qemu-system-x86 libvirt-daemon-system virtinst cloud-image-utils
#                              🔵 dnf install @virtualization virt-install cloud-utils
#      使用者在 libvirt 群組；~/.ssh/id_ed25519.pub 存在（沒有就 ssh-keygen -t ed25519）
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(cd "$HERE/../.." && pwd)
WORK=${LAB_VM_DIR:-$HOME/lab-vm}; mkdir -p "$WORK"
PUB=${LAB_PUBKEY:-$(cat "$HOME/.ssh/id_ed25519.pub" 2>/dev/null || true)}
UBU_URL=https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
FED_URL=https://download.fedoraproject.org/pub/fedora/linux/releases/44/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2
declare -A URL=([ubuntu]=$UBU_URL [fedora]=$FED_URL)
declare -A OSV=([ubuntu]=ubuntu24.04 [fedora]=fedora-rawhide)

need() { command -v "$1" >/dev/null 2>&1 || { echo "缺少 $1；見腳本開頭的安裝需求" >&2; exit 1; }; }

mk_seed() {   # $1 = name
  local n=$1
  cat > "$WORK/$n-user-data" <<CI
#cloud-config
hostname: lab-vm-$n
manage_etc_hosts: true
timezone: Asia/Taipei
users:
  - name: admin
    groups: [sudo, wheel]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys: ["$PUB"]
package_update: true
packages: [vim, htop, curl, git, tmux]
runcmd:
  - [sh, -c, "mkdir -p /root/manual"]
CI
  printf 'instance-id: lab-vm-%s-%s\nlocal-hostname: lab-vm-%s\n' "$n" "$(date +%s)" "$n" > "$WORK/$n-meta-data"
  cloud-localds "$WORK/$n-seed.iso" "$WORK/$n-user-data" "$WORK/$n-meta-data"
}

up_one() {
  local n=$1 base="$WORK/$n-base.img" disk="$WORK/lab-vm-$n.qcow2"
  [[ -n $PUB ]] || { echo "找不到 SSH 公鑰：ssh-keygen -t ed25519 或設 LAB_PUBKEY" >&2; exit 1; }
  [[ -f $base ]] || { echo "==> 下載 $n 雲端映像"; curl -L --progress-bar -o "$base" "${URL[$n]}"; }
  virsh --connect qemu:///system dominfo lab-vm-$n >/dev/null 2>&1 && { echo "lab-vm-$n 已存在（先 down）"; return; }
  qemu-img create -q -f qcow2 -F qcow2 -b "$base" "$disk" 40G
  mk_seed "$n"
  echo "==> virt-install lab-vm-$n（UEFI，序列主控台）"
  virt-install --connect qemu:///system --name lab-vm-$n --memory 4096 --vcpus 2 \
    --boot uefi --disk "$disk" --disk "$WORK/$n-seed.iso,device=cdrom" \
    --os-variant "${OSV[$n]}" --import --network network=default \
    --graphics none --console pty,target_type=serial --noautoconsole >/dev/null
  echo "   建立完成；cloud-init 約 1～2 分鐘後可 SSH：bash $0 ssh $n"
}

ip_of() { virsh --connect qemu:///system domifaddr "lab-vm-$1" 2>/dev/null | awk '/ipv4/{print $4}' | cut -d/ -f1 | head -1; }

case "${1:-}" in
  up) need virt-install; need cloud-localds; need qemu-img; need virsh
      for n in $([[ ${2:-all} == all ]] && echo ubuntu fedora || echo "$2"); do up_one "$n"; done ;;
  ssh) ip=$(ip_of "$2"); [[ -n $ip ]] || { echo "尚未取得 IP（cloud-init 未完成？）"; exit 1; }
       exec ssh -o StrictHostKeyChecking=accept-new admin@"$ip" ;;
  console) exec virsh --connect qemu:///system console "lab-vm-$2" ;;
  snapshot) virsh --connect qemu:///system snapshot-create-as "lab-vm-$2" "${3:-snap-$(date +%F-%H%M)}" --atomic && echo "快照完成；還原：virsh snapshot-revert lab-vm-$2 <名稱>" ;;
  status) for n in ubuntu fedora; do printf "lab-vm-%-7s %s  ip=%s\n" "$n" "$(virsh --connect qemu:///system domstate lab-vm-$n 2>/dev/null || echo 不存在)" "$(ip_of $n)"; done ;;
  down) for n in ubuntu fedora; do virsh --connect qemu:///system destroy lab-vm-$n >/dev/null 2>&1 || true; virsh --connect qemu:///system undefine lab-vm-$n --nvram --remove-all-storage >/dev/null 2>&1 && echo "removed lab-vm-$n" || true; done ;;
  *) sed -n '2,13p' "$0"; exit 1 ;;
esac
