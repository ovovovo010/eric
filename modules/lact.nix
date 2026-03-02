# lact.nix (Home Manager module)
# 適用於 NixOS 25.11 stable + Nvidia 顯卡
# 用法：在 home.nix 的 imports 加入此檔案路徑
#
# 注意：LACT 的 daemon 服務是 system-level 的，
# Home Manager 這邊主要負責安裝 GUI 套件與桌面整合。
# daemon 啟用請使用 lact-system.nix（NixOS module）。

{ config, pkgs, lib, ... }:

{
  # 安裝 LACT GUI 到使用者環境
  home.packages = with pkgs; [
    lact
  ];

  # 選項：加入桌面捷徑（LACT 套件本身已包含 .desktop 檔）
  # 若你的 HM 有設定 xdg，以下可確保捷徑正常出現
  xdg.enable = true;

  # 選項：autostart - 開機自動啟動 LACT GUI（daemon 已由 system service 管理）
  # 若不需要 GUI 自動開啟可移除此段
  xdg.configFile."autostart/lact.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=LACT
    Comment=GPU Configuration Tool
    Exec=lact gui
    Icon=lact
    Terminal=false
    Categories=System;HardwareSettings;
    X-GNOME-Autostart-enabled=false
  '';
}
