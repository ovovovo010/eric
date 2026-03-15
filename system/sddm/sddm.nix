{pkgs, ...}: let
  # 使用字串定義絕對路徑，Nix 不會把影片搬進 store，也不會影響 Git
  # ⚠️ 請將「你的用戶名」替換成實際的名稱
  mika-video = "/home/eric/Pictures/Wallpapers/live/Mika_(swimsuit).mp4";

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      # --- 影片背景設定 ---
      Video = mika-video;
      Background = ""; # 播放影片時，Background 必須為空

      ScreenWidth = "2560";
      ScreenHeight = "1440";

      # --- 界面優化 ---
      FullBlur = "false";
      PartialBlur = "false";
      BlurRadius = "0";
      HaveFormBackground = "false";
      BackgroundOverlay = "false";

      # --- 佈局與配色 ---
      FormPosition = "left";
      Font = "JetBrainsMono Nerd Font";
      FontSize = "14";
      HeaderText = "";
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
    # 確保這裡的名稱與上面 override 的主題對應
    theme = "astronaut";
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;

    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qt5compat
      # 必備影片解碼器
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-libav
    ];
  };

  # 為了讓 SDDM 能讀取你家目錄的影片，必須解決權限問題
  # 最簡單的方法是將該影片所在的目錄權限改為全域可讀：
  # 執行指令：chmod +x /home/你的用戶名 /home/你的用戶名/Pictures /home/你的用戶名/Pictures/Wallpapers
}
