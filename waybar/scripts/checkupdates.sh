#!/bin/bash
export TMPDIR=/tmp

pacman=$(pacman -Qu 2>/dev/null | wc -l)
aur=$(/usr/bin/yay -Qua --aur 2>/dev/null | wc -l)
flatpak=$(flatpak remote-ls --updates --columns=application 2>/dev/null | wc -l)
total=$((pacman + aur + flatpak))
tooltip="pacman: $pacman | aur: $aur | flatpak: $flatpak"

if [ "$total" -eq 0 ]; then
    echo '{"text": "0", "tooltip": "Système à jour"}'
else
    jq -cn --arg text "$total" --arg tooltip "$tooltip" '{"text": $text, "tooltip": $tooltip}'
fi