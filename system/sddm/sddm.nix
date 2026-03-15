{pkgs, ...}: let
  # Catppuccin Macchiato 配色
  # Base: #24273a  Surface: #363a4f  Overlay: #494d64
  # Pink: #f5bde6  Mauve: #c6a0f6   Text: #cad3f5
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      Background = ./mika-wallpaper.png;
      ScreenWidth = "2560";
      ScreenHeight = "1440";

      # 不遮背景
      FullBlur = "false";
      PartialBlur = "false";
      BlurRadius = "0";
      HaveFormBackground = "false";
      BackgroundOverlay = "false";

      # 登入框靠左
      FormPosition = "left";

      # 字體
      Font = "JetBrainsMono Nerd Font";
      FontSize = "14";
      HeaderText = "";

      # Catppuccin Macchiato Pink 配色
      MainColor = "#f5bde6"; # Pink — 主色、輸入框邊框
      AccentColor = "#c6a0f6"; # Mauve — 強調色、按鈕
      BackgroundColor = "#24273a"; # Base — 登入框背景
      InputBackground = "#363a4f"; # Surface — 輸入框背景
      InputColor = "#cad3f5"; # Text — 輸入文字
      PlaceholderColor = "#6e738d"; # Overlay2 — placeholder
      IconColor = "#f5bde6"; # Pink — 圖示
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = [
      sddm-astronaut
      pkgs.kdePackages.qtmultimedia
    ];
    settings = {
      Theme = {
        Font = "JetBrainsMono Nerd Font";
      };
    };
  };

  environment.systemPackages = [sddm-astronaut];
}
