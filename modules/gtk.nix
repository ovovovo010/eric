{ pkgs, lib, config, ... }:

{
  gtk = {
    enable = true;
    # iconTheme 由 stylix.iconTheme 統一管理，不要在這裡重複定義

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
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
