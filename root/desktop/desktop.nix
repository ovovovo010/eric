{ pkgs, ... }: {
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  services.xserver.windowManager.openbox.enable = true;
  services.xserver.windowManager.icewm.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}
