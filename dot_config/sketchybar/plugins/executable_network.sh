#!/bin/bash

INTERFACE=$(route get default 2>/dev/null | grep interface | awk '{print $2}')

if [ -z "$INTERFACE" ]; then
    for iface in en0 en1 en2; do
        if ifconfig "$iface" 2>/dev/null | grep -q "inet "; then
            INTERFACE="$iface"
            break
        fi
    done
fi

if [ -z "$INTERFACE" ]; then
    sketchybar --set network_down label="--" label.color="0xfff7768e" \
               --set network_up label="--" label.color="0xfff7768e"
    exit 1
fi

CACHE_FILE="/tmp/sketchybar_network_cache"
CURRENT_DATA=$(netstat -ibn | grep -E "^$INTERFACE" | head -1 | awk '{print $7 " " $10}')
CURRENT_RX=$(echo $CURRENT_DATA | awk '{print $1}')
CURRENT_TX=$(echo $CURRENT_DATA | awk '{print $2}')
CURRENT_TIME=$(date +%s)

if [ -f "$CACHE_FILE" ]; then
    PREV_DATA=$(cat "$CACHE_FILE")
    PREV_RX=$(echo $PREV_DATA | awk '{print $1}')
    PREV_TX=$(echo $PREV_DATA | awk '{print $2}')
    PREV_TIME=$(echo $PREV_DATA | awk '{print $3}')

    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))

    if [ $TIME_DIFF -gt 0 ]; then
        RX_SPEED=$(( (CURRENT_RX - PREV_RX) / TIME_DIFF ))
        TX_SPEED=$(( (CURRENT_TX - PREV_TX) / TIME_DIFF ))

        format_speed() {
            local speed=$1
            if [ $speed -lt 1024 ]; then
                echo "${speed}B/s"
            elif [ $speed -lt 1048576 ]; then
                echo "$(( speed / 1024 ))KB/s"
            elif [ $speed -lt 1073741824 ]; then
                echo "$(( speed / 1048576 ))MB/s"
            else
                echo "$(( speed / 1073741824 ))GB/s"
            fi
        }

        RX=$(format_speed $RX_SPEED)
        TX=$(format_speed $TX_SPEED)

        sketchybar --set network_down label="$RX" \
                                      label.color="0xffc0caf5" \
                   --set network_up label="$TX" \
                                    label.color="0xffc0caf5"
    fi
else
    sketchybar --set network_down label="--" label.color="0xff565f89" \
               --set network_up label="--" label.color="0xff565f89"
fi

echo "$CURRENT_RX $CURRENT_TX $CURRENT_TIME" > "$CACHE_FILE"
