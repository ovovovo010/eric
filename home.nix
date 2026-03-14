{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home/packages/packages.nix
    ./home/hyprland/hyprland.nix
    ./home/fonts/fonts.nix
    ./home/steam/steam.nix
    ./home/nushell/nushell.nix
    ./home/nushell/atuin.nix
    ./home/nushell/starship.nix
    ./home/rofi/rofi.nix
    ./home/mako/mako.nix
    ./home/zen/zen.nix
    ./home/fcitx5/fcitx5.nix
    ./home/nixvim/nixvim.nix
    ./home/kitty/kitty.nix
    ./home/zed/zed.nix
    ./home/wezterm/wezterm.nix
    ./home/qt/qt.nix
    ./home/gtk/gtk.nix
    ./home/spicetify/spicetify.nix
    ./home/obs/obs.nix
    ./home/lact/lact.nix
    ./home/wlogout/wlogout.nix
    ./home/hyprlock/hyprlock.nix
    ./home/yazi/yazi.nix
    ./home/stylix/stylix.nix
    ./home/stylix/blacklist.nix
    ./home/waybar/waybar.nix
    ./home/mpv/mpv.nix
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
