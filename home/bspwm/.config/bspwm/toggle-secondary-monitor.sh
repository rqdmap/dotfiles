#!/bin/bash

# 副屏切换脚本 - toggle-secondary-monitor.sh

# 导入显示器设置模块
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/monitor-setup.sh"

# 如果状态文件不存在，创建它并设置为"on"
if [ ! -f "$TOGGLE_FILE" ]; then
    echo "on" > "$TOGGLE_FILE"
fi

# 读取当前状态
CURRENT_STATE=$(cat "$TOGGLE_FILE")

# 切换副屏状态
if [ "$CURRENT_STATE" = "on" ]; then
    # 关闭副屏
    remove_secondary_monitor
    notify-send "副屏幕已关闭" -t 1500
else
    # 启用副屏
    enable_secondary_monitor
    notify-send "副屏幕已启用" -t 1500

    # 确保BSPWM监视器顺序正确
    bspc wm --reorder-monitors "$PRIMARY_MONITOR" "$SECONDARY_MONITOR"
fi

# 打印当前BSPWM监视器顺序 (调试用)
echo "当前BSPWM监视器顺序:"
bspc query -M --names

polybar_run

