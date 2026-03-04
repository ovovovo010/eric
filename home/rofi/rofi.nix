{ config, pkgs, lib, ... }: {
  # 確保 Stylix 不會亂動 Rofi
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    # 基本行為設定
    extraConfig = {
      modi = "drun,run,window,ssh";
      icon-theme = "Papirus-Dark";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "  Apps";
      display-run = "  Run";
      display-window = "  Windows";
      display-ssh = "  SSH";
      
      # 性能優化
      max-history-size = 25;
      scroll-method = 0;
      normalize-match = true;
      
      # 定位與大小
      location = 0;
      width = 600;
      height = 600;
      window-format = "[{w}] {c:20}";
      
      # 顯示選項
      hide-scrollbar = true;
      sidebar-mode = false;
      kb-cancel = "Escape";
    };

    # Catppuccin Mocha 主題 - 優化版
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        # === Catppuccin Mocha 配色 ===
        bg-main = mkLiteral "#1e1e2e";      # 主背景
        bg-alt = mkLiteral "#313244";       # 替代背景
        bg-light = mkLiteral "#45475a";     # 亮色背景
        fg-main = mkLiteral "#cdd6f4";      # 主文本
        fg-alt = mkLiteral "#a6adc8";       # 替代文本
        accent-blue = mkLiteral "#89b4fa";  # 藍色強調
        accent-pink = mkLiteral "#f38ba8";  # 粉紅強調
        accent-teal = mkLiteral "#94e2d5";  # 青色強調
        border = mkLiteral "#b4befe";       # Lavender 邊框
        
        # === 字體 ===
        font = "JetBrains Mono 12";
        
        # === 尺寸 ===
        radius = mkLiteral "10px";
        padding = mkLiteral "8px";
      };

      # === 窗口樣式 ===
      "window" = {
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@border";
        background-color = mkLiteral "@bg-main";
        border-radius = mkLiteral "@radius";
        width = mkLiteral "600px";
        height = mkLiteral "600px";
        padding = mkLiteral "@padding";
      };

      # === 主容器 ===
      "mainbox" = {
        background-color = mkLiteral "@bg-main";
        spacing = mkLiteral "12px";
        padding = mkLiteral "0px";
      };

      # === 搜索欄 ===
      "inputbar" = {
        children = mkLiteral "[prompt, entry]";
        background-color = mkLiteral "@bg-alt";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "@accent-blue";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "6px 8px";
        spacing = mkLiteral "8px";
        margin = mkLiteral "12px";
      };

      "prompt" = {
        background-color = mkLiteral "@accent-blue";
        text-color = mkLiteral "@bg-main";
        padding = mkLiteral "6px 12px";
        border-radius = mkLiteral "6px";
        font = mkLiteral "JetBrains Mono Bold 12";
      };

      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-main";
        padding = mkLiteral "6px 0";
        placeholder-color = mkLiteral "@fg-alt";
      };

      # === 列表視圖 ===
      "listview" = {
        background-color = mkLiteral "@bg-main";
        spacing = mkLiteral "4px";
        scrollbar = mkLiteral "false";
        columns = 1;
        lines = 15;
        padding = mkLiteral "0px 12px";
      };

      # === 元素基本樣式 ===
      "element" = {
        padding = mkLiteral "8px 12px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg-alt";
        border-radius = mkLiteral "6px";
      };

      # === 選中元素 ===
      "element selected" = {
        background-color = mkLiteral "@accent-pink";
        text-color = mkLiteral "@bg-main";
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@accent-pink";
        border-radius = mkLiteral "6px";
        padding = mkLiteral "8px 10px";
        font = mkLiteral "JetBrains Mono Bold 12";
      };

      # === 圖標與文本 ===
      "element-icon" = {
        size = mkLiteral "32px";
        margin = mkLiteral "0px 8px 0px 0px";
      };

      "element-text" = {
        vertical-align = mkLiteral "0.5";
        text-color = mkLiteral "inherit";
      };

      # === 模式切換器 ===
      "mode-switcher" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "4px";
        margin = mkLiteral "0px 12px 12px 12px";
        spacing = mkLiteral "4px";
      };

      "button" = {
        text-color = mkLiteral "@fg-alt";
        padding = mkLiteral "4px 12px";
        border-radius = mkLiteral "4px";
        background-color = mkLiteral "@bg-main";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "@bg-light";
      };

      "button selected" = {
        background-color = mkLiteral "@accent-blue";
        text-color = mkLiteral "@bg-main";
        border-color = mkLiteral "@accent-blue";
      };

      # === 消息窗口 ===
      "message" = {
        background-color = mkLiteral "@bg-alt";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "@accent-blue";
        border-radius = mkLiteral "6px";
        padding = mkLiteral "8px 12px";
        margin = mkLiteral "12px";
      };

      "textbox" = {
        text-color = mkLiteral "@fg-main";
      };
    };
  };
}
