# 与结尾的zprof一起工作, 用于性能分析
# zmodload zsh/zprof

export ZSH=$HOME/.zsh

zstyle :compinstall filename '$ZSH/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
autoload -Uz compinit
compinit

eval "$(dircolors)"
# 有时 dircolors 不起作用, 可以手动设置
# LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:';
# export LS_COLORS

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
alias diff='diff --color=auto'

alias vim='nvim'
alias del='trash'
alias his='history -i 0'
alias grep='rg'
#alias grep='grep --color=always'
alias h='his | rg'
alias top='htop'
alias jo='joshuto'

alias duu='du -d 1 -h | sort -hr'

function ra {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map q chain shell echo %d > "$tempfile"; quitall"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        pushd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

alias showpkg="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort"

# 稍微有一点硬编码的意思
alias activate="source ./venv/bin/activate"
alias mkvenv="python3 -m venv venv"

# git 字数检查
alias gitwa='git diff --word-diff=porcelain  | grep -e "^+[^+]" | wc -m | xargs'
alias gitwd='git diff --word-diff=porcelain  | grep -e "^-[^-]" | wc -m | xargs'
alias gitwdd='git diff --word-diff=porcelain | grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -m|xargs'
alias gitw='echo $(($(gitwa) - $(gitwd)))'


alias ssgs='cd ~/inject/SSGS && source venv/bin/activate && cd core'

alias logisim='_JAVA_AWT_WM_NONREPARENTING=1 nohup java -jar /home/rqdmap/Applications/Logisim-ITA.jar > /dev/null 2>&1 &!; exit'
alias mars='nohup mars-mips > /dev/null 2>&1 &!; exit'

export VISUAL="nvim"
export EDITOR="nvim"
export {http,https,ftp,socks}_proxy="http://127.0.0.1:7890"
export no_proxy="localhost,127.0.0.0/8,10.0.0.0/8"

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


# Add local bin to PATH
PATH=$PATH:$HOME/.local/bin

eval "$(starship init zsh)"

# 与开头的zprof模块一起工作
# zprof

