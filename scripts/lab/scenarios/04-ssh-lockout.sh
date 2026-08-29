#!/usr/bin/env bash
# 情境 04：強化 sshd 後所有人都登不進來 —— AllowGroups 沒包含自己
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    id alice >/dev/null 2>&1 || useradd -m -s /bin/bash alice
    printf 'AllowGroups ops-team\n' > /etc/ssh/sshd_config.d/05-allowgroups.conf
    systemctl restart $SSH_SVC; echo "已注入：alice 用金鑰 ssh 到 127.0.0.1 會被拒絕。請從 ssh -v 與 journalctl -u $SSH_SVC 開始排查（提示：此 session 仍在，不要關）。";;
  solve) rm -f /etc/ssh/sshd_config.d/05-allowgroups.conf; sshd -t && systemctl reload $SSH_SVC; echo "已清除。";;
  status) sshd -T 2>/dev/null | grep -i allowgroups; journalctl -u $SSH_SVC -n 3 --no-pager -o cat;;
  *) usage;;
esac
