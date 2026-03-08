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
    nixpkgs-review
    nixos-anywhere
    nixos-generators
    nix-direnv
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
    zellij
    tealdeer
    jqp
    yq
    w3m
    lynx
    bottom
    lsof
    socat
    strace
    ltrace
    inotify-tools
    gdu
    colordiff
    meld
    aria2
    wget2
    age
    zbar

    # 桌面與 Wayland 工具
    rofi # 應用啟動器
    kitty
    waybar
    swww
    wl-clipboard
    mako
    hyprshot
    yazi
    nnn
    broot
    luaPackages.lgi

    # 系統控制工具
    pamixer # 音量控制
    blueman # 藍牙管理 GUI
    networkmanager # 網路管理（提供 nmcli）
    prismlauncher
    bitwarden-desktop
    vesktop
    goverlay
    hyperfine
    flamegraph
    networkmanagerapplet
    parted

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
    nix-prefetch-git
    nix-init
    nix-update
    nix-inspect # 互動式檢查 nixpkgs 屬性
    nix-melt # flake.lock 視覺化
    nvfetcher # 自動更新套件 source hash
    nurl # 從 URL 產生 nix fetcher
    nix-diff # 比較兩個 derivation 差異
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

    # Qt / Kvantum 相關 ⭐ 這裡已經很完整了
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      variant = "mocha";
      accent = "lavender";
    })

    # GTK 主題相關 ⭐ 新增
    gnome-themes-extra
    adwaita-qt

    # 額外工具與 GUI / WM
    lact
    wlogout
    librsvg
    rename
    helix
    imv
    ttygif
    chafa
    progress
    most

    xwayland-satellite

    # X11 / awesome 相關
    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    scrot
    feh
    picom
    dunst
    xclip

    # 主題相關 ⭐ 新增
    papirus-icon-theme # 圖標主題
    libsForQt5.qt5ct # Qt5 配置工具
    libsForQt5.qtstyleplugins # Qt5 風格插件

    # 額外字型 ⭐ 新增
    noto-fonts # Noto 字型家族
    noto-fonts-color-emoji # Noto 表情符號

    # 系統監控補充 ⭐ 新增
    nvtopPackages.nvidia

    # 編輯器補充 ⭐ 新增
    micro
    zed-editor
    # 網路工具補充 ⭐ 新增
    wireshark # 網路封包分析
    nmap # 網路掃描

    # 媒體相關 ⭐ 新增
    ffmpeg # 多媒體處理
    imagemagick # 圖片處理
    mpv # 影片播放器
    vlc # VLC 播放器

    # 壓縮工具補充 ⭐ 新增
    p7zip # 7zip 支援
    unrar # RAR 解壓縮
    zip # ZIP 壓縮

    # 虛擬化相關 ⭐ 新增
    quickemu # 快速建立虛擬機

    # AI 開發工具 ⭐ 新增
    python3Packages.torch # PyTorch（如果需要）
    python3Packages.tensorflow # TensorFlow（如果需要）
    ollama
  ];
}
