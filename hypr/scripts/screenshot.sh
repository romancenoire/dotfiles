#!/bin/bash
folder="$HOME/Pictures/Screenshots"

if [ ! -d "$folder" ]; then
    mkdir -p "$folder"
fi

filename="$folder/$(date +%Y-%m-%d_%H-%M-%S).png"

grim -g "$(slurp)" "$filename"
wl-copy < "$filename"
notify-send "Screenshot saved and copied to clipboard"