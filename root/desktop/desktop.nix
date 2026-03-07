{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
      ];
    };
  };
  programs.hyprland.enable = true;
}
