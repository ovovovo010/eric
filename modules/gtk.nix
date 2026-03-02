{ pkgs, lib, config, ... }:

{
  gtk = {
    enable = true;
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
    };
    
    # ⚠️ 這裡原本的 gtk3.extraCss 與 gtk4.extraCss 刪掉，改寫在下面 stylix.targets 裡
  };

  # --- 2026 修正：使用 Stylix 的 CSS 注入路徑 ---
  # 這能解決你剛才看到的 Warning，並確保 Rounding 20 生效
  stylix.targets.gtk.extraCss = ''
    /* GTK3 & GTK4 統一圓角修正 */
    window, 
    .main-window, 
    .background,
    window.csd,
    window.solid-csd {
      border-radius: 20px;
      overflow: hidden; /* 確保內容不超出大圓角 */
    }

    .titlebar, 
    headerbar {
      border-radius: 20px 20px 0 0;
    }

    /* 2026 大佬細節：讓選單也帶有圓角 */
    menu, 
    .popover {
      border-radius: 12px;
    }
  '';

  # 游標部分保持不變，lib.mkForce 是對的
  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
}
