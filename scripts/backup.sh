#!/bin/zsh

source ./scripts//files.sh

for f in $FILES; do
	rsync -a --relative --delete $SRC/./$f/ $DST/
done

pacman -Qne | sort > $ARCHLINUX/pkg_native
pacman -Qm | sort > $ARCHLINUX/pkg_aur

git add .

if [ -n "$1" ]; then
	git commit -m "$1"
else
	git commit
fi

