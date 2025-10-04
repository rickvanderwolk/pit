#!/usr/bin/env bash
set -e

# Stop and disable bluetooth service
if systemctl list-unit-files | grep -q bluetooth.service; then
  sudo systemctl stop bluetooth.service 2>/dev/null || true
  sudo systemctl disable bluetooth.service
  echo "✓ Bluetooth service disabled"
else
  echo "ℹ Bluetooth service not found (may already be disabled)"
fi

# Disable bluetooth in boot config
if [ -f /boot/config.txt ]; then
  if ! grep -q "^dtoverlay=disable-bt" /boot/config.txt; then
    echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt >/dev/null
    echo "✓ Bluetooth disabled in boot config"
    echo "⚠ Reboot required for boot config changes to take effect"
  else
    echo "ℹ Bluetooth already disabled in boot config"
  fi
elif [ -f /boot/firmware/config.txt ]; then
  if ! grep -q "^dtoverlay=disable-bt" /boot/firmware/config.txt; then
    echo "dtoverlay=disable-bt" | sudo tee -a /boot/firmware/config.txt >/dev/null
    echo "✓ Bluetooth disabled in boot config"
    echo "⚠ Reboot required for boot config changes to take effect"
  else
    echo "ℹ Bluetooth already disabled in boot config"
  fi
fi
