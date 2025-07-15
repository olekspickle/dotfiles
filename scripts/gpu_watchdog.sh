#!/bin/bash

# --- Configuration ---
LOG_FILE="${HOME}/gpu_watchdog.log"
THRESHOLD=95 # Percent VRAM usage to trigger a warning
# Path to the DRM device. Adjust if you have multiple cards or a different setup.
DRM_CARD_PATH="/sys/class/drm/card1/device"
# Path for AMD GPU recovery. This file might not exist or work on all systems/drivers.
RECOVERY_FILE="/sys/kernel/debug/dri/0/amdgpu_gpu_recover"
# Time in seconds to wait between checks.
CHECK_INTERVAL=10
# Maximum number of consecutive high VRAM alerts before attempting a recovery action.
MAX_ALERTS=3

# --- Helper Functions ---

# Function to send desktop notifications and log messages.
# Arguments:
#   $1: The message to display/log.
notify() {
    local message="$1"
    if command -v notify-send &> /dev/null; then
        notify-send "GPU Watchdog" "$message"
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

# Function to restart the KWin compositor.
# This can sometimes resolve display issues or free up VRAM.
restart_kwin() {
    notify "🔄 Attempting to restart KWin compositor..."
    # Try to find KWin's PID for both X11 and Wayland.
    local kwin_pid=$(pgrep -u "$USER" -x kwin_x11 || pgrep -u "$USER" -x kwin_wayland)

    if [ -n "$kwin_pid" ]; then
        notify "Killing KWin compositor (PID: $kwin_pid)..."
        # Using SIGTERM first for a graceful shutdown, then SIGKILL if needed.
        kill "$kwin_pid"
        sleep 2 # Give it time to shut down

        if pgrep -u "$USER" -x kwin_x11 || pgrep -u "$USER" -x kwin_wayland > /dev/null; then
            notify "KWin did not terminate gracefully, forcing kill."
            kill -9 "$kwin_pid"
            sleep 2
        fi

        # Attempt to restart KWin.
        # It's generally better to rely on the display manager to restart it,
        # but if running manually, you might need to specify the command.
        # For typical Plasma setups, KWin often restarts itself.
        # If running in a script that detaches, 'nohup' might be needed.
        # For simplicity and to avoid issues with display environments,
        # we often just kill it and let the system revive it.
        notify "KWin restart initiated (or waiting for system to restart it)."
    else
        notify "ℹ️ No running KWin instance found for user $USER."
    fi
}

# Function to attempt an AMD GPU recovery.
# This writes to a debug file and requires specific kernel modules/permissions.
attempt_gpu_recovery() {
    if [ -f "$RECOVERY_FILE" ]; then
        notify "⚠️ Attempting AMD GPU recovery by writing to $RECOVERY_FILE..."
        # Ensure sufficient permissions. This often requires root.
        # Running this script with sudo or setting up udev rules might be necessary.
        echo 1 | sudo tee "$RECOVERY_FILE" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            notify "✅ AMD GPU recovery command issued successfully."
        else
            notify "❌ Failed to issue AMD GPU recovery command. Check permissions or file existence."
            notify "   You might need to run this script with 'sudo' or configure udev rules."
        fi
        sleep 5 # Give the system some time to recover.
    else
        notify "ℹ️ AMD GPU recovery file not found at $RECOVERY_FILE. Skipping recovery."
    fi
}

# Function to log the top processes using GPU resources (VRAM or compute).
# Requires 'radeontop' or 'amdgpu_top' for AMD, or 'nvidia-smi' for Nvidia.
log_top_gpu_user() {
    notify "🔍 Logging top GPU processes..."
    echo "--- Top GPU Processes (triggered by high VRAM) ---" >> "$LOG_FILE"

    # For AMD GPUs, 'amdgpu_top' is a good tool.
    if command -v amdgpu_top &> /dev/null; then
        amdgpu_top --json -l 1 -s 1 | jq -r '."GPU Info".Process_list[] | select(."VRAM Usage" > 0 or ."GFX" > 0 or ."COMPUTE" > 0) | "\(.Comm) (PID: \.PID): VRAM=\(.["VRAM Usage"])MB, GFX=\(.GFX)%, COMPUTE=\(.COMPUTE)%"' >> "$LOG_FILE" 2>&1
    # 'radeontop' is an older alternative, but less detailed for process-specific VRAM.
    elif command -v radeontop &> /dev/null; then
        notify "ℹ️ Using 'radeontop' (less detailed for process VRAM)."
        radeontop -d -1 -l 1 >> "$LOG_FILE" 2>&1
    # For Nvidia GPUs (if you were adapting this script).
    elif command -v nvidia-smi &> /dev/null; then
        notify "ℹ️ Nvidia GPU detected. Using nvidia-smi for process information."
        nvidia-smi pmon -c 1 >> "$LOG_FILE" 2>&1
    else
        notify "❌ No suitable GPU monitoring tool (amdgpu_top, radeontop, nvidia-smi) found."
        notify "   Consider installing 'amdgpu_top' for better insights on AMD GPUs."
    fi
    echo "---------------------------------------------------" >> "$LOG_FILE"
}

# --- Main Script Logic ---
notify "🚀 GPU Watchdog started."

# Counter for consecutive high VRAM alerts.
consecutive_alerts=0

while true; do
    # Get VRAM usage for card0. Requires 'cat' and 'awk'.
    # This path provides total VRAM, used VRAM might need other tools.
    # A more robust approach involves parsing 'amdgpu_top' or 'radeontop'.
    # For a simple percentage, we might need total and used VRAM.
    # Let's assume we're looking at a specific metric that gives a percentage or can be converted.
    # Example: If we can read 'mem_info_vram_used' and 'mem_info_vram_total'
    # from a tool like amdgpu_top or sysfs.
    # For now, let's stick to the spirit of the original script.

    # Placeholder for actual VRAM usage reading.
    # This is often the trickiest part as sysfs nodes vary or require parsing.
    # A common way is to get it from debugfs or through a utility.
    # For example, using `amdgpu_top` if installed:
    VRAM_USAGE_PERCENT=$(amdgpu_top --json -l 1 -s 1 2>/dev/null | jq '."VRAM Info"."Usage %"' | cut -d'.' -f1)

    if [ -z "$VRAM_USAGE_PERCENT" ]; then
        notify "⚠️ Could not get VRAM usage percentage. Is 'amdgpu_top' installed and working?"
        notify "   Falling back to a more generic (less accurate) check if available or exiting."
        # As a fallback, one might try parsing radeontop or specific sysfs files,
        # but it's often better to ensure 'amdgpu_top' is available for modern AMD GPUs.
        # For now, if we can't get it, we'll log and continue, but won't trigger alerts.
        sleep "$CHECK_INTERVAL"
        continue
    fi

    notify "📊 Current VRAM Usage: ${VRAM_USAGE_PERCENT}% (Threshold: ${THRESHOLD}%)"

    if (( VRAM_USAGE_PERCENT >= THRESHOLD )); then
        consecutive_alerts=$((consecutive_alerts + 1))
        notify "🔥 WARNING: High VRAM usage detected: ${VRAM_USAGE_PERCENT}% (Alerts: ${consecutive_alerts}/${MAX_ALERTS})"
        log_top_gpu_user

        if (( consecutive_alerts >= MAX_ALERTS )); then
            notify "🚨 Maximum consecutive alerts reached. Initiating recovery actions."
            restart_kwin
            attempt_gpu_recovery
            consecutive_alerts=0 # Reset alert counter after attempting recovery.
        fi
    else
        if (( consecutive_alerts > 0 )); then
            notify "👍 VRAM usage is back below threshold (${VRAM_USAGE_PERCENT}%). Resetting alert counter."
            consecutive_alerts=0
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
