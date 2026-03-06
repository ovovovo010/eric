{ config, pkgs, lib, ... }:
{
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar   = true;
        hide_cursor           = true;
        grace                 = 0;
        no_fade_in            = false;
        no_fade_out           = false;
        ignore_empty_input    = true;
      };

      # ── 背景：壁紙 + 模糊 ─────────────────────────────────────
      background = [
        {
          monitor     = "";
          path        = "${config.home.homeDirectory}/nixos-config/wallpaper.png";
          blur_passes = 3;
          blur_size   = 7;
          brightness  = 0.6;
          contrast    = 1.0;
          vibrancy    = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      # ── 時鐘 ──────────────────────────────────────────────────
      label = [
        # 大時鐘
        {
          monitor  = "";
          text     = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color    = "rgba(cdd6f4ff)";
          font_size   = 120;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 320";
          halign   = "center";
          valign   = "center";
          shadow_passes = 3;
          shadow_size   = 10;
          shadow_color  = "rgba(00000088)";
        }
        # 日期
        {
          monitor  = "";
          text     = ''cmd[update:60000] echo "$(date +"%Y年%m月%d日 %A")"'';
          color    = "rgba(a6adc8ff)";
          font_size   = 24;
          font_family = "Noto Sans CJK TC Medium";
          position = "0, 220";
          halign   = "center";
          valign   = "center";
          shadow_passes = 2;
          shadow_size   = 6;
          shadow_color  = "rgba(00000066)";
        }
      ];

      # ── 輸入圓圈 ──────────────────────────────────────────────
      input-field = [
        {
          monitor  = "";
          size     = "380, 80";
          position = "0, -200";
          halign   = "center";
          valign   = "center";

          # 圓角（設成高度一半 = 全圓形膠囊）
          rounding = 40;

          # 外框
          outer_color   = "rgba(b4befe88)";   # lavender 半透明
          inner_color   = "rgba(1e1e2ecc)";   # base 深色半透明
          font_color    = "rgba(cdd6f4ff)";   # text

          # 佔位字
          placeholder_text = ''<span foreground="##6c7086">  輸入密碼</span>'';
          font_family      = "JetBrainsMono Nerd Font";
          font_size        = 18;

          # 輸入中的點
          dots_size    = 0.35;
          dots_spacing = 0.2;
          dots_center  = true;
          dots_rounding = -1;   # 圓點

          # 狀態顏色
          check_color  = "rgba(89b4faff)";   # blue
          fail_color   = "rgba(f38ba8ff)";   # red
          capslock_color = "rgba(f9e2afff)"; # yellow

          # 外框發光效果
          fade_on_empty   = true;
          fade_timeout    = 1000;

          # 失敗訊息
          fail_text       = "$FAIL ($ATTEMPTS)";
          fail_transition = 300;
        }
      ];
    };
  };

  # 確保 hyprlock 有裝
  home.packages = with pkgs; [ hyprlock ];
}
