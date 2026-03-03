{ config, pkgs, lib, ... }:

let
  # 從 Stylix 獲取顏色變數
  colors = config.lib.stylix.colors.withHashtag;
  
  # 獲取圖標主題路徑（從 Stylix 設定）
  iconTheme = config.stylix.iconTheme;
  
  # 如果沒有設定圖標主題，提供一個 fallback（理論上你已經設定了）
  iconPath = if iconTheme?.package != null && iconTheme?.name != null
    then "${iconTheme.package}/share/icons/${iconTheme.name}"
    else "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita";
  
  # 定義按鈕佈局 - **修正為直接列表，不要外層 label**
  layout = [
    {
      name = "lock";
      text = "Lock";
      action = "lock";      # 使用 lock script
      keybind = "l";
    }
    {
      name = "logout";
      text = "Logout";
      action = "hyprctl dispatch exit";
      keybind = "e";
    }
    {
      name = "reboot";
      text = "Reboot";
      action = "systemctl reboot";
      keybind = "r";
    }
    {
      name = "shutdown";
      text = "Shutdown";
      action = "systemctl poweroff";
      keybind = "s";
    }
  ];
  
  # 建立 CSS 樣式
  styleCss = pkgs.writeText "wlogout-style.css" ''
    /* 從 Stylix 動態生成的顏色變數 */
    @define-color background ${colors.base00};
    @define-color background-alt ${colors.base01};
    @define-color foreground ${colors.base05};
    @define-color selected ${colors.base0D};
    @define-color border ${colors.base03};
    @define-color hover-bg ${colors.base02};
    @define-color text-color ${colors.base05};

    * {
      background-image: none;
      box-shadow: none;
    }

    window {
      background-color: alpha(@background, 0.85);
      backdrop-filter: blur(10px);
    }

    button {
      color: @text-color;
      background-color: alpha(@background-alt, 0.7);
      border-style: solid;
      border-width: 2px;
      border-color: @border;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      border-radius: 20px;
      margin: 20px;
      padding: 20px;
      font-family: "${config.stylix.fonts.sansSerif.name}";
      font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
      font-weight: normal;
      outline-style: none;
      transition: all 0.2s ease;
    }

    button:focus, button:active, button:hover {
      background-color: alpha(@selected, 0.3);
      border-color: @selected;
      color: @selected;
      background-size: 30%;
    }

    /* 使用你的 Catppuccin 圖標主題的圖標 */
    #lock {
      background-image: url("${iconPath}/symbolic/status/lockscreen-symbolic.svg");
    }

    #logout {
      background-image: url("${iconPath}/symbolic/actions/system-log-out-symbolic.svg");
    }

    #reboot {
      background-image: url("${iconPath}/symbolic/actions/system-reboot-symbolic.svg");
    }

    #shutdown {
      background-image: url("${iconPath}/symbolic/actions/system-shutdown-symbolic.svg");
    }
  '';
in
{
  # 安裝必要的套件
  home.packages = with pkgs; [
    wlogout
    librsvg  # 用於載入 SVG 圖標
  ];

  # lock script（如果還沒裝）
  home.file.".local/bin/lock" = {
    text = ''
      #!/bin/sh
      if command -v hyprlock > /dev/null 2>&1; then
        exec hyprlock
      elif command -v swaylock > /dev/null 2>&1; then
        exec swaylock
      else
        notify-send "錯誤" "找不到任何鎖定工具 (hyprlock 或 swaylock)"
        exit 1
      fi
    '';
    executable = true;
  };

  # 配置 wlogout
  programs.wlogout = {
    enable = true;
    layout = layout;   # 現在是直接列表，符合類型要求
    style = styleCss;
  };
}
