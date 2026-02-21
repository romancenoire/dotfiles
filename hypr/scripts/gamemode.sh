#!/bin/bash

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = 1 ] ; then
    pkill waybar

    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:active_opacity 1;\
        keyword decoration:inactive_opacity 1;\
        keyword decoration:fullscreen_opacity 1;\
        keyword general:gaps_in 0;\
	    keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"

    notify-send -t 1000 -u normal -i "input-gaming" "Gamemode" "Activé (Animations et Waybar OFF)"
    exit
else
    waybar &
    hyprctl reload
    notify-send -t 1000 -u normal -i "input-gaming" "Gamemode" "Désactivé (Animations et Waybar ON)"
    exit 0
fi
