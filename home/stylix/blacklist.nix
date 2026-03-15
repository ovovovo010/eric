{...}: {
  # 禁用 Stylix 對特定程式的主題控制
  # 通常是因為該程式有自訂主題，或 Stylix 的設定會造成衝突

  stylix.targets = {
    # ── 編輯器 ────────────────────────────────────────────────
    vscode.enable = false; # 由 home/vscode/vscode.nix 自行管理
    nixvim.enable = false; # 由 home/nixvim/nixvim.nix 自行管理（catppuccin）

    # ── 啟動器 / Bar ──────────────────────────────────────────
    rofi.enable = false; # 由 home/rofi/rofi.nix 自行管理
    waybar.enable = false; # 由 home/waybar/waybar.nix 自行管理

    # ── 其他 ──────────────────────────────────────────────────
    hyprlock.enable = false; # 由 home/hyprlock/hyprlock.nix 自行管理
    brave.enable = false;
  };
}
