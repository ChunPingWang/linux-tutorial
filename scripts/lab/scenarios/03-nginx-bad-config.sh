#!/usr/bin/env bash
# 情境 03：部署後 nginx reload 沒生效 / restart 失敗 —— 設定檔語法錯誤
. "$(dirname "$0")/common.sh"
case "$1" in
  inject)
    pkg nginx; systemctl enable --now nginx >/dev/null 2>&1
    mkdir -p /etc/nginx/conf.d
    printf 'server {\n    listen 8090;\n    location / { return 200 "ok\\n"; }\n    # 少了分號\n    add_header X-Env prod\n}\n' > /etc/nginx/conf.d/zz-newsite.conf
    systemctl reload nginx 2>/dev/null; echo "已注入：新站台 :8090 沒有生效。請從 curl -s localhost:8090 與 systemctl status nginx 開始排查。";;
  solve) rm -f /etc/nginx/conf.d/zz-newsite.conf; nginx -t >/dev/null 2>&1 && systemctl reload nginx; echo "已清除。";;
  status) nginx -t; curl -s -m2 localhost:8090 || echo "(8090 無回應)";;
  *) usage;;
esac
