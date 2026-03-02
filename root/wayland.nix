{ pkgs, ... }:

{
  # --- [1. 解決你遇到的「真兇」：系統層級二進位檔案] ---
  # 這是你提到的關鍵：確保系統 PATH 裡真的有 Xwayland 這個程式
  programs.xwayland.enable = true; 

  # --- [2. 核心合成器：Hyprland] ---
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # 讓 Hyprland 啟動時知道要掛載 XWayland 模組
  };

  # --- [6. 顯式安裝工具組] ---
  environment.systemPackages = with pkgs; [
    xwayland      # 再次確保 binary 存在
    xorg.xhost    # 用於處理 X11 權限 (例如讓 root 視窗顯示在 user 桌面)
    wl-clipboard  # Wayland 剪貼簿
    xclip         # X11 剪貼簿 (橋接兩者)
  ];
}

