#!/bin/bash

VM_STAT=$(vm_stat)

MEM_DATA=$(printf "%s\n" "$VM_STAT" | awk '
  /page size of/ {
    page_size = $8
    gsub(/[^0-9]/, "", page_size)
  }
  /Pages free:/ { free = $NF; gsub(/[^0-9]/, "", free) }
  /Pages active:/ { active = $NF; gsub(/[^0-9]/, "", active) }
  /Pages inactive:/ { inactive = $NF; gsub(/[^0-9]/, "", inactive) }
  /Pages speculative:/ { speculative = $NF; gsub(/[^0-9]/, "", speculative) }
  /Pages wired down:/ { wired = $NF; gsub(/[^0-9]/, "", wired) }
  /Pages occupied by compressor:/ { compressor = $NF; gsub(/[^0-9]/, "", compressor) }
  END {
    used_pages = active + wired + compressor
    fallback_total_pages = free + active + inactive + speculative + wired + compressor
    printf "%d %d\n", used_pages * page_size, fallback_total_pages * page_size
  }
')

USED_BYTES=$(printf "%s" "$MEM_DATA" | awk '{print $1}')
FALLBACK_TOTAL_BYTES=$(printf "%s" "$MEM_DATA" | awk '{print $2}')
TOTAL_BYTES=$(sysctl -n hw.memsize 2>/dev/null)

if [ -z "$TOTAL_BYTES" ] || [ "$TOTAL_BYTES" -le 0 ]; then
    TOTAL_BYTES=$FALLBACK_TOTAL_BYTES
fi

if [ -z "$USED_BYTES" ] || [ -z "$TOTAL_BYTES" ] || [ "$TOTAL_BYTES" -le 0 ]; then
    sketchybar --set memory label="--" \
                         icon.color="0xfff7768e" \
                         label.color="0xfff7768e" \
                         background.color="0x33f7768e"
    exit 1
fi

MEM_PERCENT=$(awk -v used="$USED_BYTES" -v total="$TOTAL_BYTES" 'BEGIN { printf "%.0f", used / total * 100 }')

if [ "$MEM_PERCENT" -gt 85 ]; then
    COLOR="0xfff7768e"
    BG_COLOR="0x33f7768e"
elif [ "$MEM_PERCENT" -gt 70 ]; then
    COLOR="0xffe0af68"
    BG_COLOR="0x33e0af68"
elif [ "$MEM_PERCENT" -gt 50 ]; then
    COLOR="0xff7aa2f7"
    BG_COLOR="0x267aa2f7"
else
    COLOR="0xff9ece6a"
    BG_COLOR="0x229ece6a"
fi

sketchybar --set memory label="${MEM_PERCENT}%" \
                     icon.color="$COLOR" \
                     label.color="$COLOR" \
                     background.color="$BG_COLOR"
