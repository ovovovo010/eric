{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."xdg-terminals.list".text = ''
    kitty.desktop
  '';
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    # 基本行為設定
    extraConfig = {
      modi = ["drun" "run" "window" "ssh"];
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
      window-format = "[{w}] {c:20}";

      # 顯示選項
      hide-scrollbar = true;
      sidebar-mode = true;
      kb-cancel = "Escape";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        # === Catppuccin Mocha 配色 ===
        bg-main = mkLiteral "#1e1e2e";
        bg-alt = mkLiteral "#313244";
        bg-light = mkLiteral "#45475a";
        fg-main = mkLiteral "#cdd6f4";
        fg-alt = mkLiteral "#a6adc8";
        accent-blue = mkLiteral "#89b4fa";
        accent-pink = mkLiteral "#f38ba8";
        accent-teal = mkLiteral "#94e2d5";
        border = mkLiteral "#b4befe";

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
        width = mkLiteral "620px";
        height = mkLiteral "420px";
        padding = mkLiteral "@padding";
      };

      # === 主容器 ===
      "mainbox" = {
        background-color = mkLiteral "@bg-main";
        children = mkLiteral "[inputbar, listview, mode-switcher]";
        spacing = mkLiteral "8px";
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
        margin = mkLiteral "8px 8px 0px 8px";
      };

      "prompt" = {
        background-color = mkLiteral "@accent-blue";
        text-color = mkLiteral "@bg-main";
        padding = mkLiteral "6px 12px";
        border-radius = mkLiteral "6px";
        font = "JetBrains Mono Bold 12";
      };

      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-main";
        padding = mkLiteral "6px 0";
        placeholder-color = mkLiteral "@fg-alt";
      };

      # === 列表視圖 - 兩欄 ===
      "listview" = {
        background-color = mkLiteral "@bg-main";
        spacing = mkLiteral "4px";
        scrollbar = false;
        columns = 2;
        lines = 6;
        padding = mkLiteral "0px 8px";
        fixed-height = true;
        fixed-columns = true;
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
        font = "JetBrains Mono Bold 12";
      };

      # === 圖標與文本 ===
      "element-icon" = {
        size = mkLiteral "24px";
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
        margin = mkLiteral "0px 8px 8px 8px";
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
        margin = mkLiteral "8px";
      };

      "textbox" = {
        text-color = mkLiteral "@fg-main";
      };
    };
  };
}
