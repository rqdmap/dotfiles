#!/bin/bash

# 获取网络接口（通常是 en0 或 en1）
INTERFACE=$(route get default | grep interface | awk '{print $2}')

# 如果没有找到默认接口，尝试常见的接口名
if [ -z "$INTERFACE" ]; then
    for iface in en0 en1 en2; do
        if ifconfig "$iface" 2>/dev/null | grep -q "inet "; then
            INTERFACE="$iface"
            break
        fi
    done
fi

# 如果还是没找到，退出
if [ -z "$INTERFACE" ]; then
    sketchybar --set network label="No Network"
    exit 1
fi

# 获取当前网络统计
get_bytes() {
    netstat -ibn | grep -E "^$INTERFACE" | head -1 | awk '{print $7 " " $10}'
}

# 读取之前的数据
CACHE_FILE="/tmp/sketchybar_network_cache"
CURRENT_DATA=$(get_bytes)
CURRENT_RX=$(echo $CURRENT_DATA | awk '{print $1}')
CURRENT_TX=$(echo $CURRENT_DATA | awk '{print $2}')
CURRENT_TIME=$(date +%s)

if [ -f "$CACHE_FILE" ]; then
    PREV_DATA=$(cat "$CACHE_FILE")
    PREV_RX=$(echo $PREV_DATA | awk '{print $1}')
    PREV_TX=$(echo $PREV_DATA | awk '{print $2}')
    PREV_TIME=$(echo $PREV_DATA | awk '{print $3}')
    
    # 计算时间差
    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
    
    if [ $TIME_DIFF -gt 0 ]; then
        # 计算速度 (bytes per second)
        RX_SPEED=$(( (CURRENT_RX - PREV_RX) / TIME_DIFF ))
        TX_SPEED=$(( (CURRENT_TX - PREV_TX) / TIME_DIFF ))
        
        # 转换为人类可读格式
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
        
        RX_FORMATTED=$(format_speed $RX_SPEED)
        TX_FORMATTED=$(format_speed $TX_SPEED)
        
        # 更新显示
        sketchybar --set network label="↓${RX_FORMATTED} ↑${TX_FORMATTED}"
    else
        sketchybar --set network label="Calculating..."
    fi
else
    sketchybar --set network label="Initializing..."
fi

# 保存当前数据
echo "$CURRENT_RX $CURRENT_TX $CURRENT_TIME" > "$CACHE_FILE"

