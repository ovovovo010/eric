{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "fbdev=1"
    "i915.enable_dc=0"          
  ];
    boot.initrd.kernelModules = [ "i915" ];
}
