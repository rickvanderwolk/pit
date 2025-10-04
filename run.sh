#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ $# -eq 0 ]; then
  echo "Usage: $0 <script1> [script2 ...]"
  echo "Available scripts:"
  ls "$DIR/scripts" | sed 's/\.sh$//' | column
  exit 1
fi
for s in "$@"; do
  FILE="$DIR/scripts/$s.sh"
  if [ -f "$FILE" ]; then
    chmod +x "$FILE"
    echo "▶ Running $s..."
    "$FILE"
    echo "✓ $s completed"
  else
    echo "❌ Script not found: $s"
    exit 1
  fi
done
