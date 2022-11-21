#!/bin/zsh

rsync ~/.vimrc .
rsync -ah ~/.config/nvim .
rsync -ah ~/.config/alacritty .
rsync -ah ~/.zsh .
rsync ~/.config/starship.toml .
rsync -ah ~/.config/bspwm .
rsync -ah ~/.config/sxhkd .
rsync -ah ~/.config/polybar .
rsync -ah ~/.config/rofi .
rsync -ah ~/.config/ranger .

