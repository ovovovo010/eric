{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };
  programs.wayfire.enable = true;
}
