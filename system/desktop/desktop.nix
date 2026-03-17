{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  programs.wayfire.enable = true;
  programs.hyprland.enable = true;
}
