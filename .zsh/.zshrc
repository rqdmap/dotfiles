zmodload zsh/zprof

export ZSH=$HOME/.zsh

zstyle :compinstall filename '$ZSH/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
autoload -Uz compinit
compinit

eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


# zoxide: Rust-based cd command with autojump and z features
eval "$(zoxide init zsh)"

HISTFILE=$ZSH/.zsh_history
HISTSIZE=5000000
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

alias vim='nvim'
alias del='trash'
alias his='history -i 0'
alias grep='rg'
alias h='his | rg'
alias top='htop'
alias ra='ranger'
alias jo='joshuto'

alias showpkg="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort"
# 稍微有一点硬编码的意思
alias activate="source ./venv/bin/activate"
alias mkvenv="python3 -m venv venv"

alias duu="du -d 1 | sort -nr | awk '{system(\"bytes_to_size \" \$1); print(\$2);}'"

# git 字数检查
alias gitwa='git diff --word-diff=porcelain  | grep -e "^+[^+]" | wc -m | xargs'
alias gitwd='git diff --word-diff=porcelain  | grep -e "^-[^-]" | wc -m | xargs'
alias gitwdd='git diff --word-diff=porcelain | grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -m|xargs'
alias gitw='echo $(($(gitwa) - $(gitwd)))'


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

# Colorful less
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal

PATH=$PATH:$HOME/.local/bin


eval "$(starship init zsh)"

