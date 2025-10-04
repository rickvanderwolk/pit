#!/usr/bin/env bash
set -e

# Check if ufw is installed
if ! command -v ufw &>/dev/null; then
  echo "📦 Installing ufw..."
  sudo apt-get update -qq
  sudo apt-get install -y ufw
fi

# Check if firewall is already active
if sudo ufw status | grep -q "Status: active"; then
  echo "ℹ Firewall already active"
else
  # First time setup: reset and configure
  echo "⚠ Configuring firewall..."
  sudo ufw --force reset >/dev/null

  # Set default policies
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  # Allow SSH only (prevent lockout)
  sudo ufw allow ssh

  # Enable firewall
  echo "y" | sudo ufw enable >/dev/null

  echo "✓ Firewall configured and enabled"
  echo "  Default: deny incoming, allow outgoing"
  echo "  Allowed: SSH (22)"
  echo ""
  echo "ℹ To allow additional ports, use: sudo ufw allow <port>"
fi
