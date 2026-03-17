{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services.wf-panel.enable = false;
  systemd.user.services.wayfire-shell.enable = false;
  services.wayfire-shell.enable = lib.mkForce false;
}
