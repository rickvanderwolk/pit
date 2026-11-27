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

# Boot config: /boot/firmware on Bookworm and later (/boot/config.txt is only a stub there)
CONFIG=""
for f in /boot/firmware/config.txt /boot/config.txt; do
  if [ -f "$f" ]; then
    CONFIG="$f"
    break
  fi
done

if [ -z "$CONFIG" ]; then
  echo "ℹ Boot config not found, skipping"
elif grep -q "^dtoverlay=disable-bt" "$CONFIG"; then
  echo "ℹ Bluetooth already disabled in boot config"
else
  echo "dtoverlay=disable-bt" | sudo tee -a "$CONFIG" >/dev/null
  echo "✓ Bluetooth disabled in boot config ($CONFIG)"
  echo "⚠ Reboot required for boot config changes to take effect"
fi
