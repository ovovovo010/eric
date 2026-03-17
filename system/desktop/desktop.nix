{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.wayfire.enable = true;
  programs.dwl.enable = true;
}
