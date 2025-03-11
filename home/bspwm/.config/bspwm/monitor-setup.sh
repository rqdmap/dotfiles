#!/bin/bash

# monitor-setup.sh - BSPWM显示器配置模块

# 显示器定义
PRIMARY_MONITOR="VGA-0"
PRIMARY_MODE="1920x1080"
PRIMARY_RATE="60.00"

SECONDARY_MONITOR="DVI-I-0"
SECONDARY_MODE="1920x1080"
SECONDARY_RATE="60.00"

# 初始化主显示器
setup_primary_monitor() {
    echo "设置主显示器: $PRIMARY_MONITOR"
    xrandr --output "$PRIMARY_MONITOR" --mode "$PRIMARY_MODE" --rate "$PRIMARY_RATE" --primary
    bspc monitor "$PRIMARY_MONITOR" -d I II III IV V VI VII VIII IX X
}

# 初始化副显示器
setup_secondary_monitor() {
    echo "设置副显示器: $SECONDARY_MONITOR"
    xrandr --output "$SECONDARY_MONITOR" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE" --left-of "$PRIMARY_MONITOR"
    bspc monitor "$SECONDARY_MONITOR" -d -

    # 确保显示器顺序正确
    bspc wm --reorder-monitors "$PRIMARY_MONITOR" "$SECONDARY_MONITOR"
}

# 移除副显示器
remove_secondary_monitor() {
    echo "移除副显示器: $SECONDARY_MONITOR"
    xrandr --output "$SECONDARY_MONITOR" --off
    bspc monitor "$SECONDARY_MONITOR" -r
}

# 启用副显示器
enable_secondary_monitor() {
    echo "启用副显示器: $SECONDARY_MONITOR"
    setup_secondary_monitor
    # 重要: 确保BSPWM监视器顺序正确
    bspc wm --reorder-monitors "$PRIMARY_MONITOR" "$SECONDARY_MONITOR"
}

# 检测并初始化显示器
detect_and_setup_monitors() {
    # 检查显示器连接状态
    PRIMARY_CONNECTED=$(xrandr | grep "$PRIMARY_MONITOR" | grep -w "connected")
    SECONDARY_CONNECTED=$(xrandr | grep "$SECONDARY_MONITOR" | grep -w "connected")

    # 根据连接状态设置显示器
    if [[ -n "$PRIMARY_CONNECTED" ]]; then
        setup_primary_monitor

        if [[ -n "$SECONDARY_CONNECTED" ]]; then
            setup_secondary_monitor
        fi
    elif [[ -n "$SECONDARY_CONNECTED" ]]; then
        # 如果只有副显示器连接，则将其设置为主显示器
        xrandr --output "$SECONDARY_MONITOR" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE" --primary
        bspc monitor "$SECONDARY_MONITOR" -d I II III IV V VI VII VIII IX X
    else
        echo "没有检测到显示器！"
    fi
}

# 如果直接执行此脚本，运行初始化
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    detect_and_setup_monitors
fi
