{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.eric = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "input"];
    packages = with pkgs; [
    ];
  };
}
