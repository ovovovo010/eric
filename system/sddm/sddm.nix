{pkgs, ...}: let
  # Catppuccin Macchiato 配色
  # Base: #24273a  Surface: #363a4f  Overlay: #494d64
  # Pink: #f5bde6  Mauve: #c6a0f6   Text: #cad3f5
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      # 關鍵修正：移除引號，改用相對路徑。
      # Nix 會自動將 ~/nixos/system/sddm/mika-wallpaper.png 複製到全域可讀的 /nix/store 中
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
      kdePackages.qt5compat # 增加兼容性防止黑屏
    ];
  };
}
