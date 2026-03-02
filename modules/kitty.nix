{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    # 鼠、字、色交給 Stylix，我們負責「形」

    settings = {
      # --- 2026 大佬級 Tab 設計 (這才是精華) ---
      tab_bar_edge              = "top";
      tab_bar_style             = "custom";      # 配合 2026 kitty 協議
      tab_bar_min_tabs          = 2;
      tab_activity_symbol       = "   ";
      tab_separator             = "";            # 移除難看的分隔線
      # 使用特殊符號營造膠囊感 (Capsule look)，這非常有設計感
      tab_title_template        = " {index}: {title} ";
      active_tab_title_template = "  {title} "; 

      # --- 視窗細節 (佈局美學) ---
      window_padding_width      = "12 20";       # 上下 12 左右 20，黃金比例不空洞
      confirm_os_window_close   = 0;
      placement_strategy        = "center";
      
      # --- 渲染與文字排版 (大佬會調行高) ---
      modify_font_underline_position = -2;
      modify_font_underline_thickness = "150%";
      modify_font_baseline_position = 0;
      # 增加一點行高 (120%)，讓文字有呼吸空間，不擁擠
      modify_font = "cell_height 120%";

      # --- 互動感 ---
      mouse_hide_wait           = "2.0";
      url_style                 = "double";      # 雙下線連結，細節控必備
      open_url_with             = "default";
      copy_on_select            = "yes";         # 選取即複製，實用主義

    };

    # 搬運自大佬的快捷操作：分頁與排版控制
    keybindings = {
      "ctrl+shift+t"      = "new_tab_with_cwd";
      "ctrl+shift+enter"  = "launch --cwd=current --type=os-window";
      "ctrl+shift+right"  = "next_tab";
      "ctrl+shift+left"   = "previous_tab";
      "ctrl+shift+alt+t"  = "set_tab_title";     # 讓你可以手動命名分頁，爽度很高
    };
  };
}
