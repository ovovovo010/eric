{pkgs, ...}: {
  home.packages = with pkgs; [
    fastfetch # 炫耀系統資訊用
    btop # 更美觀的資源監控
    eza # 現代化的 ls 替代品
    fzf # 模糊搜尋工具
    ripgrep # 極速文字搜尋 (rg)
    unzip # 解壓縮工具
    nil # Nix 語言伺服器 (給 nvim/vscode 用)
    nixpkgs-fmt # Nix 格式化工具
    gh # GitHub CLI
    tree # 顯示目錄樹
    rofi
    kitty
    waybar
    swww
    zig
    bat
    zoxide
    electron-mail
    hyprshot
    wl-clipboard
    mako
    gitkraken
    tldr
    prismlauncher
    atuin
    carapace
    broot
    yazi
    alejandra
    nvd
    nh
    statix
    deadnix
    pavucontrol
    vesktop
    fd
    dust
    duf
    curlie
    dogdns
    bandwhich
    jq
    tokei
    nix-output-monitor
    nvd
    nix-tree
    nix-du
    devenv
    comma
    lazygit
    tig
    difftastic
    onefetch
    git-graph
    podman
    bitwarden-desktop
    goverlay
    qtscrcpy
  ];
}
