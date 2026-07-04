#!/bin/bash

source "$CONFIG_DIR/colors.sh"

spaces_info="$(yabai -m query --spaces 2>/dev/null)"

if [ -z "$spaces_info" ]; then
  exit 0
fi

while IFS=$'\t' read -r space has_focus has_windows; do
  if [ -z "$space" ]; then
    continue
  fi

  if [ "$has_focus" = "true" ]; then
    background_drawing=on
    background_color=0x228ABEB7
    border_color=0x448ABEB7
    border_width=1
    icon_color=0xffffffff
  elif [ "$has_windows" = "true" ]; then
    background_drawing=off
    background_color=0x00000000
    border_color=0x00000000
    border_width=0
    icon_color="$foreground"
  else
    background_drawing=off
    background_color=0x00000000
    border_color=0x00000000
    border_width=0
    icon_color="$disabled"
  fi

  sketchybar --set "space.$space" label="" label.drawing=off \
                              background.drawing="$background_drawing" \
                              background.height=18 \
                              background.corner_radius=5 \
                              background.color="$background_color" \
                              background.border_color="$border_color" \
                              background.border_width="$border_width" \
                              icon.color="$icon_color"
done < <(
  echo "$spaces_info" | jq -r '
    .[]
    | select(.index >= 1 and .index <= 10)
    | [.index, ."has-focus", ((.windows | length) > 0)]
    | @tsv
  '
)
