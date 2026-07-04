#!/bin/bash

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# if [ "$SENDER" = "front_app_switched" ]; then
#   sketchybar --set "$NAME" label="$INFO"
# fi
if [ "$SENDER" = "front_app_switched" ]; then
    app="$INFO"
else
    app=$(lsappinfo info -only name "$(lsappinfo front)" | sed -E 's/.*"([^"]+)".*/\1/')
fi

if [ -n "$app" ]; then
    sketchybar --set "$NAME" label="$app" icon=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app")
fi
