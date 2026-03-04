# ~/nixos-config/root/ssh.nix
{ config, pkgs, lib, ... }:

{
  # ══════════════════════════════════════════════════════════════════════
  #  1. 正常模式 SSH
  # ══════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  # ══════════════════════════════════════════════════════════════════════
  #  2. initrd 階段 SSH（緊急模式可連線）
  #     連線方式：ssh -p 2222 root@192.168.1.101
  # ══════════════════════════════════════════════════════════════════════
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnY4J9PlO56cEMpTas6M/pRDj2bz3Lx2oMSPUieyCdk ovovovo010@proton.me"
      ];
      hostKeys = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    };
  };

  # ══════════════════════════════════════════════════════════════════════
  #  3. 防火牆
  # ══════════════════════════════════════════════════════════════════════
  networking.firewall.allowedTCPPorts = [ 22 2222 ];
}
