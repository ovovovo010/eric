{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.niri.enable = true;
}
