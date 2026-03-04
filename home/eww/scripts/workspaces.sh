#!/usr/bin/env bash
# Hyprland 工作區監聽器

socat -U - UNIX-CONNECT:/run/user/1001/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock | while IFS= read -r line; do
  if [[ "$line" == *"workspace>>"* ]]; then
    active=$(hyprctl activewindow -j 2>/dev/null | jq '.workspace.id // 1')
    
    # 生成工作區 JSON (1-10)
    workspaces="["
    for i in {1..10}; do
      active_flag="false"
      [ "$i" = "$active" ] && active_flag="true"
      
      if [ $i -gt 1 ]; then
        workspaces="$workspaces,"
      fi
      workspaces="$workspaces{\"id\": $i, \"active\": $active_flag}"
    done
    workspaces="$workspaces]"
    
    echo "$workspaces"
  fi
done
  fi
done
