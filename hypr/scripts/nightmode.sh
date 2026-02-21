#!/bin/bash

if pgrep -x "hyprsunset" > /dev/null; then
    killall -9 hyprsunset
    notify-send "Night Light" "Off" -u "low"
else
    hyprsunset --temperature 4000 --gamma 75 &
    notify-send "Night Light" "On" -u "low"
fi
