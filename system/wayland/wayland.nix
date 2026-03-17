{
  pkgs,
  inputs,
  ...
}: {
  # --- [1. 解決你遇到的「真兇」：系統層級二進位檔案] ---
  # 這是你提到的關鍵：確保系統 PATH 裡真的有 Xwayland 這個程式
  programs.xwayland.enable = true;
}
