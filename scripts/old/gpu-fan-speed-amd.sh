#!/usr/bin/env bash
# AMD GPU Fan Speed Control Script
# Date: 2025-11-12

set -euo pipefail

# ---- FIND AMDGPU HWMON ----
HWMON=""
for d in /sys/class/hwmon/hwmon*; do
    [[ -f "$d/name" && "$(cat "$d/name")" == "amdgpu" ]] && HWMON="$d"
done

if [[ -z "$HWMON" ]]; then
    echo "Error: AMDGPU hwmon device not found." >&2
    exit 1
fi

PWM_ENABLE="$HWMON/pwm1_enable"
PWM="$HWMON/pwm1"
PWM_MAX="$(<"$HWMON/pwm1_max")"

# ---- FUNCTIONS ----
set_fan_speed() {
    local speed="$1"
    local pwm_value=$(( PWM_MAX * speed / 100 ))

    echo 1 > "$PWM_ENABLE"
    echo "$pwm_value" > "$PWM"

    echo "AMD GPU fan speed set to ${speed}%."
}

set_auto_mode() {
    echo 0 > "$PWM_ENABLE"
    echo "Automatic fan control enabled."
}

sanitize() {
    printf '%s' "$1" \
        | tr -d '\r' \
        | cut -d'|' -f1 \
        | tr -d '%' \
        | xargs 2>/dev/null
}

# ---- ARG HANDLING ----
if [[ -n "${1:-}" ]]; then
    set -- "$(sanitize "$1")"
fi

# ---- YAD PROMPT ----
if [[ -z "${1:-}" ]]; then
    if command -v yad >/dev/null 2>&1; then
        CHOICE=$(yad --list \
            --title="Set AMD GPU Fan Speed" \
            --text="Select fan mode or speed:" \
            --column="Option" \
            --hide-header \
            --center \
            --width=250 \
            --height=300 \
            "Auto" "25%" "50%" "75%" "100%")

        [[ -z "$CHOICE" ]] && exit 0
        set -- "$(sanitize "$CHOICE")"
    else
        echo "Error: yad not installed." >&2
        exit 1
    fi
fi

# ---- AUTO MODE ----
case "${1,,}" in
    -a|--a|--auto|auto)
        set_auto_mode
        exit 0
        ;;
esac

# ---- VALIDATION ----
if [[ ! "$1" =~ ^[0-9]+$ ]] || (( 10#$1 < 1 || 10#$1 > 100 )); then
    echo "Error: Fan speed must be between 1 and 100, or use --auto." >&2
    exit 1
fi

# ---- APPLY ----
set_fan_speed "$1"
exit 0
