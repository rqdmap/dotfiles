#!/usr/bin/env bash

sketchybar --set "$NAME" icon="" label="$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f%%\n", s}')"
