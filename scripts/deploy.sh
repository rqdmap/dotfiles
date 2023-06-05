#!/bin/zsh

source $(cd $(dirname $0); pwd)/files.sh


for f in $FILES; do
    if [ -e $SRC/$f ]; then
        read -p "Overwrite $SRC/$f? (y/n) " -n 1 answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            rm -rf $SRC/$f
        else
            continue
        fi
    fi
    ln -s $DST/$f $SRC/$f
done

