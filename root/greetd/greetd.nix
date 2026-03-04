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
        "${pkgs.regreet}/bin/regreet"
      ];
      user = "greeter";
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
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

  # cage/regreet 已在 root/packages.nix 安裝，這裡只負責服務與 session 設定

  # 讓 regreet 能找到所有 session 的 .desktop 檔
  environment.pathsToLink = [
    "/share/xsessions"
    "/share/wayland-sessions"
  ];

  systemd.services.greetd.serviceConfig = {
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYPath = "/dev/tty1";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
