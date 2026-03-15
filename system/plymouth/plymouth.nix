{
  pkgs,
  lib,
  ...
}: {
  boot.plymouth = {
    enable = true;
    theme = lib.mkForce "catppuccin-mocha";
    themePackages = [pkgs.catppuccin-plymouth];
  };
}
