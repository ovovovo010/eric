{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services."wf-panel" = {
    Unit.Description = "Prevent wf-panel from starting";
    Service.ExecStart = "${pkgs.coreutils}/bin/true";
    Install.WantedBy = ["default.target"];
  };

  systemd.user.services."wayfire-shell" = {
    Unit.Description = "Prevent wayfire-shell from starting";
    Service.ExecStart = "${pkgs.coreutils}/bin/true";
    Install.WantedBy = ["default.target"];
  };
}
