# /etc/nixos/root/stylix.nix
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    enableReleaseChecks = false;

    # Catppuccin Macchiato — Pink accent
    base16Scheme = {
      base00 = "24273a"; # Base
      base01 = "1e2030"; # Mantle
      base02 = "363a4f"; # Surface0
      base03 = "494d64"; # Surface1
      base04 = "5b6078"; # Surface2
      base05 = "cad3f5"; # Text
      base06 = "f4dbd6"; # Rosewater
      base07 = "b7bdf8"; # Lavender
      base08 = "ed8796"; # Red
      base09 = "f5a97f"; # Peach
      base0A = "eed49f"; # Yellow
      base0B = "a6da95"; # Green
      base0C = "8bd5ca"; # Teal
      base0D = "8aadf4"; # Blue
      base0E = "f5bde6"; # Pink ← accent
      base0F = "c6a0f6"; # Mauve
    };

    polarity = "dark";

    image = ./mika-wallpaper.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    cursor = {
      name = "catppuccin-macchiato-pink-cursors";
      package = pkgs.catppuccin-cursors.macchiatoPink;
      size = 24;
    };
  };
}
