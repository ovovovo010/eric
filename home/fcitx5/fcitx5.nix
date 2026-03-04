{pkgs, ...}: {
  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=rime

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=rime
    Layout=

    [GroupOrder]
    0=Default
  '';

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Vertical Candidate List=True
    WheelForPaging=True
    Font=Sarasa Gothic TC 12
    MenuFont=Sarasa Gothic TC 12
    TrayFont=Sarasa Gothic TC Bold 10
    TrayOutlineColor=#000000
    TrayTextColor=#ffffff
    PreferTextIcon=False
    ShowLayoutNameInIcon=True
    UseInputMethodLanguageToDisplayText=True
    Theme=Catppuccin-Mocha-Lavender
    DarkTheme=Catppuccin-Mocha-Lavender
    UseDarkTheme=False
    FollowSystemDarkMode=False
    UseAccentColor=True
  '';

  # Rime 繁體拼音方案
  xdg.configFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: luna_pinyin
  '';
}
