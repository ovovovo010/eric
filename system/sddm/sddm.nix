{pkgs, ...}: let
  # 修正警告：在 override 時明確指定系統架構名
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    # 這裡手動傳入正確的系統平台參數，避開舊版自動推導產生的警告
    stdenv = pkgs.stdenv;
    themeConfig = {
      # 確保圖片路徑正確轉換為字串
      Background = "${./mika-wallpaper.png}";

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
      MainColor = "#f5bde6";
      AccentColor = "#c6a0f6";
      BackgroundColor = "#24273a";
      InputBackground = "#363a4f";
      InputColor = "#cad3f5";
      PlaceholderColor = "#6e738d";
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "astronaut";
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qt5compat
    ];
  };
}
