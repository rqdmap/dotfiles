#!/bin/bash

# 获取CPU使用率
CPU_INFO=$(top -l 2 -n 0 -F | grep "CPU usage" | tail -1)
CPU_USER=$(echo "$CPU_INFO" | awk '{print $3}' | sed 's/%//')
CPU_SYS=$(echo "$CPU_INFO" | awk '{print $5}' | sed 's/%//')

# 计算总CPU使用率
CPU_TOTAL=$(echo "scale=1; $CPU_USER + $CPU_SYS" | bc)

# 获取负载平均值
LOAD_AVG=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | sed 's/,//')

# 根据CPU使用率设置颜色
CPU_INT=$(echo "$CPU_TOTAL" | cut -d. -f1)
if [ "$CPU_INT" -gt 80 ]; then
    COLOR="0xfff7768e"  # 红色
elif [ "$CPU_INT" -gt 60 ]; then
    COLOR="0xffe0af68"  # 黄色
elif [ "$CPU_INT" -gt 30 ]; then
    COLOR="0xff7aa2f7"  # 蓝色
else
    COLOR="0xff9ece6a"  # 绿色
fi

# 简洁显示
sketchybar --set cpu label="CPU ${CPU_TOTAL}%" \
                     label.color="$COLOR"

