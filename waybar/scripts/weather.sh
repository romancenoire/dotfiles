#!/bin/bash

CACHE="/tmp/weather_cache"
LOCATION="Paris"

result=$(curl -sf --max-time 5 "https://wttr.in/$LOCATION?format=1" 2>/dev/null)

if [ -n "$result" ]; then
    echo "$result" > "$CACHE"
    echo "$result"
elif [ -f "$CACHE" ]; then
    cat "$CACHE"
else
    echo "N/A"
fi