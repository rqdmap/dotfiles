#!/bin/bash

DISK_PERCENT=$(df /System/Volumes/Data 2>/dev/null | awk 'NR==2 { gsub(/%/, "", $5); print $5 }')

if [ -z "$DISK_PERCENT" ]; then
    DISK_PERCENT=$(df / | awk 'NR==2 { gsub(/%/, "", $5); print $5 }')
fi

if [ -z "$DISK_PERCENT" ]; then
    sketchybar --set disk label="--" label.color="0xfff7768e"
    exit 1
fi

if [ "$DISK_PERCENT" -gt 90 ]; then
    COLOR="0xfff7768e"
elif [ "$DISK_PERCENT" -gt 80 ]; then
    COLOR="0xffe0af68"
else
    COLOR="0xffc0caf5"
fi

sketchybar --set disk label="${DISK_PERCENT}%" label.color="$COLOR"
