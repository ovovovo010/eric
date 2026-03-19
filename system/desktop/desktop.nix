{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
    };
    windowManager.bspwm = {
      enable = true;
    };
  };
  programs.hyprland = {
    enable = true;
  };
}
