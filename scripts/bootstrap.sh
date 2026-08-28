#!/usr/bin/env bash
# bootstrap.sh - Ubuntu / Fedora 通用初始化腳本
# 用法: sudo bash bootstrap.sh --user alice --pubkey "ssh-ed25519 AAAA..." [--timezone Asia/Taipei] [--no-firewall] [--no-upgrade]
set -euo pipefail

USER_NAME=""; PUBKEY=""; TZ_NAME="Asia/Taipei"; DO_FW=1; DO_UPGRADE=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)        USER_NAME="$2"; shift 2 ;;
    --pubkey)      PUBKEY="$2";    shift 2 ;;
    --timezone)    TZ_NAME="$2";   shift 2 ;;
    --no-firewall) DO_FW=0;        shift ;;
    --no-upgrade)  DO_UPGRADE=0;   shift ;;
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done
[[ $EUID -eq 0 ]] || { echo "請以 root 執行（sudo bash $0）" >&2; exit 1; }
[[ -n $USER_NAME ]] || { echo "--user 為必填" >&2; exit 1; }

. /etc/os-release
case "$ID" in
  ubuntu|debian)
    FAMILY=debian; SUDO_GROUP=sudo; SSH_SVC=ssh
    export DEBIAN_FRONTEND=noninteractive
    pkg_update()  { apt-get update -q; }
    pkg_upgrade() { apt-get full-upgrade -y -q; }
    pkg_install() { apt-get install -y -q "$@"; }
    BASE_PKGS=(vim curl wget git htop tmux dnsutils unzip tree jq rsync lsof openssh-server chrony)
    ;;
  fedora|rhel|rocky|almalinux|centos)
    FAMILY=rhel; SUDO_GROUP=wheel; SSH_SVC=sshd
    pkg_update()  { :; }
    pkg_upgrade() { dnf upgrade -y -q; }
    pkg_install() { dnf install -y -q "$@"; }
    BASE_PKGS=(vim-enhanced curl wget git htop tmux bind-utils unzip tree jq rsync lsof openssh-server chrony policycoreutils-python-utils)
    ;;
  *) echo "不支援的發行版: $ID" >&2; exit 1 ;;
esac
echo "==> 偵測到 $PRETTY_NAME（family=$FAMILY, sudo group=$SUDO_GROUP）"

echo "==> 更新套件與安裝基本工具"
pkg_update
[[ $DO_UPGRADE -eq 1 ]] && pkg_upgrade
pkg_install "${BASE_PKGS[@]}"

echo "==> 時區: $TZ_NAME"
timedatectl set-timezone "$TZ_NAME" 2>/dev/null || ln -sf "/usr/share/zoneinfo/$TZ_NAME" /etc/localtime

echo "==> 建立管理員 $USER_NAME"
if ! id "$USER_NAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USER_NAME"
fi
usermod -aG "$SUDO_GROUP" "$USER_NAME"
if [[ -n $PUBKEY ]]; then
  HOME_DIR=$(getent passwd "$USER_NAME" | cut -d: -f6)
  install -d -m 700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.ssh"
  grep -qxF "$PUBKEY" "$HOME_DIR/.ssh/authorized_keys" 2>/dev/null || echo "$PUBKEY" >> "$HOME_DIR/.ssh/authorized_keys"
  chmod 600 "$HOME_DIR/.ssh/authorized_keys"; chown "$USER_NAME:$USER_NAME" "$HOME_DIR/.ssh/authorized_keys"
  [[ $FAMILY == rhel ]] && command -v restorecon >/dev/null && restorecon -R "$HOME_DIR/.ssh" || true
fi

echo "==> SSH 強化"
install -d /etc/ssh/sshd_config.d
cat > /etc/ssh/sshd_config.d/10-hardening.conf <<EOF
PermitRootLogin no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
MaxAuthTries 3
X11Forwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
EOF
# 只有在提供公鑰時才關閉密碼登入，避免把自己鎖在外面
if [[ -n $PUBKEY ]]; then
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/10-hardening.conf
fi
install -d -m 755 /run/sshd 2>/dev/null || true   # sshd -t 需要此目錄（容器 / 首次啟動前可能不存在）
ssh-keygen -A >/dev/null 2>&1 || true                       # 若 host key 尚未產生（Fedora 首次啟動前）先產生
sshd -t
systemctl enable "$SSH_SVC" >/dev/null 2>&1 || true
systemctl restart "$SSH_SVC" 2>/dev/null || true

if [[ $DO_FW -eq 1 ]]; then
  echo "==> 防火牆"
  if [[ $FAMILY == debian ]]; then
    pkg_install ufw
    ufw default deny incoming >/dev/null
    ufw default allow outgoing >/dev/null
    ufw allow OpenSSH >/dev/null
    ufw --force enable
  else
    pkg_install firewalld
    systemctl enable --now firewalld
    firewall-cmd --permanent --add-service=ssh >/dev/null
    firewall-cmd --reload >/dev/null
  fi
fi

echo "==> 自動安全更新"
if [[ $FAMILY == debian ]]; then
  pkg_install unattended-upgrades
  cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
else
  pkg_install dnf5-plugin-automatic 2>/dev/null || pkg_install dnf-automatic
  # dnf5: /etc/dnf/automatic.conf 是 %ghost 檔，預設值在 /usr/share/dnf5/dnf5-plugins/automatic.conf
  if [[ ! -f /etc/dnf/automatic.conf ]]; then
    cp /usr/share/dnf5/dnf5-plugins/automatic.conf /etc/dnf/automatic.conf 2>/dev/null || touch /etc/dnf/automatic.conf
  fi
  sed -i 's/^apply_updates *=.*/apply_updates = yes/; s/^upgrade_type *=.*/upgrade_type = security/' /etc/dnf/automatic.conf
  grep -q '^apply_updates' /etc/dnf/automatic.conf || printf '[commands]\napply_updates = yes\nupgrade_type = security\n' >> /etc/dnf/automatic.conf
  systemctl enable --now dnf-automatic.timer
fi

echo "==> 時間同步（chrony）"
systemctl enable --now chronyd 2>/dev/null || systemctl enable --now chrony 2>/dev/null || true

echo "==> 完成。摘要："
echo "   主機名: $(hostname)   時區: $(timedatectl show -p Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null)"
echo "   管理員: $USER_NAME (groups: $(id -nG "$USER_NAME"))"
echo "   SSH   : $(systemctl is-active "$SSH_SVC" 2>/dev/null || echo n/a)   防火牆: $([[ $FAMILY == debian ]] && ufw status | head -1 || firewall-cmd --state 2>/dev/null)"
