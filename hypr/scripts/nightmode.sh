#!/bin/bash

TEMP="${HYPRSUNSET_TEMP:-4000}"
GAMMA="${HYPRSUNSET_GAMMA:-75}"
STATE_FILE="/tmp/hyprsunset_state"

if [ "$(cat $STATE_FILE 2>/dev/null)" = "on" ]; then
    pkill hyprsunset
    echo "off" > "$STATE_FILE"
    notify-send "Night Light" "Off" -u low -i weather-clear
else
    hyprsunset -t "$TEMP" -g "$GAMMA" &
    echo "on" > "$STATE_FILE"
    notify-send "Night Light" "On (${TEMP}K - ${GAMMA}%)" -u low -i weather-clear-night
fi