#!/usr/bin/env bash
set -e

# Detect wifi interface
WLAN=$(iw dev | awk '$1=="Interface"{print $2; exit}')
if [ -z "$WLAN" ]; then
  echo "ℹ No wifi interface found, skipping"
  exit 0
fi
echo "📡 Found wifi interface: $WLAN"

sudo tee /etc/systemd/system/wifi-powersave-off.service >/dev/null <<EOF
[Unit]
Description=Disable Wi-Fi power save
After=network.target
[Service]
Type=oneshot
ExecStart=/sbin/iw dev $WLAN set power_save off
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now wifi-powersave-off.service
echo "✓ WiFi power saving disabled on $WLAN"
