{ pkgs, lib, ... }:

{
  # 這裡是在 Home Manager 內
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "kvantum"; 
    style.name = lib.mkForce "kvantum";
  };

  # 確保 Stylix 的 HM target 不會亂動
  stylix.targets.qt.enable = lib.mkForce true; 

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    (catppuccin-kvantum.override { variant = "mocha"; accent = "lavender"; })
  ];
}
