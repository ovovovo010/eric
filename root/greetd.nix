# /etc/nixos/root/greetd.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;

    settings.default_session = {
      command = lib.concatStringsSep " " [
        "${pkgs.cage}/bin/cage"
        "-s"
        "--"
        "${pkgs.regreet}/bin/regreet" # ← greetd.regreet 改成 regreet
      ];
      user = "greeter";
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
        font_name = lib.mkForce "JetBrainsMono Nerd Font Mono 11"; # ← 加 mkForce
      };
      commands = {
        reboot = ["systemctl" "reboot"];
        poweroff = ["systemctl" "poweroff"];
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };
  users.groups.greeter = {};

  environment.systemPackages = [pkgs.cage pkgs.regreet];

  systemd.services.greetd.serviceConfig = {
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYPath = "/dev/tty1";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
