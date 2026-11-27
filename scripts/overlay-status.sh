#!/usr/bin/env bash
set -e

# Read-only: show overlay and boot partition state (raspi-config returns 0 = yes)

if ! command -v raspi-config &>/dev/null; then
  echo "⚠ raspi-config not found (Raspberry Pi OS required)"
  exit 1
fi

yes_no() {
  if [ "$(sudo raspi-config nonint "$1")" = "0" ]; then echo "yes"; else echo "no"; fi
}

echo "Overlay active now:             $(yes_no get_overlay_now)"
echo "Overlay active after reboot:    $(yes_no get_overlay_conf)"
echo "Boot read-only now:             $(yes_no get_bootro_now)"
echo "Boot read-only after reboot:    $(yes_no get_bootro_conf)"
