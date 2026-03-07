{ pkgs, lib, config, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name    = lib.mkForce "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name    = lib.mkForce "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
    };
  };

  # 設定預設應用程式 (.desktop 檔)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.mkForce {
      # 文字編輯器 - 所有文本檔案都用 nvim
      "text/plain" = "nvim.desktop";
      "text/x-shellscript" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/xml" = "nvim.desktop";
      "text/x-c" = "nvim.desktop";
      "text/x-c++" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/x-nix" = "nvim.desktop";
      
      # 瀏覽器
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  stylix.targets.gtk.extraCss = ''
    /* GTK3 & GTK4 統一圓角修正 */
    window, 
    .main-window, 
    .background,
    window.csd,
    window.solid-csd {
      border-radius: 20px;
      overflow: hidden;
    }

    .titlebar, 
    headerbar {
      border-radius: 20px 20px 0 0;
    }

    menu, 
    .popover {
      border-radius: 12px;
    }
  '';

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
}
