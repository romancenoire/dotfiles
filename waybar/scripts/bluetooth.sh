#!/bin/bash

if ! bluetoothctl show | grep -q "Powered: yes"; then
    exit 0
fi

connected_devices=$(bluetoothctl devices | cut -d ' ' -f2 | while read dev; do
    if bluetoothctl info "$dev" | grep -q "Connected: yes"; then
        bluetoothctl info "$dev" | grep "Name" | cut -d ' ' -f2-
    fi
done)

if [ -z "$connected_devices" ]; then
    exit 0
fi

echo "$connected_devices"
