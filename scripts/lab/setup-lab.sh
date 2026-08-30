#!/usr/bin/env bash
# setup-lab.sh — 一鍵建立 / 進入 / 檢查 / 移除本手冊的實驗環境（兩台啟用 systemd 的 privileged 容器）
# 用法：
#   bash scripts/lab/setup-lab.sh up            # 建映像、啟動 lab-ubuntu 與 lab-fedora、部署範例服務 myapp、載入儲存測試需要的核心模組
#   bash scripts/lab/setup-lab.sh shell ubuntu  # 進入 lab-ubuntu（或 fedora）
#   bash scripts/lab/setup-lab.sh status        # 檢查兩台是否 running、systemd 是否正常、myapp 是否在跑
#   bash scripts/lab/setup-lab.sh test          # 跑三支自動化測試（systemd / storage / backup），約 5～10 分鐘
#   bash scripts/lab/setup-lab.sh down          # 停止並移除容器（映像保留）
# 需求：Docker（或 Podman，設 CONTAINER_CLI=podman）；Linux、WSL2、macOS（Docker Desktop）皆可。
set -euo pipefail
CLI=${CONTAINER_CLI:-docker}
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
LABS=(ubuntu fedora)

need() { command -v "$1" >/dev/null 2>&1 || { echo "缺少 $1；請先安裝（Docker Desktop / docker-ce / podman）" >&2; exit 1; }; }

up() {
  need "$CLI"
  echo "==> 建置映像（第一次約 2～5 分鐘）"
  for n in "${LABS[@]}"; do $CLI build -q -t lab-$n -f "$HERE/Dockerfile.$n" "$HERE" >/dev/null; done
  echo "==> 啟動容器"
  for n in "${LABS[@]}"; do
    $CLI rm -f lab-$n >/dev/null 2>&1 || true
    $CLI run -d --name lab-$n --privileged --cgroupns=host \
      -v /sys/fs/cgroup:/sys/fs/cgroup:rw --tmpfs /run --tmpfs /run/lock \
      -v "$ROOT":/manual:ro lab-$n >/dev/null
  done
  echo "==> 等待 systemd 就緒"
  for n in "${LABS[@]}"; do
    for i in $(seq 1 30); do
      st=$($CLI exec lab-$n systemctl is-system-running 2>/dev/null || true)
      [[ $st == running || $st == degraded ]] && break; sleep 1
    done
    echo "   lab-$n: $st"
  done
  echo "==> 載入儲存測試需要的核心模組（LVM 快照 / RAID / LUKS / Btrfs / thin；需要 sudo，失敗不影響其他章節）"
  sudo -n modprobe dm-snapshot dm-thin-pool dm-raid dm-mirror dm-crypt raid1 btrfs 2>/dev/null \
    || sudo modprobe dm-snapshot dm-thin-pool dm-raid dm-mirror dm-crypt raid1 btrfs 2>/dev/null \
    || echo "   （略過：無法載入模組，06 / 15 章的儲存測試可能受限）"
  echo "==> 部署範例服務 myapp（04 章）與情境腳本所需環境"
  for n in "${LABS[@]}"; do
    $CLI exec lab-$n bash -c 'mkdir -p /root/ex /root/scen && cp -r /manual/scripts/examples/. /root/ex/ && cp -r /manual/scripts/lab/scenarios/. /root/scen/ && cp /manual/scripts/lab/*.sh /root/ && bash /root/lab-systemd-test.sh >/dev/null 2>&1 && echo "   lab-'$n': myapp $(systemctl is-active myapp)"' || echo "   lab-$n: 部署 myapp 失敗（可稍後手動執行 bash /root/lab-systemd-test.sh）"
  done
  cat <<MSG

完成。接下來：
  bash $0 shell ubuntu        # 或 fedora；進去後手冊在 /manual（唯讀），腳本已複製到 /root
  在容器內：bash /root/scen/01-disk-full.sh inject     # 17 章情境練習
            bash /root/lab-storage-test.sh               # 06 章儲存測試
  bash $0 status ; bash $0 down
MSG
}

shell() { need "$CLI"; local n=${1:-ubuntu}; exec $CLI exec -it -w /root lab-$n bash; }

status() {
  need "$CLI"
  for n in "${LABS[@]}"; do
    if $CLI ps --format '{{.Names}}' | grep -qx lab-$n; then
      printf "lab-%-7s running  systemd=%s  myapp=%s  %s\n" "$n" \
        "$($CLI exec lab-$n systemctl is-system-running 2>/dev/null || echo ?)" \
        "$($CLI exec lab-$n systemctl is-active myapp 2>/dev/null || echo ?)" \
        "$($CLI exec lab-$n grep PRETTY /etc/os-release 2>/dev/null | cut -d= -f2)"
    else printf "lab-%-7s not running（bash %s up）\n" "$n" "$0"; fi
  done
}

test_all() {
  need "$CLI"
  for n in "${LABS[@]}"; do
    echo "######## lab-$n"
    for t in lab-systemd-test.sh lab-storage-test.sh lab-backup-test.sh; do
      printf "  %-24s " "$t"
      if $CLI exec lab-$n bash /root/$t >/tmp/lab-$n-$t.log 2>&1; then echo "OK"; else echo "FAIL（見 /tmp/lab-$n-$t.log）"; fi
    done
  done
}

down() { need "$CLI"; for n in "${LABS[@]}"; do $CLI rm -f lab-$n >/dev/null 2>&1 && echo "removed lab-$n" || true; done; }

case "${1:-}" in
  up) up ;; shell) shell "${2:-ubuntu}" ;; status) status ;; test) test_all ;; down) down ;;
  *) sed -n '2,10p' "$0"; exit 1 ;;
esac
