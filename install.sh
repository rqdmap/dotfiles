#!/bin/bash

# 配置数组
HOME_DIRS=(
    "alacritty"
    "bash"
    "bspwm"
    "htop"
    "joshuto"
    "nvim"
    "picom"
    "polybar"
    "rime"
    "rofi"
    "starship"
    "sxhkd"
    "zathura"
    "zsh"
)

SYSTEM_DIRS=(
    "common"
    "archlinux"
)

# 安装 $HOME 配置
install_home() {
    local category=$1
    cd home
    if [ -z "$category" ]; then
        for dir in "${HOME_DIRS[@]}"; do
            echo "Installing $HOME/$dir configurations..."
            stow --restow -t $HOME $dir
        done
    else
        if [[ " ${HOME_DIRS[@]} " =~ " $category " ]]; then
            echo "Installing $HOME/$category configurations..."
            stow --restow -t $HOME $category
        else
            echo "Invalid $HOME category: $category"
            echo "Available $HOME categories: ${HOME_DIRS[@]}"
        fi
    fi
    cd ..
}

# 安装系统配置
install_system() {
    local category=$1
    # 检查root权限
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run with sudo for system configurations"
        exit 1
    fi

    cd system
    if [ -z "$category" ]; then
        # 安装通用配置
        echo "Installing system/common configurations..."
        stow --restow -t / common

        # 在Arch Linux上安装特定配置
        if [ -f /etc/arch-release ]; then
            echo "Installing system/arch configurations..."
            stow --restow -t / archlinux
        fi
    else
        if [[ " ${SYSTEM_DIRS[@]} " =~ " $category " ]]; then
            echo "Installing system/$category configurations..."
            stow --restow -t / $category
        else
            echo "Invalid system category: $category"
            echo "Available system categories: ${SYSTEM_DIRS[@]}"
        fi
    fi
    cd ..
}

# 清理配置
clean_configs() {
    local scope=$1
    local category=$2

    case "$scope" in
        "home")
            cd home
            if [ -z "$category" ]; then
                for dir in "${HOME_DIRS[@]}"; do
                    echo "Cleaning $HOME/$dir configurations..."
                    stow -D -t $HOME $dir
                done
            else
                stow -D -t $HOME $category
            fi
            cd ..
            ;;
        "system")
            if [ "$EUID" -ne 0 ]; then 
                echo "Please run with sudo for system configurations"
                exit 1
            fi
            cd system
            if [ -z "$category" ]; then
                for dir in "${SYSTEM_DIRS[@]}"; do
                    echo "Cleaning system/$dir configurations..."
                    stow -D -t / $dir
                done
            else
                stow -D -t / $category
            fi
            cd ..
            ;;
        *)
            echo "Invalid scope: $scope"
            echo "Usage: $0 clean {home|system} [category]"
            exit 1
            ;;
    esac
}

# 命令行参数处理
case "$1" in
    "install-home")
        install_home "$2"
        ;;
    "install-system")
        install_system "$2"
        ;;
    "clean")
        clean_configs "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {install-home|install-system|clean} [category]"
        echo "Home categories: ${HOME_DIRS[@]}"
        echo "System categories: ${SYSTEM_DIRS[@]}"
        exit 1
        ;;
esac
