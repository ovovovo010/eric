{pkgs, ...}: {
  programs.niri = {
    enable = true;

    settings = {
      environment = {
        DISPLAY = ":0";
      };

      spawn-at-startup = [
        {command = ["fcitx5" "-d"];}
        {command = ["noctalia-shell"];}
      ];

      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
        };

        touchpad = {
          natural-scroll = false;
        };

        mouse = {
          accel-speed = -0.5;
        };
      };

      layout = {
        gaps = 5;

        preset-column-widths = [
          {proportion = 0.5;}
          {proportion = 0.7;}
          {proportion = 1.0;}
        ];
      };

      window-rules = [
        {
          matches = [{app-id = "linux-wallpaperengine";}];
          open-floating = true;
        }
      ];

      binds = {
        # terminal
        "Mod+Q".action.spawn = ["kitty"];

        # file manager
        "Mod+E".action.spawn = ["kitty" "-e" "yazi"];

        # launcher
        "Mod+R".action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];

        # close window
        "Mod+C".action.close-window = {};

        # floating
        "Mod+V".action.toggle-window-floating = {};

        # quit
        "Mod+M".action.quit = {};

        # focus
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};

        # workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;

        # screenshots (built-in)
        "Print".action.screenshot = {};
        "Mod+Print".action.screenshot-window = {};
      };
    };
  };
}
