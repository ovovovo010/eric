{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  programs.hyprland = {
    enable = true;
  };
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };
}
