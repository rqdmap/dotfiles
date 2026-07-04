#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sid="${NAME#space.}"
space_info="$(yabai -m query --spaces --space "$sid" 2>/dev/null)"
has_windows="false"

if [ -n "$space_info" ]; then
  if echo "$space_info" | jq -e '.windows | length > 0' >/dev/null 2>&1; then
    has_windows="true"
  fi
fi

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                          background.color=0x228ABEB7 \
                          background.border_color=0x448ABEB7 \
                          background.border_width=1 \
                          background.corner_radius=5 \
                          background.height=18 \
                          background.y_offset=0 \
                          icon.color=0xffffffff \
                          label.color=0xffffffff
elif [ "$has_windows" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=off \
                          icon.color="$foreground" \
                          label.color="$foreground"
else
  sketchybar --set "$NAME" background.drawing=off \
                          icon.color="$disabled" \
                          label.color="$disabled"
fi
