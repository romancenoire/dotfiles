#!/bin/bash

RES1_W=960; RES1_H=540
RES2_W=854; RES2_H=480
RES3_W=640; RES3_H=360
PADDING=32
SCREEN_W=1920
SCREEN_H=1080

WINDOW_INFO=$(hyprctl activewindow -j)
ADDR=$(echo "$WINDOW_INFO" | jq -r '.address')
CUR_W=$(echo "$WINDOW_INFO" | jq '.size[0]')

hyprctl dispatch setfloating address:$ADDR
hyprctl dispatch pin address:$ADDR

if [ "$CUR_W" -eq $RES1_W ]; then
    W=$RES2_W; H=$RES2_H
elif [ "$CUR_W" -eq $RES2_W ]; then
    W=$RES3_W; H=$RES3_H
else
    W=$RES1_W; H=$RES1_H
fi

POS_X=$((SCREEN_W - W - PADDING))
POS_Y=$((SCREEN_H - H - PADDING))

hyprctl --batch "dispatch resizewindowpixel exact $W $H,address:$ADDR ; dispatch movewindowpixel exact $POS_X $POS_Y,address:$ADDR"
