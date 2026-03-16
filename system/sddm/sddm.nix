{pkgs, ...}: let
  # 強烈建議移到系統可讀路徑，避免家目錄權限麻煩
  mika-video = "/etc/sddm-bg/mika-video1.mp4";

  sddm-astronaut-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut"; # 或你想用的子主題如 black_hole 等
    themeConfig = {
      Video = mika-video;
      Background = ""; # 影片模式必留空
      ScreenWidth = "2560";
      ScreenHeight = "1440";
      FullBlur = "false";
      PartialBlur = "true";
      BlurRadius = "32";
      HaveFormBackground = "true";
      FormBackground = "#1e2030";
      FormBackgroundOpacity = "0.75";
      BackgroundOverlay = "false";
      FormPosition = "left";
      PasswordFieldOutlined = "true";
      Font = "JetBrainsMono Nerd Font";
      FontSize = "13";
      HeaderText = "";
      DateFormat = "dddd, MMMM d";
      TimeFormat = "HH:mm";
      MainColor = "#f5bde6"; # Pink
      AccentColor = "#c6a0f6"; # Mauve
      BackgroundColor = "#24273a";
      InputBackground = "#363a4f";
      InputColor = "#cad3f5";
      PlaceholderColor = "#6e738d";
      BorderColor = "#494d64";
      CornerRadius = "12";
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme"; # ← 這裡是關鍵修正！
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;

    extraPackages = with pkgs; [
      sddm-astronaut-theme
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qtbase
      kdePackages.qt5compat
      kdePackages.qtdeclarative
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];
  };

  environment.systemPackages = [sddm-astronaut-theme];
}
