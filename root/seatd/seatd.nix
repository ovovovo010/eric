{ config, pkgs, ... }:

{
  # 1. 啟用 seatd 服務
  services.seatd.enable = true;

  # 2. 直接在這裡幫 eric 加群組，不用回主配置改
  users.users.eric.extraGroups = [ "seat" ];

  # 3. seatd 套件本身改由 root/packages.nix 提供，這裡只負責服務與群組
}
