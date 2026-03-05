{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.eric = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = ["wheel" "networkmanager" "video" "input" "seat" "libvirtd" ];
    # subuid/subgid for rootless containers (distrobox/podman)
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
    packages = with pkgs; [];
  };

  # greeter 使用者 (for greetd)
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  users.groups.greeter = {};
}
