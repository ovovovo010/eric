{pkgs, ...}: {
  security.polkit.enable = true;

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Authentication Agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/lib/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
