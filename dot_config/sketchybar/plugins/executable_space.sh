#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                          background.color="$alert" \
                          background.corner_radius=5 \
                          background.height=22 \
                          icon.color=0xff000000 \
                          label.color=0xff000000
else
  sketchybar --set "$NAME" background.drawing=off \
                          icon.color=0xffffffff \
                          label.color=0xffffffff
fi

