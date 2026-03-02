{
  inputs,
  pkgs,
  ...
}: {
  # 1. 解決 Stylix 的警告：明確告訴它 Profile 名字
  stylix.targets.firefox.profileNames = ["eric"];

  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages."${pkgs.system}".default;

    profiles.eric = {
      isDefault = true;

      settings = {
        "browser.download.dir" = "/home/eric/Downloads";
        "browser.download.folderList" = 1;
        "browser.download.useDownloadDir" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
        "extensions.pocket.enabled" = false;
      };
    };
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "zen";
    BROWSER = "zen";
  };
}
