{ pkgs, lib, ... }: {
  # Qt 配置
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
  
  stylix.targets.qt.enable = false;
}
