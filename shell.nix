{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # 這些是開發環境中可用的套件
  buildInputs = with pkgs; [
    neovim
    git
    home-manager
    nix-output-monitor
    nvd
    nh # 另一個好用的 nix cli
  ];

  # shell 載入時的歡迎訊息
  shellHook = ''
    echo -e "\033[1;36m=========================================\033[0m"
    echo -e "\033[1;32m 🚀 NixOS 設定檔開發環境載入完成！\033[0m"
    echo -e "\033[1;33m 你可以使用這個 Shell 來執行 hm 或 nixos 相關工具。\033[0m"
    echo -e "\033[1;36m=========================================\033[0m"
  '';
}
