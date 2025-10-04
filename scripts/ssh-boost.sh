#!/usr/bin/env bash
set -e

# Check if SSH service exists
if ! systemctl list-unit-files | grep -q "ssh.service\|sshd.service"; then
  echo "❌ SSH service not found"
  exit 1
fi

# Determine service name (Debian uses 'ssh', others use 'sshd')
SERVICE="ssh"
systemctl list-unit-files | grep -q "sshd.service" && SERVICE="sshd"

sudo mkdir -p /etc/systemd/system/$SERVICE.service.d
sudo tee /etc/systemd/system/$SERVICE.service.d/override.conf >/dev/null <<'EOF'
[Service]
Nice=-5
IOSchedulingClass=best-effort
IOSchedulingPriority=2
EOF
sudo systemctl daemon-reload
sudo systemctl restart $SERVICE
echo "✓ SSH service ($SERVICE) priority boosted"
