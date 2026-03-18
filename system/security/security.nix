{
  config,
  lib,
  pkgs,
  ...
}: {
  # ==========================================
  # 系統核心與記憶體安全加固
  # ==========================================

  boot.kernel.sysctl = {
    # 隱藏核心記憶體位置，增加駭客利用核心漏洞的難度
    "kernel.kptr_restrict" = 2;
    # 限制 dmesg 輸出，防止一般無特權使用者讀取核心日誌中的敏感資訊
    "kernel.dmesg_restrict" = 1;
    # 關閉非特權使用者的 BPF (防止特定的記憶體漏洞攻擊)
    "kernel.unprivileged_bpf_disabled" = 1;
    # 限制 SysRq 鍵 (只允許安全重啟，禁止直接傾印記憶體)
    "kernel.sysrq" = 4;
  };

  # 防止對載入的核心映像進行修改
  security.protectKernelImage = true;
  # 強制開啟頁表隔離 (KPTI)，防禦 Meltdown 等硬體層級漏洞
  security.forcePageTableIsolation = true;

  # 禁用罕見且歷史上容易出現漏洞的網路協議
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "n-hdlc"
    "ax25"
    "netrom"
    "x25"
    "rose"
    "decnet"
  ];

  # ==========================================
  # 存取控制與權限管理
  # ==========================================

  # 限制只有 wheel 群組 (管理員) 的使用者才能執行 sudo，防止一般帳號提權
  security.sudo.execWheelOnly = true;

  # ==========================================
  # 服務加固 (Auditd, Fail2ban, SSH)
  # ==========================================

  # 系統審計服務 (Auditd)
  security.auditd.enable = true;
  security.audit.enable = true;
  # 增加審計規則：監控重要憑證與設定檔的修改行為
  security.audit.rules = [
    "-w /etc/shadow -p wa -k shadow-modify"
    "-w /etc/passwd -p wa -k passwd-modify"
    "-w /etc/nixos/ -p wa -k nixos-config-modify"
  ];

  # Fail2ban (防止暴力破解)
  services.fail2ban = {
    enable = true;
    bantime = "1h"; # 預設封鎖 1 小時
    maxretry = 5; # 預設允許 5 次失敗

    # 針對 SSH 的專屬嚴格規則
    jails.sshd.settings = {
      port = "ssh";
      filter = "sshd";
      maxretry = 3; # SSH 密碼錯 3 次就封鎖
    };
  };
}
