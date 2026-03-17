{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  services.xserver.windowManager.i3 = true;
  services.xserver.windowManager.dwm = true;
  programs.hyprland.enable = true;
}
