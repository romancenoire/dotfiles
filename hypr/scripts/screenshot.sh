#!/bin/bash

FOLDER="$HOME/Pictures/Screenshots"
FILENAME="$FOLDER/$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p "$FOLDER"

_save_and_notify() {
    wl-copy < "$FILENAME"
    action=$(notify-send "Screenshot" "Sauvegardé et copié" \
        -i "$FILENAME" \
        -u low \
        --action="annotate=Annoter" \
        --action="delete=Supprimer")
    case "$action" in
        annotate) swappy -f "$FILENAME" ;;
        delete)   rm "$FILENAME" && notify-send "Screenshot" "Supprimé" -i user-trash -u low ;;
    esac
}

case "$1" in
    selection)
        grim -g "$(slurp)" "$FILENAME" && _save_and_notify
        ;;
    fullscreen)
        MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.x),\(.y) \(.width)x\(.height)"')
        grim -g "$MONITOR" "$FILENAME" && _save_and_notify
        ;;
    window)
        GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$GEOMETRY" "$FILENAME" && _save_and_notify
        ;;
    *)
        echo "Usage: $0 {selection|fullscreen|window}"
        exit 1
        ;;
esac