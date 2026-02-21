#!/bin/bash
LOCATION="Paris"
curl -sf "https://wttr.in/$LOCATION?format=1" 2>/dev/null || echo "N/A"