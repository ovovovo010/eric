{pkgs, ...}: let
  # 使用 "${...}" 語法將路徑強制轉換為字串，解決 generators 報錯
  # 這樣既能讓圖片進入 /nix/store (解決權限)，又能滿足主題對字串格式的要求
  mika-wallpaper = "${./system/sddm/mika-wallpaper.png}";

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      # 關鍵修正：使用轉換後的字串路徑
      Background = mika-wallpaper;

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
