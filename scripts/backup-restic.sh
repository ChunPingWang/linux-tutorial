#!/usr/bin/env bash
# backup-restic.sh - 以 restic 備份到本機 / SFTP / S3，含 LVM 快照（可選）與保留策略
# 用法：sudo RESTIC_REPOSITORY=/backup/restic RESTIC_PASSWORD_FILE=/root/.restic-pw bash backup-restic.sh [--snapshot vg/lv:/mountpoint]
# 適用 Ubuntu 24.04 / Fedora 44（restic 套件皆在官方庫）
set -euo pipefail

: "${RESTIC_REPOSITORY:?請設定 RESTIC_REPOSITORY（如 /backup/restic、sftp:user@host:/repo、s3:https://s3.example.com/bucket）}"
: "${RESTIC_PASSWORD_FILE:?請設定 RESTIC_PASSWORD_FILE}"
export RESTIC_REPOSITORY RESTIC_PASSWORD_FILE

PATHS=(/etc /home /root /var/lib /var/log /opt /srv /usr/local)
EXCLUDES=(--exclude-caches --exclude '/var/lib/docker' --exclude '/var/lib/containers' --exclude '*/node_modules' --exclude '*/.cache' --exclude '/var/lib/libvirt/images')
KEEP=(--keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2)
SNAP=""; SNAP_MNT=/mnt/restic-snap
[[ ${1:-} == --snapshot ]] && SNAP="$2"

log() { printf '%s %s\n' "$(date +'%F %T')" "$*"; }
cleanup() {
  if [[ -n $SNAP ]]; then
    umount "$SNAP_MNT" 2>/dev/null || true
    lvremove -fy "/dev/${SNAP%%:*}_snap" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

# 1) 初始化 repo（第一次）
restic cat config >/dev/null 2>&1 || { log "初始化 repository"; restic init; }

# 2) 可選：LVM 快照，讓資料庫等取得一致性視圖
if [[ -n $SNAP ]]; then
  LV=${SNAP%%:*}; MNT=${SNAP##*:}          # 例：vg0/lv_data:/data
  log "建立 LVM 快照 $LV"
  lvcreate -s -L 5G -n "$(basename "$LV")_snap" "/dev/$LV" >/dev/null
  mkdir -p "$SNAP_MNT"
  mount -o ro,nouuid "/dev/${LV}_snap" "$SNAP_MNT" 2>/dev/null || mount -o ro "/dev/${LV}_snap" "$SNAP_MNT"
  PATHS+=("$SNAP_MNT")
fi

# 3) 資料庫傾印（有裝才做）
DUMP_DIR=/var/backups/db; mkdir -p "$DUMP_DIR"
if command -v pg_dumpall >/dev/null && systemctl is-active --quiet postgresql 2>/dev/null; then
  log "pg_dumpall"; sudo -u postgres pg_dumpall | gzip > "$DUMP_DIR/pg_all.sql.gz"
fi
if command -v mariadb-dump >/dev/null && systemctl is-active --quiet mariadb 2>/dev/null; then
  log "mariadb-dump"; mariadb-dump --all-databases --single-transaction --routines | gzip > "$DUMP_DIR/mariadb_all.sql.gz"
fi
PATHS+=("$DUMP_DIR")

# 4) 備份
log "restic backup: ${PATHS[*]}"
restic backup "${PATHS[@]}" "${EXCLUDES[@]}" --one-file-system --tag "$(hostname -s)" --tag auto

# 5) 保留策略與完整性檢查
log "forget/prune"
restic forget "${KEEP[@]}" --prune
log "check（抽樣 5% 資料）"
restic check --read-data-subset=5%
log "完成"; restic snapshots --latest 3
