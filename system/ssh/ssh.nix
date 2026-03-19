# ~/nixos-config/root/ssh.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # ══════════════════════════════════════════════════════════════════════
  #  0. 注入 SSH 公鑰 (將你的公鑰放進系統)
  # ══════════════════════════════════════════════════════════════════════
  # 【注意】請將 "eric" 替換成你日常登入系統的使用者帳號！
  users.users.eric = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnY4J9PlO56cEMpTas6M/pRDj2bz3Lx2oMSPUieyCdk ovovovo010@proton.me"
    ];
  };

  # ══════════════════════════════════════════════════════════════════════
  #  1. 正常模式 SSH (已加入安全加固)
  # ══════════════════════════════════════════════════════════════════════
  services.openssh = {
    enable = true;

    # 【安全加固區】
    settings = {
      # 關閉密碼登入，強制使用金鑰 (防禦暴力破解最有效的方法)
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # 禁止 root 帳號直接登入 (標準安全作法：先登入一般帳號，再 sudo 提權)
      # 如果你非要 root 登入不可，請改為 "prohibit-password" (只允許金鑰登入 root)
      PermitRootLogin = "no";
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  # ══════════════════════════════════════════════════════════════════════
  #  3. 防火牆
  # ══════════════════════════════════════════════════════════════════════
  networking.firewall.allowedTCPPorts = [22];
}
