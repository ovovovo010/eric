# ~/nixos-config/root/ssh.nix
# SSH 服務設定
# 包含正常模式與 initrd 緊急模式的 SSH 存取

{ config, pkgs, lib, ... }:

{
  # ══════════════════════════════════════════════════════════════════════
  #  1. 正常模式 SSH
  # ══════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes"; # 緊急救援用，正常使用建議改 "no"
    };
    # host keys 存在 /persist，跨開機保留身份
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
  #     開機時如果卡住，可以從 iPhone/手機 SSH 進去救援
  # ══════════════════════════════════════════════════════════════════════
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222; # 用不同 port 區分 initrd vs 正常模式
      authorizedKeys = config.users.users.eric.openssh.authorizedKeys.keys;
      hostKeys = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    };
    # 等待網路上線（dhcp）
    postCommands = ''
      echo "initrd SSH ready on port 2222"
    '';
  };

  # ══════════════════════════════════════════════════════════════════════
  #  3. 防火牆開放 SSH port
  # ══════════════════════════════════════════════════════════════════════
  networking.firewall.allowedTCPPorts = [ 22 2222 ];
}
