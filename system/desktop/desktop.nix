{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      backend = "wayland";
    };
  };
  programs.hyprland = {
    enable = true;
  };
}
