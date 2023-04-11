#!/bin/zsh

WORKSPACE='/home/rqdmap/dotfiles'
cd $WORKSPACE

rsync		--delete	~/.vimrc .
rsync -ah	--delete	~/.zsh .
rsync -ah	--delete	~/.config/nvim .
rsync -ah	--delete	~/.config/alacritty .
rsync		--delete	~/.config/starship.toml .
rsync -ah	--delete	~/.config/bspwm .
rsync -ah	--delete	~/.config/sxhkd .
rsync -ah	--delete	~/.config/polybar .
rsync -ah	--delete	~/.config/rofi .
rsync -ah	--delete	~/.config/ranger .
rsync -ah	--delete	~/.config/joshuto .

# Many config not used.
rsync -ah ~/.Xresources .

pacman -Qne | sort > pkg_native
pacman -Qm | sort > pkg_foreign

git add .
git commit -m '定时备份'
git push
