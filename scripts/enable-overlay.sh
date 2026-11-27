#!/usr/bin/env bash
set -e

# Overlay File System (raspi-config): root fs on tmpfs overlay, boot partition read-only.
# Protects the SD card against power loss. Run this as the last configuration.

if ! command -v raspi-config &>/dev/null; then
  echo "⚠ raspi-config not found (Raspberry Pi OS required)"
  exit 1
fi

OVERLAY_NOW=$(sudo raspi-config nonint get_overlay_now)
OVERLAY_CONF=$(sudo raspi-config nonint get_overlay_conf)

if [ "$OVERLAY_NOW" = "0" ]; then
  echo "ℹ Overlay already active"
  exit 0
fi

if [ "$OVERLAY_CONF" = "0" ]; then
  echo "ℹ Overlay already configured for next boot"
  echo "  To reboot, run: sudo reboot"
  exit 0
fi

# raspi-config refuses the overlay on devices with 256 MB RAM or less
MEM_KB=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null || true)
if [ -n "$MEM_KB" ] && [ "$MEM_KB" -le 262144 ]; then
  echo "⚠ Not enough RAM for overlay ($((MEM_KB / 1024)) MB, more than 256 MB required)"
  exit 1
fi

# Installs overlayroot if needed, enables overlay and makes boot partition read-only
echo "⚠ Enabling overlay file system..."
sudo raspi-config nonint do_overlayfs 0

if [ "$(sudo raspi-config nonint get_overlay_conf)" != "0" ]; then
  echo "⚠ Failed to enable overlay"
  exit 1
fi

echo "✓ Overlay enabled for next boot"

# Automatic updates would reinstall into RAM after every reboot; disable while still persistent
for t in apt-daily.timer apt-daily-upgrade.timer; do
  if systemctl is-enabled --quiet "$t" 2>/dev/null; then
    sudo systemctl disable --now "$t" >/dev/null 2>&1
    echo "✓ $t disabled (re-enabled by disable-overlay)"
  fi
done
if [ "$(sudo raspi-config nonint get_bootro_conf)" = "0" ]; then
  echo "✓ Boot partition read-only after reboot"
else
  echo "⚠ Boot partition stays writable"
fi
echo ""
echo "⚠ Reboot required: sudo reboot"
echo "ℹ After reboot, everything written to the root fs is lost on the next reboot"
echo "  To make changes, run disable-overlay first"
