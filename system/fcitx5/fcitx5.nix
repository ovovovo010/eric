{pkgs, ...}: {
  environment.pathsToLink = ["/share/fcitx5"];

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
          "Theme" = "Catppuccin-Mocha"; # 试试这个
        };
      };
    };
  };
}
