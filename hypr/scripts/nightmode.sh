#!/bin/bash

TEMP="${HYPRSUNSET_TEMP:-4000}"
STATE_FILE="/tmp/hyprsunset_state"

if [ "$(cat $STATE_FILE 2>/dev/null)" = "on" ]; then
    hyprctl hyprsunset identity
    echo "off" > "$STATE_FILE"
    notify-send "Night Light" "Off" -u low -i weather-clear
else
    hyprctl hyprsunset temperature "$TEMP"
    echo "on" > "$STATE_FILE"
    notify-send "Night Light" "On (${TEMP}K)" -u low -i weather-clear-night
fi