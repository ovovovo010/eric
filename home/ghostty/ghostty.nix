# ~/nixos-config/ghostty.nix (或你存放 home-manager 設定的地方)
{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;

    settings = {
      # ══════════════════════════════════════════════════════════════════════
      #  1. 外觀排版 (好看 - 不含字體/顏色，由 Stylix 接管)
      # ══════════════════════════════════════════════════════════════════════

      # 增加內邊距 (Padding)，讓文字不要緊貼邊緣，視覺上會有呼吸感，非常提升質感
      window-padding-x = 12;
      window-padding-y = 12;

      # 隱藏原生的視窗標題列。因為你在用 Hyprland，隱藏標題列能讓終端機看起來更極簡、沉浸
      window-decoration = false;

      # 游標設定
      cursor-style = "block";
      cursor-style-blink = true;

      # ══════════════════════════════════════════════════════════════════════
      #  2. 實用功能 (好用)
      # ══════════════════════════════════════════════════════════════════════

      # 打字時自動隱藏滑鼠指標，避免擋住視線
      mouse-hide-while-typing = true;

      # 滑鼠反白選取後自動複製 (非常實用的 Linux 習慣)
      copy-on-select = true;

      # 關閉視窗或分頁時，不要彈出煩人的「確定要關閉嗎？」警告對話框
      confirm-close-surface = false;

      # 增加歷史滾動行數 (預設通常不夠用)
      scrollback-limit = 100000;

      # ══════════════════════════════════════════════════════════════════════
      #  3. 多工作業 (多工 - Tabs & Splits)
      # ══════════════════════════════════════════════════════════════════════

      # 自訂快捷鍵陣列 (Keybindings)
      # Ghostty 原生支援極快的 GPU 渲染分割視窗，我們可以設定得像 Tmux 一樣順手
      keybind = [
        # --- 分頁 (Tabs) 操作 ---
        "ctrl+t=new_tab" # 新增分頁
        "ctrl+w=close_surface" # 關閉目前分頁/分割視窗
        "shift+right=next_tab" # 切換到右邊分頁
        "shift+left=previous_tab" # 切換到左邊分頁

        # --- 視窗分割 (Splits) 操作 ---
        "ctrl+shift+d=new_split:right" # 向右分割視窗 (類似 VSCode 的邏輯)
        "ctrl+shift+s=new_split:down" # 向下分割視窗

        # --- 切換分割視窗焦點 (Focus) ---
        "alt+left=goto_split:left" # 焦點往左移
        "alt+right=goto_split:right" # 焦點往右移
        "alt+up=goto_split:up" # 焦點往上移
        "alt+down=goto_split:down" # 焦點往下移

        # --- 調整分割視窗大小 (Resize) ---
        "ctrl+shift+left=resize_split:left,10"
        "ctrl+shift+right=resize_split:right,10"
        "ctrl+shift+up=resize_split:up,10"
        "ctrl+shift+down=resize_split:down,10"
      ];
    };
  };
}
