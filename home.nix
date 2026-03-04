{pkgs, inputs, ...}: {
  imports = [
    ./modules/packages.nix
    ./modules/hyprland.nix
    ./modules/fonts.nix
    ./modules/steam.nix
    ./modules/nushell.nix
    ./modules/rofi.nix
    ./modules/mako.nix
    ./modules/zen.nix
    ./modules/neovim.nix
    ./modules/cursor.nix
    ./modules/kitty.nix
    ./modules/qt.nix
    ./modules/gtk.nix
    ./modules/spicetify.nix
    ./modules/eww.nix
    ./modules/obs.nix
    ./modules/lact.nix
    ./modules/fcitx5.nix
    ./modules/openbox.nix
    ./modules/wlogout.nix
    ./modules/swaylock.nix
  ];

  home.username = "eric";
  home.homeDirectory = "/home/eric";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    FLAKE = "/home/eric/nixos-config";
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
