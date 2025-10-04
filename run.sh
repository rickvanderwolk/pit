#!/usr/bin/env bash
set -eo pipefail

GITHUB_REPO="https://raw.githubusercontent.com/rickvanderwolk/pit/main"
AVAILABLE_SCRIPTS=("disable-bluetooth" "disable-wifi-powersave" "enable-auto-cleanup" "enable-auto-security-updates" "enable-fail2ban" "enable-firewall" "enable-ssh-boost" "fix-locale")

# Detect if running locally or via curl
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  # Running locally
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MODE="local"
else
  # Running via curl | bash
  MODE="remote"
fi

if [ $# -eq 0 ]; then
  echo "Usage: $0 <script1> [script2 ...]"
  echo "Available scripts: ${AVAILABLE_SCRIPTS[*]}"
  exit 1
fi

for s in "$@"; do
  if [[ ! " ${AVAILABLE_SCRIPTS[*]} " =~ " ${s} " ]]; then
    echo "❌ Script not found: $s"
    echo "Available scripts: ${AVAILABLE_SCRIPTS[*]}"
    exit 1
  fi

  echo "▶ Running $s..."

  if [ "$MODE" = "local" ]; then
    FILE="$DIR/scripts/$s.sh"
    chmod +x "$FILE"
    "$FILE"
  else
    # Download and execute from GitHub
    curl -sSL "$GITHUB_REPO/scripts/$s.sh" | bash
  fi

  echo "✓ $s completed"
done
