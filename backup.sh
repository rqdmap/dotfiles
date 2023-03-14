#!/bin/zsh

WORKSPACE='/home/rqdmap/dotfiles'
cd $WORKSPACE

rsync ~/.vimrc .
rsync -ah ~/.zsh .
rsync -ah ~/.config/nvim .
rsync -ah ~/.config/alacritty .
rsync ~/.config/starship.toml .
rsync -ah ~/.config/bspwm .
rsync -ah ~/.config/sxhkd .
rsync -ah ~/.config/polybar .
rsync -ah ~/.config/rofi .
rsync -ah ~/.config/ranger .
rsync -ah ~/.config/joshuto .

# Many config not used.
rsync -ah ~/.Xresources .

pacman -Qne | sort > pkg_native
pacman -Qm | sort > pkg_foreign

git add .
git commit -m '定时备份'
git push
