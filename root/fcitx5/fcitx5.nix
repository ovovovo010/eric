{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-chinese-addons
      fcitx5-table-extra
      fcitx5-chewing
      fcitx5-lua
      catppuccin-fcitx5
      fcitx5-rime
      rime-data
    ];

    fcitx5.settings = {
      addons = {
        classicui.globalSection = {
          "Vertical Candidate List" = "True";
          "WheelForPaging" = "True";
          "Font" = "Sarasa Gothic TC 12";
          "MenuFont" = "Sarasa Gothic TC 12";
          "TrayFont" = "Sarasa Gothic TC Bold 10";
          "TrayOutlineColor" = "#000000";
          "TrayTextColor" = "#ffffff";
          "PreferTextIcon" = "False";
          "ShowLayoutNameInIcon" = "True";
          "UseInputMethodLanguageToDisplayText" = "True";
          "Theme" = "Catppuccin-Mocha-Lavender";
          "DarkTheme" = "Catppuccin-Mocha-Lavender";
          "UseDarkTheme" = "False";
          "FollowSystemDarkMode" = "False";
          "UseAccentColor" = "True";
        };
      };
    };
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
    SDL_IM_MODULE = "fcitx5";
    GLFW_IM_MODULE = "fcitx5";
  };
}
