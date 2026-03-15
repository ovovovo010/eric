# root/sddm/sddm.nix
{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-mauve";
    package = pkgs.kdePackages.sddm;

    settings = {
      Theme = {
        Font = "JetBrainsMono Nerd Font";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "macchiato";
      font = "JetBrainsMono Nerd Font";
      fontSize = "12";
      background = ../stylix/mika-wallpaper.png;
      loginBackground = true;
    })
    bibata-cursors
  ];
}
