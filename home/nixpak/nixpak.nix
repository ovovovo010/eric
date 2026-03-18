# home/nixpak/nixpak.nix
{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  # ── 共用 helper ────────────────────────────────────────────────────────────

  # Wayland socket bind（runtime）
  waylandBinds = { sloth, ... }: [
    (sloth.concat [ (sloth.env "XDG_RUNTIME_DIR") "/wayland-1" ])
  ];

  # XDG portal + dconf（大多數 GUI 程式都需要）
  commonDbus = {
    "org.freedesktop.portal.Desktop"     = "talk";
    "org.freedesktop.portal.FileChooser" = "talk";
    "org.freedesktop.portal.OpenURI"     = "talk";
    "org.freedesktop.Notifications"      = "talk";
    "ca.desrt.dconf"                     = "talk";
  };

  # ── 各程式沙盒定義 ─────────────────────────────────────────────────────────

  sandboxed-zen = mkNixPak {
    config = { sloth, ... }: {
      app.package  = inputs.zen-browser.packages.${system}.default;
      app.binPath  = "bin/zen";
      flatpak.appId = "io.github.zen_browser.zen";

      dbus.enable   = true;
      dbus.policies = commonDbus // {
        "org.freedesktop.NetworkManager" = "talk";
        "org.mpris.MediaPlayer2.*"       = "talk";
      };

      bubblewrap = {
        network = true;
        bind.rw = [
          (sloth.concat [ sloth.homeDir "/.zen" ])
          (sloth.concat [ sloth.homeDir "/Downloads" ])
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          "/etc/ssl/certs"
          "/etc/resolv.conf"
          "/etc/hosts"
          (sloth.concat [ sloth.homeDir "/.config/fontconfig" ])
          (sloth.concat [ sloth.homeDir "/.local/share/fonts" ])
        ];
        bind.dev = [ "/dev/dri" ];    # GPU 加速
      };
    };
  };

  sandboxed-firefox = mkNixPak {
    config = { sloth, ... }: {
      app.package  = pkgs.firefox;
      app.binPath  = "bin/firefox";
      flatpak.appId = "org.mozilla.firefox";

      dbus.enable   = true;
      dbus.policies = commonDbus // {
        "org.freedesktop.NetworkManager" = "talk";
        "org.mpris.MediaPlayer2.*"       = "talk";
      };

      bubblewrap = {
        network = true;
        bind.rw = [
          (sloth.concat [ sloth.homeDir "/.mozilla" ])
          (sloth.concat [ sloth.homeDir "/Downloads" ])
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          "/etc/ssl/certs"
          "/etc/resolv.conf"
          "/etc/hosts"
          (sloth.concat [ sloth.homeDir "/.config/fontconfig" ])
          (sloth.concat [ sloth.homeDir "/.local/share/fonts" ])
        ];
        bind.dev = [ "/dev/dri" ];
      };
    };
  };

  sandboxed-spotify = mkNixPak {
    config = { sloth, ... }: {
      app.package  = pkgs.spotify;
      app.binPath  = "bin/spotify";
      flatpak.appId = "com.spotify.Client";

      dbus.enable   = true;
      dbus.policies = commonDbus // {
        "org.mpris.MediaPlayer2.spotify" = "own";
        "org.freedesktop.NetworkManager" = "talk";
      };

      bubblewrap = {
        network = true;
        bind.rw = [
          (sloth.concat [ sloth.homeDir "/.config/spotify" ])
          (sloth.concat [ sloth.homeDir "/.local/share/spotify" ])
          (sloth.concat [ sloth.homeDir "/.cache/spotify" ])
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          "/etc/ssl/certs"
          "/etc/resolv.conf"
          (sloth.concat [ sloth.homeDir "/.config/fontconfig" ])
        ];
        bind.dev = [ "/dev/dri" "/dev/snd" ];  # GPU + 音效
      };
    };
  };

  sandboxed-vesktop = mkNixPak {
    config = { sloth, ... }: {
      app.package  = pkgs.vesktop;
      app.binPath  = "bin/vesktop";
      flatpak.appId = "dev.vencord.Vesktop";

      dbus.enable   = true;
      dbus.policies = commonDbus // {
        "org.freedesktop.NetworkManager" = "talk";
        "org.mpris.MediaPlayer2.*"       = "talk";
      };

      bubblewrap = {
        network = true;
        bind.rw = [
          (sloth.concat [ sloth.homeDir "/.config/vesktop" ])
          (sloth.concat [ sloth.homeDir "/.config/discord" ])
          (sloth.concat [ sloth.homeDir "/.local/share/vesktop" ])
          (sloth.concat [ sloth.homeDir "/Downloads" ])
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          "/etc/ssl/certs"
          "/etc/resolv.conf"
          (sloth.concat [ sloth.homeDir "/.config/fontconfig" ])
        ];
        bind.dev = [ "/dev/dri" "/dev/snd" "/dev/video0" ];  # GPU + 音效 + 攝影機
      };
    };
  };

  sandboxed-mpv = mkNixPak {
    config = { sloth, ... }: {
      app.package  = pkgs.mpv;
      app.binPath  = "bin/mpv";
      flatpak.appId = "io.mpv.Mpv";

      dbus.enable   = true;
      dbus.policies = commonDbus // {
        "org.mpris.MediaPlayer2.mpv" = "own";
      };

      bubblewrap = {
        network = false;
        bind.rw = [
          (sloth.concat [ sloth.homeDir "/.config/mpv" ])
          (sloth.concat [ sloth.homeDir "/Videos" ])
          (sloth.concat [ sloth.homeDir "/Downloads" ])
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          (sloth.concat [ sloth.homeDir "/.config/fontconfig" ])
        ];
        bind.dev = [ "/dev/dri" "/dev/snd" ];
      };
    };
  };

in
{
  # ── 把沙盒包裝好的 binary 裝進 home ────────────────────────────────────────
  home.packages = [
    sandboxed-zen.config.env
    sandboxed-firefox.config.env
    sandboxed-spotify.config.env
    sandboxed-vesktop.config.env
    sandboxed-mpv.config.env
  ];
}
