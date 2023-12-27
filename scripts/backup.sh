#!/usr/bin/env zsh

# Rebuild config structure in ./config/
for f in $TARGETS; do
	rsync -a --relative --delete $SRC/./$f/ $DST/
done

