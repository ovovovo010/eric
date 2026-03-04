{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      gpu_stats = true;
      cpu_stats = true;
      ram = true;
      vram = true;
      frame_timing = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
      horizontal = true;
    };
  };
}
