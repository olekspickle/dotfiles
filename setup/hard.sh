#!/bin/bash
# Hardware-specific setup (Framework Laptop 16).

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

setup_fan_watchdog() {
    local script="$DOTFILES/scripts/fan-watchdog.sh"
    local line="* * * * * $script"
    chmod +x "$script"
    # Drop any previous entry so reruns stay idempotent.
    { crontab -l 2>/dev/null | grep -vF "fan-watchdog.sh" || true; echo "$line"; } | crontab -
    echo "Installed cron: $line"
}

setup_fan_watchdog
