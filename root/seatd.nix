{ config, pkgs, ... }:

{
  # 1. 啟用 seatd 服務
  services.seatd.enable = true;

  # 2. 直接在這裡幫 eric 加群組，不用回主配置改
  users.users.eric.extraGroups = [ "seat" ];

  # 3. 如果你想確保 seatd 相關套件在環境中可用
  environment.systemPackages = [ pkgs.seatd ];
}

