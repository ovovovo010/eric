# /etc/nixos/home/stylix.nix
{ config, pkgs, lib, inputs, ... }:

{
  # 注意：系統層級 (root/stylix.nix) 已經設定了 stylix 主題和字體
  # 這裡只做 home-specific 的配置

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
  };
}
