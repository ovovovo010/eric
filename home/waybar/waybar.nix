{ pkgs, config, lib, ... }:
let
  # copy the nixos icon from the library into the user's waybar config
  iconSource = ../library/nixos-wallpaper-catppuccin-macchiato.png;
  iconDest = "${config.home.homeDirectory}/.config/waybar/nixos.png";
in
{
  # exporting a file ensures the icon ends up in ~/.config/waybar
  home.file."waybar/nixos.png" = {
    source = iconSource;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # import the big JSON-derived settings from a separate nix file
    settings = import ./waybar-settings.nix { inherit config pkgs lib iconDest; };

    style = ''
      /* keep the nice catppuccin theme from before */
      * {
        font-family: 'JetBrains Mono', monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: alpha(#1e1e2e, 0.92);
        color: #cdd6f4;
        border-radius: 12px;
        border: 1px solid #313244;
      }

      /* workspace buttons look the same as before */
      #workspaces button { padding: 0 7px; color: #6c7086; background: transparent; border-radius: 6px; transition: all 0.15s ease; }
      #workspaces button.active { color: #cba6f7; background: #313244; }
      #workspaces button.urgent { color: #f38ba8; }
      #workspaces button:hover { color: #cdd6f4; background: #45475a; }

      /* launcher icon styling */
      #custom-launcher { color: #cba6f7; padding: 0 10px; font-size: 16px; }
      #custom-launcher:hover { color: #f5c2e7; }

      #clock { color: #89b4fa; font-weight: bold; padding: 0 14px; }
      #pulseaudio, #network, #bluetooth, #tray { padding: 0 9px; background: transparent; }
      #pulseaudio { color: #a6e3a1; }
      #pulseaudio.muted { color: #6c7086; }
      #network { color: #89dceb; }
      #network.disconnected { color: #f38ba8; }
      #bluetooth { color: #89b4fa; }
      #bluetooth.off { color: #6c7086; }
      #tray { padding: 0 6px; }
      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; background-color: #f38ba8; border-radius: 4px; }
    '';
  };
}
