#!/usr/bin/env zsh

# Rebuild config structure in ./config/
for f in $TARGETS; do
	rsync -a --relative --delete $SRC/./$f/ $DST/
done

pacman -Qne | sort > $ARCHLINUX/pkg_native
pacman -Qm | sort > $ARCHLINUX/pkg_aur

