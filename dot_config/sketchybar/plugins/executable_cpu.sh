#!/bin/bash

CPU_INFO=$(top -l 2 -n 0 -F | grep "CPU usage" | tail -1)
CPU_USER=$(echo "$CPU_INFO" | awk '{print $3}' | sed 's/%//')
CPU_SYS=$(echo "$CPU_INFO" | awk '{print $5}' | sed 's/%//')

CPU_TOTAL=$(echo "scale=1; $CPU_USER + $CPU_SYS" | bc)

if [ -z "$CPU_TOTAL" ]; then
    sketchybar --set cpu label="--" \
                     icon.color="0xfff7768e" \
                     label.color="0xfff7768e" \
                     background.color="0x33f7768e"
    exit 1
fi

CPU_INT=$(echo "$CPU_TOTAL" | cut -d. -f1)
if [ "$CPU_INT" -gt 80 ]; then
    COLOR="0xfff7768e"
    BG_COLOR="0x33f7768e"
elif [ "$CPU_INT" -gt 60 ]; then
    COLOR="0xffe0af68"
    BG_COLOR="0x33e0af68"
elif [ "$CPU_INT" -gt 30 ]; then
    COLOR="0xff7aa2f7"
    BG_COLOR="0x267aa2f7"
else
    COLOR="0xff9ece6a"
    BG_COLOR="0x229ece6a"
fi

sketchybar --set cpu label="${CPU_TOTAL}%" \
                     icon.color="$COLOR" \
                     label.color="$COLOR" \
                     background.color="$BG_COLOR"
