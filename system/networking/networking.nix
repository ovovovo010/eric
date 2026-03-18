{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    # ==========================================
    # 防火牆加固
    # ==========================================
    firewall = {
      enable = true;
      # 拒絕 ICMP (Ping) 請求，讓系統在區網/公網中隱形
      allowPing = false;
      # 記錄被拒絕的欺騙性路由封包
      logReversePathDrops = true;
      # 為了避免掃描器塞滿系統日誌，關閉拒絕連線的日誌 (可依需求開啟)
      logRefusedConnections = false;
    };
  };

  # ==========================================
  # 網路核心參數加固 (Sysctl)
  # ==========================================
  boot.kernel.sysctl = {
    # 防止 IP 欺騙 (IP Spoofing)
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # 雙重保險：忽略所有 ICMP Echo 請求與廣播
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    # 抵禦 TCP SYN 洪水攻擊 (SYN Flood Attacks)
    "net.ipv4.tcp_syncookies" = 1;

    # 關閉不必要的 ICMP 重定向 (防止惡意修改本機路由表)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;

    # 不發送 ICMP 重定向
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # 記錄火星封包 (Martian Packets, 指網路上不該出現的假 IP)
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
  };

  # ==========================================
  # 安全的 DNS 解析 (DNSSEC & DNS over TLS)
  # ==========================================
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1" "9.9.9.9"]; # 使用 Cloudflare 或 Quad9
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
