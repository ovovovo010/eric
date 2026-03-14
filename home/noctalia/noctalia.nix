{inputs, pkgs, ...}: {
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
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
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
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
