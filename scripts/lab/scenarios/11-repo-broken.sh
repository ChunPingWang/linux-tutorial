#!/usr/bin/env bash
# 情境 11：apt update / dnf 全部失敗 —— 一個壞掉的第三方套件庫拖垮所有操作
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    if [ "$FAM" = debian ]; then
      printf 'Types: deb\nURIs: https://repo.invalid.example/ubuntu\nSuites: noble\nComponents: main\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n' > /etc/apt/sources.list.d/vendor-tool.sources
      echo "已注入：apt update 會卡很久並出現 W: Failed to fetch。請從 apt update 的訊息開始排查。"
    else
      printf '[vendor-tool]\nname=Vendor Tool\nbaseurl=https://repo.invalid.example/fedora/$releasever/\nenabled=1\ngpgcheck=1\nskip_if_unavailable=0\n' > /etc/yum.repos.d/vendor-tool.repo
      echo "已注入：dnf install 任何套件都會失敗。請從 dnf repolist / 錯誤訊息開始排查。"
    fi;;
  solve) rm -f /etc/apt/sources.list.d/vendor-tool.sources /etc/yum.repos.d/vendor-tool.repo; echo "已清除。";;
  status) if [ "$FAM" = debian ]; then apt-get update 2>&1 | grep -E "^(E|W):" | head -3; else dnf repolist 2>&1 | grep -iE "vendor|error" | head -3; dnf install --assumeno hello 2>&1 | grep -iE "error|fail|vendor" | head -3; fi;;
  *) usage;;
esac
