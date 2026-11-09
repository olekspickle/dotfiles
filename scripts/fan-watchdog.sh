#!/bin/bash
# FW16 Expansion Bay fans can silently stall (EC requests RPM, fans read 0) after long power-off or a loose
# connector; warns before the CPU throttles at ~99°C. Run by cron every minute, see setup/hard.sh.

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
STATE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/fan-watchdog.last"
COOLDOWN=600
SAMPLES=4
INTERVAL=10

hwmon=""
for n in /sys/class/hwmon/hwmon*/name; do
    [ "$(cat "$n")" = cros_ec ] && hwmon=$(dirname "$n") && break
done

notify() {
    local now last
    now=$(date +%s)
    last=$(cat "$STATE" 2>/dev/null || echo 0)
    (( now - last < COOLDOWN )) && return
    echo "$now" >"$STATE"
    notify-send -u critical -i dialog-warning "Fan watchdog" "$1"
    logger -t fan-watchdog "$1"
}

if [ -z "$hwmon" ]; then
    notify "cros_ec hwmon not found: fan state unknown"
    exit 0
fi

# Fans lag a few seconds behind the target, so require the stall across the whole window.
stalled=1
for ((i = 0; i < SAMPLES; i++)); do
    target=$(cat "$hwmon/fan1_target")
    f1=$(cat "$hwmon/fan1_input")
    f2=$(cat "$hwmon/fan2_input")
    if (( target == 0 || (f1 > 0 && f2 > 0) )); then
        stalled=0
        break
    fi
    sleep "$INTERVAL"
done

cpu=$(( $(cat "$hwmon/temp4_input") / 1000 ))
if (( stalled )); then
    notify "Fans not spinning: target ${target} RPM, fan1=${f1} fan2=${f2}, CPU ${cpu}°C. Reboot / reseat Expansion Bay."
elif (( cpu >= 95 )); then
    notify "CPU at ${cpu}°C (fan1=${f1} fan2=${f2} RPM)"
fi
