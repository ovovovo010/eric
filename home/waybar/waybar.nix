{ pkgs, config, lib, ... }:
{
  home.file."waybar/nixos.png" = {
    source = ./nixos.png;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        margin-bottom = 0;
        spacing = 12;

        "modules-left" = [ "custom/launcher" "hyprland/workspaces" ];
        "modules-center" = [ "clock" ];
        "modules-right" = [
          "privacy"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "battery"
          "network"
          "tray"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
          };
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
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

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = [ "" "" ];
          tooltip = true;
          "tooltip-format" = "{app}: {title}";
        };

        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          "format-disconnected" = "Disconnected ";
          "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          "unknown-tag" = "N/A";
          interval = 2;
          "consume-icons" = { on = " "; };
          "random-icons" = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          "repeat-icons" = { on = " "; };
          "single-icons" = { on = "1 "; };
          "state-icons" = {
            paused = "";
            playing = "";
          };
          "tooltip-format" = "MPD (connected)";
          "tooltip-format-disconnected" = "MPD (disconnected)";
        };

        idle_inhibitor = {
          format = "{icon}";
          "format-icons" = {
            activated = " ";
            deactivated = " ";
          };
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
          format = "{usage}% ";
          tooltip = false;
          interval = 60;
        };

        memory = {
          format = "{}% ";
        };

        temperature = {
          "critical-threshold" = 80;
          format = "{temperatureC}°C {icon}";
          "format-icons" = [ "" "" "" ];
        };

        backlight = {
          tooltip = false;
          format = "☀ {percent}%";
          "format-icons" = [
            "░░░░░░░░░░"
            "█░░░░░░░░░"
            "██░░░░░░░░"
            "███░░░░░░░"
            "████░░░░░░"
            "█████░░░░░"
            "██████░░░░"
            "███████░░░"
            "████████░░"
            "█████████░"
            "██████████"
          ];
          "on-scroll-up" = "brightnessctl set 2%+";
          "on-scroll-down" = "brightnessctl set 2%-";
        };

        battery = {
          states = {
            good = 80;
            warning = 40;
            critical = 20;
          };
          "format-charging" = "<b>↯ {capacity}%</b>";
          format = "{icon}  {capacity}%";
          "format-icons" = [ "" "" "" "" "" ];
          interval = 1;
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        network = {
          "format-wifi" = "";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "    {essid}({signalStrength}%)";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "⚠";
          "on-click" = "nmcli radio wifi on";
          "on-click-right" = "nmcli radio wifi off";
        };

        pulseaudio = {
          tooltip = false;
          format = "{icon}{volume}%";
          "format-bluetooth" = "{icon}{volume}%";
          "format-bluetooth-muted" = "{icon}muted";
          "format-muted" = "{icon}muted";
          "format-source" = "{volume}%";
          "format-source-muted" = "muted";
          "format-icons" = {
            headphone = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          interval = 60;
          "on-click" = "pamixer --toggle-mute";
          "on-scroll-up" = "pamixer --allow-boost --set-limit 150 --increase 2";
          "on-scroll-down" = "pamixer --allow-boost --set-limit 150 --decrease 2";
        };

        "custom/launcher" = {
          format = "󱄅";
          "on-click" = "rofi -show drun";
          "tooltip-format" = "Launcher";
        };

        "custom/clipboard" = {
          format = "󱌢";
          "on-click" = "rofi -show clipboard";
          "tooltip-format" = "Clipboard";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          "on-click" = "wlogout -c 15 -b 6 -m 400";
        };

        "custom/firefox" = {
          format = "";
          "on-click" = "floorp";
        };

        "custom/file" = {
          format = "";
          "on-click" = "thunar";
        };

        "custom/code" = {
          format = "";
          "on-click" = "eclipse";
        };

        "custom/terminal" = {
          format = "";
          "on-click" = "kitty";
        };

        "custom/mail" = {
          format = "";
          "on-click" = "thunderbird";
        };

        "custom/vkeyboard" = {
          format = " ";
          "on-click" = "pkill wvkbd-mobintl || wvkbd-mobintl --bg 1e1e2b --fg 313244 --fg-sp 313244";
          "tooltip-format" = "Virtual Keyboard";
        };

        "custom/media" = {
          format = "{icon} {}";
          "return-type" = "json";
          "max-length" = 40;
          "format-icons" = {
            spotify = "";
            default = "🎜";
          };
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

        privacy = {
          "icon-spacing" = 10;
          "icon-size" = 16;
          "transition-duration" = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              "tooltip-icon-size" = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              "tooltip-icon-size" = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              "tooltip-icon-size" = 24;
            }
          ];
          "ignore-monitor" = true;
          ignore = [
            {
              type = "audio-in";
              name = "cava";
            }
            {
              type = "screenshare";
              name = "obs";
            }
          ];
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16px;
          color: #b4befe;
      }

      window#waybar {
          background-color: #1e1e2e;
          color: #cdd6f4;
          border: none;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #workspaces {
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 15px 0 15px;
      }

      window#waybar.termite {
          background-color: #3f3f3f;
      }

      window#waybar.chromium {
          background-color: #000000;
          border: none;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
      }

      #workspaces button {
          margin: 0 0px;
          padding: 0 0px;
          background-color: transparent;
          min-width: 20px;
      }

      #workspaces button:hover {
          background: transparent;
      }

      #workspaces button.active {
          font-weight: bold;
      }

      #workspaces button.urgent {
          color: #eb4d4b;
      }

      #mode {
          background-color: #64727d;
          border-bottom: 3px solid #ffffff;
      }

      #tray,
      #taskbar,
      #idle_inhibitor,
      #mpris,
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #privacy,
      #custom-media,
      #mode,
      #scratchpad,
      #mpd {
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 12px 0 12px;
      }

      #custom-vkeyboard {
          margin: 0px 0px 0px 0px;
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 12px 0 12px;
      }

      .modules-left>widget:first-child>#workspaces {
          margin-left: 0;
      }

      .modules-right>widget:last-child>#workspaces {
          margin-right: 0;
      }

      #custom-vkeyboard:hover,
      #idle_inhibitor:hover,
      #custom-power:hover,
      #custom-launcher:hover,
      #mpris:hover,
      #workspaces:hover,
      #privacy:hover,
      #tray:hover,
      #battery:hover,
      #custom-clipboard:hover,
      #battery.charging:hover,
      #pulseaudio:hover,
      #backlight:hover,
      #clock:hover {
          transition: all 0.3s ease-in;
          text-shadow: 0 0 2px #c9cdff;
      }

      #battery.charging,
      #battery.plugged {
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 10px 0 10px;
      }

      @keyframes blink {
          to {
              color: #f53c3c;
          }
      }

      #battery.critical:not(.charging) {
          color: #b4befe;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
          background-color: #1e1e2e;
      }

      #battery.warning:not(.charging) {
          color: orange;
          background-color: #1e1e2e;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }

      #memory {
          background-color: #9b59b6;
      }

      #disk {
          background-color: #964b00;
      }

      #network {
          padding: 7px;
      }

      #network.disconnected {
          color: #eb4d4b;
      }

      #pulseaudio.muted {
          color: #eb4d4b;
      }

      #wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }

      #wireplumber.muted {
          background-color: #f53c3c;
      }

      #custom-firefox {
          margin-left: 20px;
          margin-right: 10px;
      }

      #custom-file {
          margin-right: 10px;
      }

      #custom-terminal {
          margin-right: 10px;
      }

      #custom-mail {
          margin-right: 10px;
      }

      #custom-code {
          margin-right: 20px;
      }

      #custom-power {
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 15px 0 15px;
          font-size: 18px;
      }

      #custom-clipboard {
          font-family: "Font Awesome 6 Free";
          background-color: #1e1e2e;
          border-radius: 0px;
          padding: 0 12px 0 12px;
          font-size: 18px;
      }

      #custom-launcher {
          background-color: #1e1e2e;
          border-radius: 15px;
          padding: 0 12px 0 12px;
          font-size: 18px;
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray>.passive {
          -gtk-icon-effect: dim;
      }

      #tray>.needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state>label {
          padding: 0 5px;
      }

      #keyboard-state>label.locked {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
          background-color: transparent;
      }
    '';
  };
}
