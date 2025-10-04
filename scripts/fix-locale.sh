#!/usr/bin/env bash
set -e

# Generate en_US.UTF-8 locale
if ! locale -a | grep -q "^en_US.utf8"; then
  echo "📦 Generating en_US.UTF-8 locale..."
  sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  sudo locale-gen en_US.UTF-8
fi

# Set as default locale
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Add to bashrc for current user (only if not already present)
if [ -f ~/.bashrc ]; then
  if ! grep -q "export LC_ALL=en_US.UTF-8" ~/.bashrc; then
    echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
  fi
  if ! grep -q "export LANG=en_US.UTF-8" ~/.bashrc; then
    echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
  fi
fi

echo "✓ Locale configured to en_US.UTF-8"
echo "⚠ Log out and back in (or reboot) for changes to take full effect"
