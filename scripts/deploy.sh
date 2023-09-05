#!/usr/bin/env zsh

for f in $TARGETS; do
	if [ -e $SRC/$f ]; then
		echo -ne "\033[35m[Warning]\033[0m File or directory '$SRC/$f' exists! Override? (y/n) "
		read answer
		if [ -z "$answer" -o "${answer:0:1}x" = 'yx' -o "${answer:0:1}" = 'Yx' ]; then
			rm -rf $SRC/$f
		else
			continue
		fi
	else
		parent=$(dirname $f)
		if [ ! -d $SRC/$parent ]; then
			mkdir -p $SRC/$parent
		fi
	fi
    ln -s $DST/$f $SRC/$f

done

