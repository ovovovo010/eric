# root/sddm/sddm.nix
{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-macchiato-pink";
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
      accent = "pink";
      font = "JetBrainsMono Nerd Font";
      fontSize = "12";
      background = ../stylix/mika-wallpaper.png;
      loginBackground = true;
    })
  ];
}
