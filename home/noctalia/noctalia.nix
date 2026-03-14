{inputs, pkgs, ...}: {
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        position = "top";
        density = "compact";
        floating = true;          # 漂浮感，不貼平螢幕邊緣
        marginVertical = 10;      # 上方留空
        marginHorizontal = 20;    # 左右縮短，長條狀
        frameThickness = 6;
        frameRadius = 16;         # 圓角
        outerCorners = true;
        backgroundOpacity = 0.85;
        showCapsule = true;
        capsuleOpacity = 1.0;
        fontScale = 1.3;          # 2K 放大字體
        widgetSpacing = 8;
        contentPadding = 4;
        displayMode = "always_visible";
        showOnWorkspaceSwitch = true;

        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "ActiveWindow";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Volume";
            }
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      colorSchemes.predefinedScheme = "Catppuccin Mocha";

      general = {
        avatarImage = "/home/eric/.face";
        radiusRatio = 0.3;
      };

      location = {
        monthBeforeDay = false;
        name = "Taichung, Taiwan";
      };
    };
  };
}
