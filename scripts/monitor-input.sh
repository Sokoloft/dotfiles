#!/usr/bin/env bash
#
# Monitor input toggle using DDC/CI
# Samsung LS27D70xE
#

set -euo pipefail


BUS=2
VCP_INPUT=60

declare -A INPUT_NAMES=(
  [0x0f]="dp1"
  [0x11]="hdmi1"
)

declare -A INPUT_CODES=(
  ["dp1"]="0x0f"
  ["hdmi1"]="0x11"
)

get_current_input() {
  local hex

  hex=$(
    ddcutil -b "$BUS" getvcp "$VCP_INPUT" 2>/dev/null |
      grep -oP 'sl=\K0x[0-9a-fA-F]+' |
      tr '[:upper:]' '[:lower:]'
  )

  [[ -n "$hex" && -n "${INPUT_NAMES[$hex]:-}" ]] || return 1
  echo "${INPUT_NAMES[$hex]}"
}

current_input=$(get_current_input) || {
  echo "Error: Unable to detect current monitor input"
  exit 1
}

echo "Detected current input: $current_input"

case "$current_input" in
  dp1)   next_input="hdmi1" ;;
  hdmi1) next_input="dp1" ;;
  *)
    echo "Unsupported input: $current_input"
    exit 1
    ;;
esac

echo "Switching to: $next_input"

ddcutil -b "$BUS" setvcp "$VCP_INPUT" "${INPUT_CODES[$next_input]}" || {
  echo "Error: Failed to switch input"
  exit 1
}

echo "Switch complete."
exit 0
