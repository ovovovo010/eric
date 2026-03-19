{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
    };
  };
  programs.hyprland = {
    enable = true;
  };
}
