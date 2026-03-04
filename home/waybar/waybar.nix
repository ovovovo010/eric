{ pkgs, config, lib, ... }:
{
  # 使用 Waybar 作為輕量頂部面板
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # 基礎配置，後續可根據需要調整模組
    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        # 左側顯示工作區與啟動器
        "modules-left" = [ "sway/workspaces" "custom/launcher" ];
        # 中間顯示模式或空白
        "modules-center" = [ "" ];
        # 右側顯示音量、網路、藍牙、時鐘
        "modules-right" = [ "pulseaudio" "network" "bluetooth" "clock" ];

        # 自訂 launcher 按鈕，點擊呼叫 rofi
        "custom/launcher" = {
          format = "󰣇";
          exec = "rofi -show drun";
          interval = 0;
        };

        # 修改每個模組的細節
        clock = { format = "%H:%M %a %d %b"; };
        pulseaudio = { format = " {volume}%"; };
        network = { format = "{essid}"; }; # 使用 nmcli 顯示 SSID
        bluetooth = { format = "{status}"; };
      };
    };

    # 簡單樣式，呼應 Catppuccin Mocha
    style = lib.concatStringsSep "\n" [
      "* { background: #1e1e2e; color: #cdd6f4; font-family: 'JetBrains Mono'; }"
      "#pulseaudio { background: transparent; }"
      "#network { background: transparent; }"
      "#bluetooth { background: transparent; }"
      "#clock { font-weight: bold; }"
      "#custom-launcher { padding: 0 6px; }"
    ];
  };
}
