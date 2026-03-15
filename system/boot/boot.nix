{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "fbdev=1"
    "i915.enable_dc=0"
  ];
  boot.initrd.kernelModules = ["i915"];
}
