#!/usr/bin/sh

# 11/15/24

# Sets working dir
cd "$(dirname "$0")"

# Check if .monitorvalue exists
if [[ -f .monitorvalue ]]; then
  input=$(cat .monitorvalue)
  echo "value found"
else
  echo "value set to default dp1"
  input="dp1"
fi

# set input to HDMI
if [[ $input == "dp1" ]]; then
    echo "changing to hdmi1"
    ddcutil -b 3 setvcp 60 0x11   # Use bus number instead of display for faster switching
    echo "hdmi1" > .monitorvalue
elif [[ $input == "hdmi1" ]]; then
    # set input to DisplayPort 1
    echo "changing to dp1"
    ddcutil -b 3 setvcp 60 0x0f
    echo "dp1" > .monitorvalue
else
    echo "No value?"
fi

exit


