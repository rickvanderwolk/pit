#!/usr/bin/env bash
set -e

# Check if fail2ban is installed
if ! command -v fail2ban-server &>/dev/null; then
  echo "📦 Installing fail2ban..."
  sudo apt-get update -qq
  sudo apt-get install -y fail2ban
fi

# Create local jail configuration
sudo tee /etc/fail2ban/jail.local >/dev/null <<'EOF'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

# Restart fail2ban
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

echo "✓ Fail2ban configured and enabled for SSH protection"
echo "  Ban time: 1 hour | Max retries: 5 in 10 minutes"
