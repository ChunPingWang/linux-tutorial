set -e
. /etc/os-release
command -v python3 >/dev/null || { [ "$ID" = ubuntu ] && apt-get install -y -q python3 >/dev/null 2>&1 || dnf -y -q install python3 >/dev/null 2>&1; }
id myapp &>/dev/null || useradd -r -s /usr/sbin/nologin myapp 2>/dev/null || useradd -r -s /sbin/nologin myapp
install -d -o myapp -g myapp /opt/myapp/bin /var/lib/myapp /var/log/myapp
install -m 755 /root/ex/app.py /opt/myapp/bin/app
mkdir -p /etc/default; echo "PORT=8085" > /etc/default/myapp
cp /root/ex/myapp.service /root/ex/backup.service /root/ex/backup.timer /etc/systemd/system/
printf '#!/bin/sh\necho backup ran at $(date)\n' > /usr/local/bin/backup.sh; chmod +x /usr/local/bin/backup.sh
systemctl daemon-reload
systemd-analyze verify /etc/systemd/system/myapp.service /etc/systemd/system/backup.timer 2>&1 | grep -v "^$" || true
systemctl enable --now myapp.service backup.timer 2>&1 | grep -v Created || true
sleep 2
echo "myapp: $(systemctl is-active myapp) | curl: $(curl -s 127.0.0.1:8085)"
systemctl list-timers backup.timer --no-pager | head -2
systemctl start backup.service && journalctl -u backup.service --no-pager -n 1 -o cat
systemd-analyze security myapp.service --no-pager 2>/dev/null | tail -1
systemctl show myapp -p MainPID -p MemoryMax -p CPUQuotaPerSecUSec
systemctl edit --help >/dev/null && echo "systemctl edit ok"
systemd-run --unit=test-transient --on-active=1s /bin/true 2>&1 | head -1
systemctl restart myapp && echo restarted ok
