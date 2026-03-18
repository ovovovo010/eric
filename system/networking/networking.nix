{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  security.auditd.enable = true;
  services.fail2ban.enable = true;
}
