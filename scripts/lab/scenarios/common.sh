# 共用：發行版偵測與工具
. /etc/os-release
case "$ID" in ubuntu|debian) FAM=debian; SSH_SVC=ssh; CRON_SVC=cron; FW=ufw ;; *) FAM=rhel; SSH_SVC=sshd; CRON_SVC=crond; FW=firewalld ;; esac
pkg() { if [ "$FAM" = debian ]; then DEBIAN_FRONTEND=noninteractive apt-get install -y -q "$@" >/dev/null 2>&1; else dnf install -y -q "$@" >/dev/null 2>&1; fi; }
usage() { echo "用法: $0 inject|solve|status"; exit 1; }
[ $# -ge 1 ] || usage
