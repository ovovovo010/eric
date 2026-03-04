#!/bin/bash
# 監聽 Hyprland 工作區變化並輸出 JSON

socat -U - UNIX-CONNECT:/run/user/1001/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock | while IFS= read -r line; do
  if [[ "$line" == *"workspace>>"* || "$line" == "openwindow>>"* || "$line" == "closewindow>>"* ]]; then
    # 獲取當前活動工作區
    active=$(hyprctl activewindow -j 2>/dev/null | jq '.workspace.id // 0')
    
    # 生成工作區陣列 (1-10)
    workspaces="["
    for i in {1..10}; do
      active_flag="false"
      [ "$i" = "$active" ] && active_flag="true"
      
      if [ $i -gt 1 ]; then
        workspaces="$workspaces,"
      fi
      workspaces="$workspaces{\"id\": \"$i\", \"active\": $active_flag}"
    done
    workspaces="$workspaces]"
    
    echo "$workspaces"
  fi
done
