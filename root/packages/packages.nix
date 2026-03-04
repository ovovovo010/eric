{
  config,
  lib,
  pkgs,
  ...
}: {
  # 所有「需要 system 層級」的工具集中在這裡安裝
  # - 給登入管理、ZFS、容器、Steam runtime 等使用
  environment.systemPackages = with pkgs; [
    git

    # login / greeter 相關
    cage
    regreet

    # Wayland / X11 橋接與剪貼簿
    xwayland
    xorg.xhost
    wl-clipboard
    xclip

    # Steam / 遊戲相關（runtime / overlay / 調優）
    steam-run
    mangohud
    gamemode
    protonup-qt

    # 容器 / distrobox 相關
    distrobox
    podman
    podman-compose
    podman-tui
    dive

    # seatd / multi-seat 支援
    seatd

    # ZFS 工具
    zfs
    zfstools

    # 登入 shell（確保在全域可用）
    nushell
  ];
}
