# /etc/nixos/root/stylix.nix
{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    
    image = ../wallpaper.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}

