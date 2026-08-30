set -e
. /etc/os-release
if [ "$ID" = ubuntu ]; then apt-get install -y -q restic openssl >/dev/null 2>&1; else dnf -y -q install restic openssl >/dev/null 2>&1; fi
restic version
SRC=/root/backup-restic.sh; [ -f $SRC ] || SRC=/manual/scripts/backup-restic.sh   # setup-lab.sh 把手冊掛在 /manual
install -m 700 $SRC /usr/local/bin/backup-restic.sh
openssl rand -base64 32 > /root/.restic-pw; chmod 600 /root/.restic-pw
rm -rf /backup/restic; mkdir -p /backup /srv/testdata; echo "important $(date)" > /srv/testdata/file.txt
export RESTIC_REPOSITORY=/backup/restic RESTIC_PASSWORD_FILE=/root/.restic-pw
# 縮小備份範圍以加速測試
sed -i 's|^PATHS=(.*)|PATHS=(/etc /srv/testdata)|' /usr/local/bin/backup-restic.sh
/usr/local/bin/backup-restic.sh 2>&1 | grep -vE "^(processed|Files:|Dirs:|Added|snapshot|Applying|keep|remove|\[|loading|repository|checking|counting|building|using|no errors|$)" | tail -12
echo "--- restore test"; rm -rf /tmp/restore; restic restore latest --target /tmp/restore --include /srv/testdata >/dev/null 2>&1; diff /srv/testdata/file.txt /tmp/restore/srv/testdata/file.txt && echo RESTORE_OK
echo "--- timer units"; EX=/root/ex; [ -f $EX/restic-backup.timer ] || EX=/manual/scripts/examples
cp $EX/restic-backup.service $EX/restic-backup.timer /etc/systemd/system/; systemctl daemon-reload; systemd-analyze verify /etc/systemd/system/restic-backup.timer 2>&1 | head -2; systemctl enable --now restic-backup.timer 2>&1 | grep -v Created || true; systemctl list-timers restic-backup.timer --no-pager | sed -n 2p
