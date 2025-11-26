#!/bin/bash

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=""
  
  if [ -n "$apps" ] && [ "$apps" != "null" ]; then
    app_count=0
    max_apps=5
    
    while read -r app && [ $app_count -lt $max_apps ]; do
      if [ -n "$app" ] && [ "$app" != "null" ]; then
        app_icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
        icon_strip="${icon_strip} ${app_icon}"
        app_count=$((app_count + 1))
      fi
    done <<< "$apps"
    
    # 如果有应用图标，设置适当的 padding
    sketchybar --set "space.$space" label="$icon_strip" \
                                   label.padding_right=8 \
                                   label.padding_left=4
  else
    # 如果没有应用图标，移除 label 的 padding
    sketchybar --set "space.$space" label="" \
                                   label.padding_right=2 \
                                   label.padding_left=4
  fi
fi

