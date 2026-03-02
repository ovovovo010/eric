{pkgs, ...}: {

  fonts.fontconfig.enable = true;  # 加這行
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    sarasa-gothic
    ibm-plex
    inter
    roboto
    fira-sans
    nerd-fonts.iosevka
    nerd-fonts.hack
    cascadia-code
    comic-neue
    lexend
  ];
}
