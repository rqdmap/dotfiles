#!/bin/zsh

source $(cd $(dirname $0); pwd)/files.sh

for f in $FILES; do
	rsync -a --relative --delete $SRC/./$f/ $DST/
done
exit


pacman -Qne | sort > $ARCHLINUX/pkg_native
pacman -Qm | sort > $ARCHLINUX/pkg_aur

