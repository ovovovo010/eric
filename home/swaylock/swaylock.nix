{ config, pkgs, lib, ... }:

let
  # 從 Stylix 獲取顏色變數 (帶 # 前綴)
  colors = config.lib.stylix.colors.withHashtag;
  
  # 建立 swaylock 設定檔
  swaylockConfig = pkgs.writeText "swaylock-config" ''
    # 一般設定
    ignore-empty-password
    show-failed-attempts
    hide-keyboard-layout
    
    # 時鐘顯示
    clock
    
    # 指示器大小
    indicator-idle-visible
    indicator-radius = 100
    indicator-thickness = 10
    
    # 顏色設定（從 Stylix 繼承）
    color = ${colors.base00}
    ring-color = ${colors.base03}
    key-hl-color = ${colors.base0D}
    line-color = ${colors.base00}
    inside-color = ${colors.base00}
    inside-clear-color = ${colors.base0A}
    inside-ver-color = ${colors.base0B}
    inside-wrong-color = ${colors.base08}
    text-color = ${colors.base05}
    text-clear-color = ${colors.base00}
    text-ver-color = ${colors.base00}
    text-wrong-color = ${colors.base00}
    bs-hl-color = ${colors.base08}
    ring-clear-color = ${colors.base0A}
    ring-ver-color = ${colors.base0B}
    ring-wrong-color = ${colors.base08}
    separator-color = ${colors.base02}
  '';
  
  # 建立一個包裝腳本，讓使用者可以選擇要用哪個鎖定工具
  lockScript = pkgs.writeShellScriptBin "lock" ''
    #!/bin/sh
    # 檢查使用者偏好的鎖定工具
    if command -v hyprlock > /dev/null 2>&1; then
      exec hyprlock
    elif command -v swaylock > /dev/null 2>&1; then
      exec swaylock
    else
      echo "錯誤：找不到任何鎖定工具 (hyprlock 或 swaylock)"
      exit 1
    fi
  '';
in
{
  # 注意：這是「可選」的！如果你不想裝 swaylock，就把這整個區塊註解掉
  programs.swaylock = {
    enable = true;  # 如果你設為 false，以下設定都不會生效
    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;
      hide-keyboard-layout = true;
      clock = true;
      indicator-idle-visible = true;
      indicator-radius = 100;
      indicator-thickness = 10;
      
      # 顏色設定（如果沒有 Stylix，會用這些預設值）
      color = lib.mkDefault colors.base00;
      ring-color = lib.mkDefault colors.base03;
      key-hl-color = lib.mkDefault colors.base0D;
      line-color = lib.mkDefault colors.base00;
      inside-color = lib.mkDefault colors.base00;
      inside-clear-color = lib.mkDefault colors.base0A;
      inside-ver-color = lib.mkDefault colors.base0B;
      inside-wrong-color = lib.mkDefault colors.base08;
      text-color = lib.mkDefault colors.base05;
      text-clear-color = lib.mkDefault colors.base00;
      text-ver-color = lib.mkDefault colors.base00;
      text-wrong-color = lib.mkDefault colors.base00;
      bs-hl-color = lib.mkDefault colors.base08;
      ring-clear-color = lib.mkDefault colors.base0A;
      ring-ver-color = lib.mkDefault colors.base0B;
      ring-wrong-color = lib.mkDefault colors.base08;
      separator-color = lib.mkDefault colors.base02;
    };
  };

  # swaylock 本體由 programs.swaylock.enable 提供
  # 這裡只安裝自製的 lockScript，其他套件由 modules/packages.nix 安裝
  home.packages = [
    lockScript
  ];

}
