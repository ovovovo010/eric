# code-cursor.nix
{ config, pkgs, lib, ... }:   # ← 加入 lib

let
  cursorConfigDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/Cursor/User"
    else
      ".config/Cursor/User";
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    code-cursor
    nixgl.auto.nixGLDefault
    (writeShellScriptBin "cursor" ''
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGLDefault ${pkgs.code-cursor}/bin/cursor "$@"
    '')
  ];

  xdg.configFile = {
    "Cursor/User/settings.json".text = builtins.toJSON {
      editor.fontSize = 14;
      # 其他設定...
    };
    "Cursor/User/keybindings.json".text = builtins.toJSON [];
  };

  home.activation.installCursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''  # ← 使用 lib.hm.dag
    if [ -x "${pkgs.code-cursor}/bin/cursor" ]; then
      ${pkgs.jq}/bin/jq -n '[
        "ms-python.python",
        "rust-lang.rust-analyzer",
        "mkhl.direnv",
        "jnoortheen.nix-ide"
      ]' | while read extension; do
        ${pkgs.code-cursor}/bin/cursor --install-extension "$extension" --force
      done
    fi
  '';
}
