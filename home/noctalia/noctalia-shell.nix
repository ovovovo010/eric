{ ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      colorSchemes = {
        darkMode = true;
        useWallpaperColors = true;
      };
      bar = {
        backgroundOpacity = lib.mkForce 0.8;
        floating = true;
      };
    };
  };
}
