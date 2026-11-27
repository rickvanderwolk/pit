#!/usr/bin/env bash
set -e

if ! command -v raspi-config &>/dev/null; then
  echo "⚠ raspi-config not found (Raspberry Pi OS required)"
  exit 1
fi

OVERLAY_NOW=$(sudo raspi-config nonint get_overlay_now)
OVERLAY_CONF=$(sudo raspi-config nonint get_overlay_conf)
BOOTRO_CONF=$(sudo raspi-config nonint get_bootro_conf)

if [ "$OVERLAY_CONF" != "0" ] && [ "$BOOTRO_CONF" != "0" ]; then
  echo "ℹ Overlay and read-only boot partition already disabled"
else
  # Disables overlay; also disables read-only boot when overlay is not active
  sudo raspi-config nonint do_overlayfs 1
  echo "✓ Overlay disabled for next boot"
fi

if [ "$OVERLAY_NOW" = "0" ]; then
  # /etc/fstab cannot be changed while the overlay is active
  echo ""
  echo "⚠ Overlay still active: reboot required (sudo reboot)"
  echo "ℹ Boot partition stays read-only after this reboot."
  echo "  Run this script again after reboot to make /boot/firmware writable"
  echo "  (e.g. for kernel updates via apt) and to re-enable automatic updates"
else
  if [ "$(sudo raspi-config nonint get_bootro_conf)" = "0" ]; then
    echo "⚠ Boot partition still read-only after reboot"
  else
    echo "✓ Boot partition writable after reboot"
  fi
  # Re-enable automatic updates (disabled by enable-overlay)
  for t in apt-daily.timer apt-daily-upgrade.timer; do
    if systemctl cat "$t" &>/dev/null && ! systemctl is-enabled --quiet "$t" 2>/dev/null; then
      sudo systemctl enable --now "$t" >/dev/null 2>&1
      echo "✓ $t enabled"
    fi
  done
  if [ "$(sudo raspi-config nonint get_bootro_now)" = "0" ]; then
    echo "⚠ Reboot required: sudo reboot"
  fi
fi

echo ""
echo "ℹ Tip: make boot partition writable temporarily with:"
echo "  sudo mount -o remount,rw /boot/firmware"
