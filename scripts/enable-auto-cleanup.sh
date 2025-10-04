#!/usr/bin/env bash
set -e

# Create cleanup script
sudo tee /usr/local/bin/pi-cleanup.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
# Auto-cleanup script for Raspberry Pi

# Remove old packages
apt-get autoremove -y -qq
apt-get autoclean -y -qq

# Clean journal logs older than 7 days
journalctl --vacuum-time=7d >/dev/null 2>&1

# Clean old log files
find /var/log -type f -name "*.gz" -mtime +30 -delete 2>/dev/null || true
find /var/log -type f -name "*.old" -mtime +30 -delete 2>/dev/null || true

echo "✓ Cleanup completed: $(date)" >> /var/log/pi-cleanup.log
EOF

sudo chmod +x /usr/local/bin/pi-cleanup.sh

# Add weekly cron job (Sunday 3am)
CRON_JOB="0 3 * * 0 /usr/local/bin/pi-cleanup.sh"
(sudo crontab -l 2>/dev/null | grep -v pi-cleanup.sh; echo "$CRON_JOB") | sudo crontab -

echo "✓ Auto-cleanup configured"
echo "  Weekly cleanup (Sunday 3am): packages, logs, journal"
