#!/usr/bin/env bash
# 由 aerospace_workspace_change、front_app_switched 或定时任务触发
# 一次刷新全部 workspace 指示器，高亮聚焦项，普通色显示非空项，灰色显示空项

source "$CONFIG_DIR/colors.sh"

# 优先使用事件传入的 FOCUSED_WORKSPACE，其他触发方式实时查询
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# 非空工作区列表前后补空格以便整词匹配
nonempty=" $(aerospace list-workspaces --monitor all --empty no 2>/dev/null | tr '\n' ' ') "

for sid in 1 2 3 4 5 6 7 8 9 10 11; do
  if [ "$sid" = "$focused" ]; then
    sketchybar --set space.$sid background.drawing=on \
                                background.color=0x228ABEB7 \
                                background.border_color=0x448ABEB7 \
                                background.border_width=1 \
                                background.corner_radius=5 \
                                background.height=18 \
                                icon.color=0xffffffff
  elif [[ "$nonempty" == *" $sid "* ]]; then
    sketchybar --set space.$sid background.drawing=off icon.color="$foreground"
  else
    sketchybar --set space.$sid background.drawing=off icon.color="$disabled"
  fi
done
