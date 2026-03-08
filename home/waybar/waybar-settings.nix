{ config, pkgs, lib, iconDest, ... }:
{
  mainBar = {
    layer = "top";
    position = "top";
    # remove explicit height so bar auto-sizes
    # height = 30;  # Rick had 30, but autocalc is nicer
    margin-top = 4;    # small gap from ceiling
    margin-left = 4;
    margin-right = 4;
    margin-bottom = 1;
    spacing = 8;

    "modules-left" = [ "hyprland/workspaces" "custom/launcher" ];
    "modules-center" = [ "clock" "custom/notification" ];
    "modules-right" = [
      "privacy"
      "idle_inhibitor"
      "custom/clipboard"
      "pulseaudio"
      "backlight"
      "battery"
      "tray"
      "custom/power"
    ];

    # hyprland workspaces config, replacing niri from Rick
    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        default = "";
        active  = "";
      };
    };

    keyboard-state = {
      numlock = true;
      capslock = true;
      format = "{name} {icon}";
      format-icons = {
        locked = "";
        unlocked = "";
      };
    };

    mpris = {
      "player-icons" = { default = "🎵"; };
      format = "⏸ {dynamic}";
      "format-paused" = "▶ {dynamic}";
      "format-stopped" = "⏹ Stopped";
      interval = 1;
      "max-length" = 60;
    };

    "sway/mode" = { format = "<span style=\"italic\">{}</span>"; };

    "sway/scratchpad" = {
      format = "{icon} {count}";
      "show-empty" = false;
      "format-icons" = [ "" "" ];
      tooltip = true;
      "tooltip-format" = "{app}: {title}";
    };

    mpd = {
      format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
      "format-disconnected" = "Disconnected ";
      "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
      "unknown-tag" = "N/A";
      interval = 2;
      "consume-icons" = { on = " "; };
      "random-icons" = { off = "<span color=\"#f53c3c\"></span> "; on = " "; };
      "repeat-icons" = { on = " "; };
      "single-icons" = { on = "1 "; };
      "state-icons" = { paused = ""; playing = ""; };
      "tooltip-format" = "MPD (connected)";
      "tooltip-format-disconnected" = "MPD (disconnected)";
    };

    idle_inhibitor = {
      format = "{icon}";
      "format-icons" = { activated = " "; deactivated = " "; };
    };

    tray = {
      spacing = 10;
    };

    clock = {
      format = "󰥔 {:%R  󰃭 %A %d}";
      "tooltip-format" = "<tt><small>{calendar}</small></tt>";
      interval = 60;
    };

    cpu = {
      format = "{usage}% ";
      tooltip = false;
      interval = 60;
    };

    memory = { format = "{}% "; };

    temperature = {
      "critical-threshold" = 80;
      format = "{temperatureC}°C {icon}";
      "format-icons" = [ "" "" "" ];
    };

    backlight = {
      tooltip = false;
      format = "☀ {percent}%";
      "format-icons" = [
        "░░░░░░░░░░" "█░░░░░░░░░" "██░░░░░░░░" "███░░░░░░░" "████░░░░░░" "█████░░░░░" "██████░░░░" "███████░░░" "████████░░" "█████████░" "██████████"
      ];
      "on-scroll-up" = "brightnessctl set 2%+";
      "on-scroll-down" = "brightnessctl set 2%-";
    };

    battery = {
      states = { good = 80; warning = 40; critical = 20; };
      "format-charging" = "<b>↯ {capacity}%</b>";
      format = "{icon}  {capacity}%";
      "format-icons" = [ "" "" "" "" "" ];
      interval = 1;
    };
    "battery#bat2" = { bat = "BAT2"; };

    network = {
      "format-wifi" = "";
      "format-ethernet" = "{ipaddr}/{cidr} ";
      "tooltip-format" = "    {essid}({signalStrength}%)";
      "format-linked" = "{ifname} (No IP) ";
      "format-disconnected" = "⚠";
      "on-click" = "nmcli radio wifi on";
      "on-click-right" = "nmcli radio wifi off";
    };

    pulseaudio = {
      tooltip = false;
      format = "  {volume}%";
      "format-bluetooth" = " {volume}%";
      "format-bluetooth-muted" = " {volume}%";
      "format-muted" = "X {volume}%";
      "format-source" = "{volume}% ";
      "format-source-muted" = " ";
      "format-icons" = {
        headphone = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          "░░░░░░░░░░" "█░░░░░░░░░" "██░░░░░░░░" "███░░░░░░░" "████░░░░░░" "█████░░░░░" "██████░░░░" "███████░░░" "████████░░" "█████████░" "██████████"
        ];
      };
      interval = 60;
      "on-click" = "pamixer --toggle-mute";
      "on-scroll-up" = "pamixer --allow-boost --set-limit 150 --increase 2";
      "on-scroll-down" = "pamixer --allow-boost --set-limit 150 --decrease 2";
    };

    "custom/launcher" = {
      format = "<img src='${iconDest}' height='16'/>";
      on-click = "rofi -show drun";
      tooltip = false;
    };

    "custom/clipboard" = {
      format = "";
      on-click = "pgrep fuzzel && pkill fuzzel || $HOME/.config/niri/scripts/cliphist-fuzzel-img";
      tooltip-format = "Clipboard";
    };

    "custom/power" = {
      format = "";
      tooltip = false;
      on-click = "wlogout -c 15 -b 6 -m 400";
    };

    "custom/firefox" = { format = ""; on-click = "floorp"; };
    "custom/file" = { format = ""; on-click = "thunar"; };
    "custom/code" = { format = ""; on-click = "eclipse"; };
    "custom/terminal" = { format = ""; on-click = "kitty"; };
    "custom/mail" = { format = ""; on-click = "thunderbird"; };

    "custom/vkeyboard" = {
      format = " ";
      on-click = "pkill wvkbd-mobintl || wvkbd-mobintl --bg 1e1e2b --fg 313244 --fg-sp 313244";
      tooltip-format = "Virtual Keyboard";
    };

    "custom/media" = {
      format = "{icon} {}";
      "return-type" = "json";
      "max-length" = 40;
      "format-icons" = { spotify = ""; default = "🎜"; };
      escape = true;
      exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
    };

    "wlr/taskbar" = {
      format = "{icon}";
      "icon-size" = 22;
      "icon-theme" = "Numix-Circle";
      "tooltip-format" = "{title}";
      "on-click" = "activate";
      "on-click-middle" = "close";
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon}";
      "format-icons" = {
        notification = "\uF0A2<span foreground='#b7bdf8'><sup>\uF444</sup></span>";
        none = "\uF0A2 ";
        "dnd-notification" = "\uF1F7<span foreground='red'><sup>\uF444</sup></span>";
        "dnd-none" = "\uF1F7 ";
        "inhibited-notification" = "\uF0A2<span foreground='red'><sup>\uF444></sup></span>";
        "inhibited-none" = "\uF0A2 ";
        "dnd-inhibited-notification" = "\uF1F7<span foreground='red'><sup>\uF444</sup></span>";
        "dnd-inhibited-none" = "\uF1F7 ";
      };
      "return-type" = "json";
      "exec-if" = "which swaync-client";
      exec = "swaync-client -swb";
      "on-click" = "swaync-client -t -sw";
      "on-click-right" = "swaync-client -d -sw";
      escape = true;
    };

    privacy = {
      "icon-spacing" = 10;
      "icon-size" = 16;
      "transition-duration" = 250;
      modules = [
        { type = "screenshare"; tooltip = true; "tooltip-icon-size" = 24; }
        { type = "audio-out"; tooltip = true; "tooltip-icon-size" = 24; }
        { type = "audio-in"; tooltip = true; "tooltip-icon-size" = 24; }
      ];
      "ignore-monitor" = true;
      ignore = [ { type = "audio-in"; name = "cava"; } { type = "screenshare"; name = "obs"; } ];
    };
  };
}
