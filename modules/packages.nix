{pkgs, ...}: {
  # 所有「只給使用者 eric 用，不需要 system 全域」的套件集中在這裡
  home.packages = with pkgs; [
    # 基本 CLI / Nix 開發工具
    fastfetch
    btop
    eza
    fzf
    ripgrep
    unzip
    nil
    nixpkgs-fmt
    gh
    tree
    zig
    bat
    zoxide
    jq
    tldr
    fd
    dust
    duf
    curlie
    dogdns
    bandwhich
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
    nh
    statix
    deadnix

    # 桌面與 Wayland 工具
    rofi
    kitty
    waybar
    swww
    wl-clipboard
    mako
    hyprshot
    yazi
    broot
    prismlauncher
    bitwarden-desktop
    vesktop
    goverlay
    qtscrcpy

    # Shell / 歷史相關
    atuin
    carapace

    # GUI / 其他 app
    electron-mail
    gitkraken
    pavucontrol
    vscode

    # Nix / Git 輔助
    alejandra

    # 容器用戶端（後端在 system）
    podman

    # 字型（使用者層級）
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.hack
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    sarasa-gothic
    ibm-plex
    inter
    roboto
    fira-sans
    cascadia-code
    comic-neue
    lexend

    # IME / 輸入法相關
    fcitx5-rime
    rime-data

    # Qt / Kvantum 相關
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    (catppuccin-kvantum.override { variant = "mocha"; accent = "lavender"; })

    # 額外工具與 GUI / WM
    lact
    wlogout
    librsvg
    openbox
    obconf
    rename
    helix

    xwayland-satellite

  ];
}

