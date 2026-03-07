#!/bin/bash

PIP_W=426; PIP_H=240
PADDING=32

read ADDR IS_PINNED < <(hyprctl activewindow -j | jq -r '[.address, (.pinned | tostring)] | @tsv')

if [ "$IS_PINNED" = "true" ]; then
    hyprctl --batch "dispatch unpin address:$ADDR ; dispatch settiled address:$ADDR"
    notify-send "Picture in Picture" "Désactivé" -u low -i video-display
    exit 0
fi

read SCREEN_X SCREEN_Y SCREEN_W SCREEN_H < <(hyprctl monitors -j | jq -r '.[] | select(.focused) | [.x, .y, .width, .height] | @tsv')

POS_X=$((SCREEN_X + SCREEN_W - PIP_W - PADDING))
POS_Y=$((SCREEN_Y + SCREEN_H - PIP_H - PADDING))

hyprctl --batch "dispatch setfloating address:$ADDR ; dispatch pin address:$ADDR ; dispatch resizewindowpixel exact $PIP_W $PIP_H,address:$ADDR ; dispatch movewindowpixel exact $POS_X $POS_Y,address:$ADDR"

notify-send "Picture in Picture" "Activé (${PIP_W}x${PIP_H})" -u low -i video-display