{pkgs, ...}: {
  home.packages = [ pkgs.niri pkgs.xwayland-satellite ];

  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
      touchpad {
        tap
        natural-scroll
      }
    }

    output "*" {
      scale 1.0
    }

    layout {
      gaps 16
      center-focused-column "never"
      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }
      default-column-width { proportion 0.5; }
      focus-ring {
        width 2
        active-color "#b4a0ff"
        inactive-color "#595959"
      }
      border {
        off
      }
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"
    spawn-at-startup "fcitx5" "-d"
    spawn-at-startup "swww-daemon"
    spawn-at-startup "swww" "img" "/etc/nixos/root/wallpaper.png"
    spawn-at-startup "mako"

    binds {
      Mod+T { spawn "kitty"; }
      Mod+E { spawn "kitty" "-e" "yazi"; }
      Mod+R { spawn "rofi" "-show" "drun"; }
      Mod+C { close-window; }

      Print { screenshot-screen; }
      Mod+Shift+S { screenshot; }
      Mod+Print { screenshot-window; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-up; }
      Mod+Down  { focus-window-down; }

      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+Up    { move-window-up; }
      Mod+Shift+Down  { move-window-down; }

      Mod+Minus       { set-column-width "-10%"; }
      Mod+Equal       { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+F           { maximize-column; }
      Mod+Shift+F     { fullscreen-window; }
      Mod+V           { toggle-window-floating; }
      Mod+O           { toggle-overview; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      Mod+Shift+E { quit; }
      Mod+Shift+Slash { show-hotkey-overlay; }
    }
  '';
}
