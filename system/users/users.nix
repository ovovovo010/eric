{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.eric = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = ["wheel" "networkmanager" "video" "input" "seat" "render"];
    # subuid/subgid for rootless containers (distrobox/podman)
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    packages = with pkgs; [];
  };
  users.users.user1 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    packages = with pkgs; [];
  };
}
