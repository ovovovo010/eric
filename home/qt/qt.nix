{
  pkgs,
  lib,
  ...
}: {
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  stylix.targets.qt.enable = false;

  # 設定 Kvantum 使用 Catppuccin Mocha Lavender
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin-mocha-lavender
  '';
}
