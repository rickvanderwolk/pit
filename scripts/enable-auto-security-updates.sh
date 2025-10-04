#!/usr/bin/env bash
set -e

# Check if unattended-upgrades is installed
if ! dpkg -l | grep -q unattended-upgrades; then
  echo "📦 Installing unattended-upgrades..."
  sudo apt-get update -qq
  sudo apt-get install -y unattended-upgrades
fi

# Configure automatic security updates
sudo tee /etc/apt/apt.conf.d/50unattended-upgrades >/dev/null <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF

# Enable automatic updates
sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

echo "✓ Automatic security updates enabled"
echo "  Daily check for security updates"
echo "  Auto-reboot at 03:00 if required"
