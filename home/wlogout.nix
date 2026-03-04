{ config, pkgs, lib, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
  
  # 安全地獲取圖標主題路徑
  iconThemePath = 
    if config.stylix ? iconTheme && config.stylix.iconTheme ? enable && config.stylix.iconTheme.enable 
    then "${config.stylix.iconTheme.package}/share/icons/${config.stylix.iconTheme.dark}"
    else "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";  # 這裡修改了！

  layout = [
    {
      label = "lock";
      text = "Lock";
      action = "sh -c 'if command -v hyprlock >/dev/null; then hyprlock; elif command -v swaylock >/dev/null; then swaylock; fi'";
      keybind = "l";
    }
    {
      label = "logout";
      text = "Logout";
      action = "hyprctl dispatch exit";
      keybind = "e";
    }
    {
      label = "reboot";
      text = "Reboot";
      action = "systemctl reboot";
      keybind = "r";
    }
    {
      label = "shutdown";
      text = "Shutdown";
      action = "systemctl poweroff";
      keybind = "s";
    }
  ];

  styleCss = pkgs.writeText "wlogout-style.css" ''
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

    #lock {
      background-image: url("${iconThemePath}/symbolic/status/lockscreen-symbolic.svg");
    }

    #logout {
      background-image: url("${iconThemePath}/symbolic/actions/system-log-out-symbolic.svg");
    }

    #reboot {
      background-image: url("${iconThemePath}/symbolic/actions/system-reboot-symbolic.svg");
    }

    #shutdown {
      background-image: url("${iconThemePath}/symbolic/actions/system-shutdown-symbolic.svg");
    }
  '';
in
{
  home.file.".local/bin/lock" = {
    text = ''
      #!/bin/sh
      if command -v hyprlock > /dev/null 2>&1; then
        exec hyprlock
      elif command -v swaylock > /dev/null 2>&1; then
        exec swaylock
      else
        notify-send "錯誤" "找不到任何鎖定工具"
        exit 1
      fi
    '';
    executable = true;
  };

  programs.wlogout = {
    enable = true;
    layout = layout;
    style = styleCss;
  };
}
