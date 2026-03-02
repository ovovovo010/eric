{
  config,
  pkgs,
  ...
}: {
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "btrfs";
    options = ["rw" "compress=zstd" "noatime" "user" "exec"];
  };
}
