#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

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
    "fontconfig"
    "tmux"
    "wezterm"
    "yazi"
)

SYSTEM_DIRS=(
    "chrome-proxy-alpm-hook"
    "docker-service-proxy"
    "enable-drawio-plugins-alpm-hook"
)

SCRIPTS=(
    "frp-to-vps"
)

# 安装 $HOME 配置
install_home() {
    local category=$1
    cd home
    if [ -z "$category" ]; then
        echo -e "${BOLD}${BLUE}Installing all home configurations...${NC}"
        for dir in "${HOME_DIRS[@]}"; do
            echo -e "${GREEN}Installing $HOME/$dir configurations...${NC}"
            stow --restow -t $HOME $dir
        done
    else
        if [[ " ${HOME_DIRS[@]} " =~ " $category " ]]; then
            echo -e "${GREEN}Installing $HOME/$category configurations...${NC}"
            stow --restow -t $HOME $category
        else
            echo -e "${RED}Invalid $HOME category: $category${NC}"
            echo -e "${YELLOW}Available $HOME categories:${NC}"
            for dir in "${HOME_DIRS[@]}"; do
                echo -e "  ${CYAN}$dir${NC}"
            done
        fi
    fi
    cd ..
}

# 安装系统配置
install_system() {
    local category=$1
    # 检查root权限
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run with sudo for system configurations${NC}"
        exit 1
    fi
    
    cd system
    
    if [ -z "$category" ]; then
        # 不再默认安装所有配置，而是显示可用选项
        echo -e "${YELLOW}Please specify a category or use '${BOLD}all${NC}${YELLOW}' to install all configurations${NC}"
        echo -e "${YELLOW}Available system categories:${NC}"
        for dir in "${SYSTEM_DIRS[@]}"; do
            echo -e "  ${CYAN}$dir${NC}"
        done
    elif [ "$category" = "all" ]; then
        # 安装所有配置
        echo -e "${BOLD}${BLUE}Installing all system configurations...${NC}"
        for dir in "${SYSTEM_DIRS[@]}"; do
            echo -e "${GREEN}Installing system/$dir configurations...${NC}"
            stow --restow -t / $dir
        done
    else
        if [[ " ${SYSTEM_DIRS[@]} " =~ " $category " ]]; then
            echo -e "${GREEN}Installing system/$category configurations...${NC}"
            stow --restow -t / $category
        else
            echo -e "${RED}Invalid system category: $category${NC}"
            echo -e "${YELLOW}Available system categories:${NC}"
            for dir in "${SYSTEM_DIRS[@]}"; do
                echo -e "  ${CYAN}$dir${NC}"
            done
        fi
    fi
    
    cd ..
}

# 安装脚本
install_scripts() {
    local category=$1
    cd scripts

    if [ -z "$category" -o "$category" = "all" ]; then
        echo -e "${BOLD}${BLUE}Installing all scripts...${NC}"
        for script in "${SCRIPTS[@]}"; do
            echo -e "${GREEN}Installing script/$script...${NC}"
            stow --restow -t $HOME $script
        done
    else
        if [[ " ${SCRIPTS[@]} " =~ " $category " ]]; then
            echo -e "${GREEN}Installing script/$category...${NC}"
            stow --restow -t $HOME $category
        else
            echo -e "${RED}Invalid script category: $category${NC}"
            echo -e "${YELLOW}Available script categories:${NC}"
            for script in "${SCRIPTS[@]}"; do
                echo -e "  ${CYAN}$script${NC}"
            done
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
                echo -e "${BOLD}${BLUE}Cleaning all home configurations...${NC}"
                for dir in "${HOME_DIRS[@]}"; do
                    echo -e "${MAGENTA}Cleaning $HOME/$dir configurations...${NC}"
                    stow -D -t $HOME $dir
                done
            else
                if [[ " ${HOME_DIRS[@]} " =~ " $category " ]]; then
                    echo -e "${MAGENTA}Cleaning $HOME/$category configurations...${NC}"
                    stow -D -t $HOME $category
                else
                    echo -e "${RED}Invalid $HOME category: $category${NC}"
                    echo -e "${YELLOW}Available $HOME categories:${NC}"
                    for dir in "${HOME_DIRS[@]}"; do
                        echo -e "  ${CYAN}$dir${NC}"
                    done
                fi
            fi
            cd ..
            ;;
        "system")
            if [ "$EUID" -ne 0 ]; then 
                echo -e "${RED}Please run with sudo for system configurations${NC}"
                exit 1
            fi
            cd system
            if [ -z "$category" ]; then
                echo -e "${BOLD}${BLUE}Cleaning all system configurations...${NC}"
                for dir in "${SYSTEM_DIRS[@]}"; do
                    echo -e "${MAGENTA}Cleaning system/$dir configurations...${NC}"
                    stow -D -t / $dir
                done
            else
                if [[ " ${SYSTEM_DIRS[@]} " =~ " $category " ]]; then
                    echo -e "${MAGENTA}Cleaning system/$category configurations...${NC}"
                    stow -D -t / $category
                else
                    echo -e "${RED}Invalid system category: $category${NC}"
                    echo -e "${YELLOW}Available system categories:${NC}"
                    for dir in "${SYSTEM_DIRS[@]}"; do
                        echo -e "  ${CYAN}$dir${NC}"
                    done
                fi
            fi
            cd ..
            ;;
        "scripts")
            cd scripts
            if [ -z "$category" ]; then
                echo -e "${BOLD}${BLUE}Cleaning all scripts...${NC}"
                for script in "${SCRIPTS[@]}"; do
                    echo -e "${MAGENTA}Cleaning script/$script...${NC}"
                    stow -D -t $HOME/ $script
                done
            else
                if [[ " ${SCRIPTS[@]} " =~ " $category " ]]; then
                    echo -e "${MAGENTA}Cleaning script/$category...${NC}"
                    stow -D -t $HOME/ $category
                else
                    echo -e "${RED}Invalid script category: $category${NC}"
                    echo -e "${YELLOW}Available script categories:${NC}"
                    for script in "${SCRIPTS[@]}"; do
                        echo -e "  ${CYAN}$script${NC}"
                    done
                fi
            fi
            cd ..
            ;;
        *)
            echo -e "${RED}Invalid scope: $scope${NC}"
            echo -e "${YELLOW}Usage: $0 clean {home|system|scripts} [category]${NC}"
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
    "install-scripts")
        install_scripts "$2"
        ;;
    "clean")
        clean_configs "$2" "$3"
        ;;
    *)
        echo -e "${YELLOW}Usage: $0 {install-home|install-system|install-scripts|clean} [category]${NC}"
        echo -e "${BOLD}${BLUE}Home categories:${NC}"
        for dir in "${HOME_DIRS[@]}"; do
            echo -e "  ${CYAN}$dir${NC}"
        done
        echo -e "${BOLD}${BLUE}System categories:${NC}"
        for dir in "${SYSTEM_DIRS[@]}"; do
            echo -e "  ${CYAN}$dir${NC}"
        done
        echo -e "${BOLD}${BLUE}Script categories:${NC}"
        for script in "${SCRIPTS[@]}"; do
            echo -e "  ${CYAN}$script${NC}"
        done
        exit 1
        ;;
esac
