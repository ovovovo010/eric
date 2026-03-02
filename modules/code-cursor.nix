{ config, pkgs, lib, ... }:

{
  # 允許安裝 unfree 套件（已在 flake 中全域啟用可省略）
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    code-cursor          # Cursor 編輯器本體
    jq                   # 供 activation 腳本解析擴充功能列表
  ];

  # 基礎設定檔，不包含任何顏色主題（避免與 stylix 衝突）
  xdg.configFile = {
    "Cursor/User/settings.json".text = builtins.toJSON {
      editor.fontSize = 14;
      editor.fontFamily = "'Fira Code', 'Droid Sans Mono', monospace";
      editor.minimap.enabled = false;
      editor.renderWhitespace = "boundary";
      files.autoSave = "afterDelay";
      telemetry.telemetryLevel = "off";
      window.titleBarStyle = "custom";
      extensions.autoUpdate = true;
      # 不要加入 workbench.colorTheme 等色彩設定
    };

    "Cursor/User/keybindings.json".text = builtins.toJSON [
      # 範例快捷鍵（可依個人習慣修改）
      {
        key = "ctrl+shift+p";
        command = "workbench.action.showCommands";
      }
      {
        key = "ctrl+,";
        command = "workbench.action.openSettings";
      }
    ];
  };

  # 自動安裝常用擴充功能（activation 階段執行）
  home.activation.installCursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${pkgs.code-cursor}/bin/cursor" ]; then
      echo "Installing Cursor extensions..."
      ${pkgs.jq}/bin/jq -n '[
        "ms-python.python",
        "rust-lang.rust-analyzer",
        "mkhl.direnv",
        "jnoortheen.nix-ide",
        "github.copilot",
        "eamodio.gitlens"
      ]' | while read extension; do
        echo "  Installing $extension"
        ${pkgs.code-cursor}/bin/cursor --install-extension "$extension" --force
      done
    else
      echo "cursor command not found, skipping extension installation."
    fi
  '';
}
