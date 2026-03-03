{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    
    # --- 修正重點：改用 Mocha (深色) ---
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark"; # 這裡一定要改為 dark
    
    image = ./wallpaper.png;


    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

   iconTheme = {
     enable = true;
     package = pkgs.catppuccin-icon-theme;  # 官方 Catppuccin 圖標
     name = "Catppuccin-Mocha";  # 深色變體
    };
  };
}
