# cursor-editor.nix
{ config, pkgs, ... }:

let
  # 根據你的作業系統設定 Cursor 的配置路徑
  cursorConfigDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/Cursor/User"
    else
      ".config/Cursor/User";
in
{
  # 1. 安裝 Cursor 套件 (必須啟用 unfree)
  nixpkgs.config.allowUnfree = true; # 可以在這裡設定，或在你的 flake 中設定
  home.packages = with pkgs; [ code-cursor ];

  # 2. 如果你使用 nixGL 處理 GPU 問題 (主要 Linux 需要)
  # 先將 nixGL 加入套件
  home.packages = with pkgs; [
    code-cursor
    nixgl.auto.nixGLDefault  # 自動選擇適合的 nixGL wrapper
  ];

  # 3. 建立設定檔 (settings.json, keybindings.json 等)
  # 方法 A: 直接管理設定檔 (最推薦，完全由 Nix 控管)
  xdg.configFile = {
    # Linux 路徑會自動對應到 ~/.config/Cursor/User/settings.json
    # macOS 則需要手動指定目標路徑 (因為 xdg.configFile 在 macOS 行為不同)
    "Cursor/User/settings.json".text = builtins.toJSON {
      # 在這裡放你的 Cursor / VSCode 設定
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', monospace";
      "workbench.colorTheme" = "One Dark Pro";
      # ... 其他設定
      "telemetry.telemetryLevel" = "off";
      "window.titleBarStyle" = "custom";
      "editor.minimap.enabled" = false;
      "extensions.autoUpdate" = true;
      # 如果你要設定 Cursor 的 AI 相關功能
      "cursor.aiscanner" = false;
      "cursor.cpp.enablePartialAccepts" = true;
    };

    "Cursor/User/keybindings.json".text = builtins.toJSON [
      {
        "key" = "ctrl+shift+p";
        "command" = "workbench.action.showCommands";
      }
      # ... 你的快捷鍵設定
    ];
  };

  # 方法 B: 如果你偏好先手動設定，然後用 Home Manager 同步 VSCode 的設定過來
  # 可以參考 GitHub issue 中的 workaround [citation:2]
  # home.file.${cursorConfigDir}/settings.json".onChange = ''...''

  # 4. 自動安裝擴充功能 (進階選項)
  # 參照社群實作，可以寫一個 activationScript 來管理擴充功能 [citation:4]
  home.activation.installCursorExtensions = pkgs.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # 確保 Cursor CLI 存在
    if command -v cursor > /dev/null 2>&1; then
      # 這裡列出你想確保安裝的擴充功能 ID
      ${pkgs.lib.getExe pkgs.jq} -n '[
        "ms-python.python",
        "rust-lang.rust-analyzer",
        "mkhl.direnv",
        "jnoortheen.nix-ide",
        "github.copilot"
      ]' | while read extension; do
        echo "Installing/Updating extension: $extension"
        cursor --install-extension "$extension" --force
      done
    else
      echo "cursor command not found, skipping extension installation."
    fi
  '';

  # 5. 如果遇到 Electron 應用程式的 GPU 問題 (Linux)，可以用包裝器 [citation:3]
  # 建立一個名為 cursor 的包裝腳本，覆蓋原有的 cursor 指令
  home.packages = with pkgs; [
    (writeShellScriptBin "cursor" ''
      # 自動偵測並使用 nixGL 啟動 cursor
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGLDefault ${pkgs.code-cursor}/bin/cursor "$@"
    '')
  ];
}
