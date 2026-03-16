{ pkgs, ... }:
let
  # ─────────────────────────────────────────────
  #  壁紙影片路徑（絕對路徑，不進 Nix store）
  #  記得確認路徑存在，並執行過 chmod +x 的權限設定
  # ─────────────────────────────────────────────
  mika-video = "/home/eric/Pictures/Wallpapers/live/Mika_(swimsuit).mp4";

  # ─────────────────────────────────────────────
  #  Catppuccin Macchiato 色盤
  # ─────────────────────────────────────────────
  # Base      = "#24273a"   深底色
  # Mantle    = "#1e2030"   更深底色
  # Crust     = "#181926"   最深
  # Surface0  = "#363a4f"   輸入框底色
  # Surface1  = "#494d64"   較亮的表面
  # Overlay0  = "#6e738d"   placeholder / 弱文字
  # Text      = "#cad3f5"   主要文字
  # Subtext1  = "#b8c0e0"   次要文字
  # Pink      = "#f5bde6"   主色（登入按鈕、游標）
  # Mauve     = "#c6a0f6"   強調色
  # Lavender  = "#b7bdf8"   第三強調

  sddm-astronaut-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {

      # ── 背景 ──────────────────────────────────
      Video      = mika-video;
      Background = "";           # 使用影片時必須留空

      # ── 解析度 ────────────────────────────────
      ScreenWidth  = "2560";
      ScreenHeight = "1440";

      # ── 模糊效果（配合影片背景，不加模糊避免遮蓋畫面）──
      FullBlur          = "false";
      PartialBlur       = "true";   # 僅登入表單背後輕微模糊
      BlurRadius        = "32";     # 模糊半徑，可依喜好調整 20~60

      # ── 表單背景（半透明毛玻璃卡片）─────────────
      HaveFormBackground  = "true";
      FormBackground      = "#1e2030"; # Mantle，配合深底色
      FormBackgroundOpacity = "0.75";  # 75% 不透明，讓影片透出
      BackgroundOverlay   = "false";

      # ── 佈局 ──────────────────────────────────
      FormPosition        = "left";    # 表單靠左，留出右邊的影片視覺空間
      PasswordFieldOutlined = "true";  # 外框線風格，更現代

      # ── 字型 ──────────────────────────────────
      Font     = "JetBrainsMono Nerd Font";
      FontSize = "13";

      # ── 文字 ──────────────────────────────────
      HeaderText   = "";              # 不顯示標題文字
      DateFormat   = "dddd, MMMM d"; # 顯示：Monday, March 16
      TimeFormat   = "HH:mm";        # 24小時制

      # ── Catppuccin Macchiato 配色 ─────────────
      MainColor        = "#f5bde6";   # Pink  → 主要按鈕、游標
      AccentColor      = "#c6a0f6";   # Mauve → hover、選取狀態
      BackgroundColor  = "#24273a";   # Base  → 整體底色 fallback
      InputBackground  = "#363a4f";   # Surface0 → 輸入框底色
      InputColor       = "#cad3f5";   # Text  → 輸入文字顏色
      PlaceholderColor = "#6e738d";   # Overlay0 → placeholder 文字
      BorderColor      = "#494d64";   # Surface1 → 輸入框邊框

      # ── 圓角（讓卡片更柔和，符合你桌面風格）─────
      CornerRadius     = "12";

      # ── 圖示 ──────────────────────────────────
      # 如果 astronaut 主題支援自訂圖示，可在此指定
      # LoginIcon = ""; # 預設即可
    };
  };
in
{
  services.displayManager.sddm = {
    enable  = true;
    theme   = "astronaut";
    package = pkgs.kdePackages.sddm;

    wayland.enable = true;

    extraPackages = with pkgs; [
      # ── 主題本體（override 後的版本）─────────────
      sddm-astronaut-theme

      # ── Qt 必要元件 ──────────────────────────────
      kdePackages.qtmultimedia   # 影片播放必須
      kdePackages.qtsvg          # SVG 圖示
      kdePackages.qt5compat      # 相容層

      # ── GStreamer 影片解碼器 ──────────────────────
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad  # 額外編解碼器（mp4 有時需要）
      gst_all_1.gst-libav        # ffmpeg 後端，支援 h264/h265
    ];
  };

  # ── 修正主題路徑問題（讓 SDDM 找得到 override 後的主題）──
  environment.systemPackages = [ sddm-astronaut-theme ];

  # ─────────────────────────────────────────────────────────
  #  ⚠️  影片權限設定（只需執行一次）
  #  SDDM 以 sddm 使用者身分運行，必須能讀取影片路徑上的每個目錄
  #
  #  執行以下指令：
  #    chmod o+x /home/eric
  #    chmod o+x /home/eric/Pictures
  #    chmod o+x /home/eric/Pictures/Wallpapers
  #    chmod o+x /home/eric/Pictures/Wallpapers/live
  #    chmod o+r /home/eric/Pictures/Wallpapers/live/Mika_\(swimsuit\).mp4
  #
  #  或者更安全的方式，將影片複製到 /etc/sddm-bg/ 並設定權限：
  #    sudo mkdir -p /etc/sddm-bg
  #    sudo cp /home/eric/Pictures/Wallpapers/live/Mika_\(swimsuit\).mp4 /etc/sddm-bg/
  #    sudo chmod -R a+rX /etc/sddm-bg
  #  然後將 mika-video 路徑改為 "/etc/sddm-bg/Mika_(swimsuit).mp4"
  # ─────────────────────────────────────────────────────────
}
