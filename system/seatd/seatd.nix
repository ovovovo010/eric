{ config, pkgs, ... }:

{
  # 1. 啟用 seatd 服務
  services.seatd.enable = true;

  # 2. eric 使用者的群組配置已統一在 root/users/users.nix
  # 3. seatd 套件本身由 root/packages.nix 提供
}
