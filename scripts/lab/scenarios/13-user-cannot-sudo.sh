#!/usr/bin/env bash
# 情境 13：新同事說「sudo 說我不在 sudoers」—— 群組與 sudoers 排查
. "$(dirname "$0")/common.sh"
case "$1" in
  inject) id bob >/dev/null 2>&1 || useradd -m -s /bin/bash bob; gpasswd -d bob sudo >/dev/null 2>&1; gpasswd -d bob wheel >/dev/null 2>&1; echo "已注入：su - bob 後 sudo -l 會失敗。請從 id bob / sudo -l -U bob 開始排查。";;
  solve) userdel -r bob 2>/dev/null; echo "已清除。";;
  status) id bob; sudo -l -U bob 2>&1 | tail -1;;
  *) usage;;
esac
