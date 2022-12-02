zmodload zsh/zprof

export ZSH=$HOME/.zsh

zstyle :compinstall filename '$ZSH/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
autoload -Uz compinit
compinit

eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

HISTFILE=$ZSH/.zsh_history
HISTSIZE=1000
SAVEHIST=5000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
# 加上时间戳, 不然history无法正确显示时间
setopt EXTENDED_HISTORY
setopt RM_STAR_SILENT

bindkey -e
bindkey "\e[3~" delete-char

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias vim='nvim'
alias del='trash'
alias his='history -i 0'
alias h='his | grep '

alias showpkg="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort"

export VISUAL="nvim"
export EDITOR="nvim"
export {http,https,ftp,socks}_proxy="http://127.0.0.1:7890"
export no_proxy="localhost,127.0.0.0/8,10.0.0.0/8"
export BLOG="/home/rqdmap/hugo-blog/content"

# 为journalctl-less设置标记
export SYSTEMD_LESS=FRXMK
export LESSCHARSET=utf-8

# 24hours format
export LC_TIME=C.UTF-8


# 启用Node nvm
# source /usr/share/nvm/init-nvm.sh

# Plugins
source $ZSH/plugins/z-1.9/z.sh

eval "$(starship init zsh)"

