{ config, pkgs, lib, ... }:

let
  # 從 Stylix 獲取顏色變數 (帶 # 前綴)
  colors = config.lib.stylix.colors.withHashtag;
  
  # 定義強調色，使用 Stylix 的 base0D
  accent-color = colors.base0D;
  
  # 定義按鈕佈局 - 直接寫成 Nix 值，不要用 writeText
  layout = {
    label = [
      {
        name = "lock";
        text = "Lock";
        action = "hyprlock";
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
  };
  
  # 建立 CSS 樣式
  styleCss = pkgs.writeText "wlogout-style.css" ''
    /* 從 Stylix 動態生成的顏色變數 */
    @define-color background ${colors.base00};
    @define-color background-alt ${colors.base01};
    @define-color foreground ${colors.base05};
    @define-color selected ${accent-color};
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

    /* 為各個按鈕設定圖標 */
    #lock {
      background-image: url("${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/status/lockscreen-symbolic.svg");
    }

    #logout {
      background-image: url("${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/actions/system-log-out-symbolic.svg");
    }

    #reboot {
      background-image: url("${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg");
    }

    #shutdown {
      background-image: url("${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg");
    }
  '';
in
{
  # 安裝必要的套件
  home.packages = with pkgs; [
    wlogout
    librsvg        # 用於載入 SVG 圖標
    gnome.adwaita-icon-theme  # 提供預設圖標
  ];

  # 配置 wlogout - 直接給值，不要用 writeText
  programs.wlogout = {
    enable = true;
    layout = layout;      # 直接給 Nix 值，不要用 derivation
    style = styleCss;     # style 接受 derivation 路徑
  };
}
