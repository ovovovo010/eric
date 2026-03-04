# /etc/nixos/home/stylix.nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  # Stylix Home Manager 配置
  stylix = {
    enable = true;
    
    # 主題方案
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    
    # 字體配置
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    
    targets = {
      qt.enable = false;
      mako.enable = false;
      rofi.enable = false;
    };
  };

  # GTK 配置 (包含 icon theme)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Qt 配置
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Kvantum 配置
  home.file.".config/Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Kvantum
  '';

  # qt5ct 配置
  home.file.".config/qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=kvantum
    icon_theme=Papirus-Dark
    color_scheme=default
    
    [Fonts]
    general=Noto Sans,10,-1,5,50,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font Mono,10,-1,5,50,0,0,0,0,0
    
    [Interface]
    dialogs=default
    menubar=default
  '';

  # 確保 Qt 應用程式使用正確的環境變數
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
