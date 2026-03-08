# root/sddm/sddm.nix
{ pkgs, ... }: {
  services.displayManager.sddm = {
    enable      = true;
    wayland.enable = true;
    theme       = "catppuccin-mocha";
    package     = pkgs.kdePackages.sddm;

    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize   = 24;
        Font         = "JetBrainsMono Nerd Font";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor  = "mocha";
      font    = "JetBrainsMono Nerd Font";
      fontSize = "12";
      background = ../wallpaper.png;
      loginBackground = true;
    })
    bibata-cursors
  ];
}
