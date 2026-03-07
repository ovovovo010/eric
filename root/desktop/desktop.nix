{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  services.windowManager.openbox.enable = true;
  services.windowManager.icewm.enable = true;
}
