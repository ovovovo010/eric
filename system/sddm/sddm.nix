{pkgs, ...}: let
  # 既然 sddm-astronaut 不接受 stdenv 參數，我們就移除它
  # 警告問題目前在 Nixpkgs 的該套件定義中是已知的，不影響系統構建
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      # 確保圖片能正確進入 /nix/store 且滿足字串要求
      Background = "${./mika-wallpaper.png}";

      ScreenWidth = "2560";
      ScreenHeight = "1440";

      # 不遮背景
      FullBlur = "false";
      PartialBlur = "false";
      BlurRadius = "0";
      HaveFormBackground = "false";
      BackgroundOverlay = "false";

      # 登入框位置與字體
      FormPosition = "left";
      Font = "JetBrainsMono Nerd Font";
      FontSize = "14";
      HeaderText = "";

      # Catppuccin Macchiato 配色
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
