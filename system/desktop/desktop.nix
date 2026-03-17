{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  services.xserver.windowManager.i3 = true;
  programs.hyprland.enable = true;
}
