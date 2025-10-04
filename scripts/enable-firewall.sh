#!/usr/bin/env bash
set -e

# Check if ufw is installed
if ! command -v ufw &>/dev/null; then
  echo "📦 Installing ufw..."
  sudo apt-get update -qq
  sudo apt-get install -y ufw
fi

# Reset to defaults (removes any existing custom rules)
echo "⚠ Resetting firewall to default configuration..."
sudo ufw --force reset >/dev/null

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (prevent lockout)
sudo ufw allow ssh

# Allow web/app ports
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 3000/tcp  # Node.js apps
sudo ufw allow 5000/tcp  # Flask/Python apps
sudo ufw allow 8000/tcp  # Django/alt web
sudo ufw allow 8080/tcp  # Alt HTTP

# Enable firewall
echo "y" | sudo ufw enable >/dev/null

echo "✓ Firewall configured and enabled"
echo "  Default: deny incoming, allow outgoing"
echo "  Allowed: SSH (22), HTTP (80), HTTPS (443)"
echo "  Allowed: Apps (3000, 5000, 8000, 8080)"
