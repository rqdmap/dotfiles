#!/bin/zsh

source ./scripts//files.sh

for f in $FILES; do
	rsync -a --relative --delete $SRC/./$f/ $DST/
done

pacman -Qne | sort > $ARCHLINUX/pkg_native
pacman -Qm | sort > $ARCHLINUX/pkg_aur


git diff 

echo -ne "\033[35m[backup]\033[0m Commit changes? (y/n) "
read answer

if [ -z "$answer" -o "${answer:0:1}x" = 'yx' -o "${answer:0:1}" = 'Yx' ]; then

	git add .

	if [ -n "$1" ]; then
		git commit -m "$1"
	else
		git commit
	fi
fi





