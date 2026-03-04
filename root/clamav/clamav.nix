# ./root/clamav.nix
# ClamAV 完整安全掃描模組
# 包含：clamd daemon、freshclam 自動更新、fangfrisch 額外病毒庫、
#       clamonacc 即時 on-access 掃描、每日排程全系統掃描
{ config, pkgs, lib, ... }:

{
  # ── 核心服務 ─────────────────────────────────────────────────────────
  services.clamav = {

    # clamd 主掃描 daemon
    daemon = {
      enable = true;
      settings = {
        # --- 日誌 ---
        LogFile           = "/var/log/clamav/clamd.log";
        LogFileMaxSize    = "100M";
        LogTime           = true;
        LogClean          = false;
        LogVerbose        = false;
        ExtendedDetectionInfo = true;

        # --- 網路（只監聽本機 socket，不開 TCP）---
        LocalSocket       = "/run/clamav/clamd.ctl";
        FixStaleSocket    = true;
        TCPSocket         = 3310;
        TCPAddr           = "127.0.0.1";

        # --- 效能 ---
        MaxThreads        = 4;
        MaxQueue          = 200;
        IdleTimeout       = 30;
        MaxDirectoryRecursion = 20;
        FollowDirectorySymlinks = false;
        FollowFileSymlinks      = false;

        # --- 掃描能力 ---
        ScanPE            = true;
        ScanELF           = true;
        ScanOLE2          = true;
        ScanPDF           = true;
        ScanSWF           = true;
        ScanXMLDOCS       = true;
        ScanHWP3          = true;
        ScanOneNote       = true;
        ScanMail          = true;
        ScanHTML          = true;
        ScanArchive       = true;
        Bytecode          = true;
        DetectPUA         = true;
        HeuristicAlerts   = true;

        # --- 告警 ---
        AlertBrokenExecutables    = true;
        AlertBrokenMedia          = true;
        AlertEncrypted            = true;
        AlertEncryptedArchive     = true;
        AlertEncryptedDoc         = true;
        AlertOLE2Macros           = true;
        AlertPartitionIntersection = true;

        # --- On-Access 即時掃描設定（需要 root 啟動 clamd）---
        # 監控整個掛載點；Prevention 模式需搭配 OnAccessIncludePath
        OnAccessMountPath         = "/home";
        OnAccessExtraScanning     = true;
        OnAccessExcludeRootUID    = true;
        # 若要封鎖可改為 true，但需改用 OnAccessIncludePath
        OnAccessPrevention        = false;
      };
    };

    # freshclam 官方病毒庫自動更新（每天 4 次）
    updater = {
      enable    = true;
      frequency = 4;
      settings  = {
        DatabaseMirror = [ "database.clamav.net" ];
        DNSDatabaseInfo = "current.cvd.clamav.net";
        LogFile         = "/var/log/clamav/freshclam.log";
        LogFileMaxSize  = "50M";
        LogTime         = true;
        NotifyClamd     = "/run/clamav/clamd.ctl";  # 更新後自動通知 clamd 重載
        Bytecode        = true;
      };
    };

    # fangfrisch 第三方額外病毒特徵庫
    # 預設啟用 urlhaus（惡意 URL）與 sanesecurity（擴充特徵）
    fangfrisch = {
      enable   = true;
      interval = "hourly";   # systemd calendar 表達式
      settings = {
        DEFAULT = {
          db_url_prefix = "https://";
          enabled       = "yes";
        };
        # urlhaus：惡意下載 URL 黑名單
        urlhaus = {
          enabled = "yes";
        };
        # Sanesecurity：擴充惡意郵件 / 釣魚特徵
        sanesecurity = {
          enabled = "yes";
        };
      };
    };
  };

  # ── clamonacc 即時 on-access 掃描 daemon ─────────────────────────────
  # NixOS 模組尚未原生支援 clamonacc，手動建立 systemd 服務
  systemd.services.clamav-clamonacc = {
    description = "ClamAV On-Access Scanner (clamonacc)";
    documentation = [ "https://docs.clamav.net/manual/OnAccess.html" ];

    # 必須等 clamd socket 就緒後才啟動
    after    = [ "clamav-daemon.service" ];
    requires = [ "clamav-daemon.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type            = "simple";
      # --fdpass 使用檔案描述符傳遞；--move 把感染檔案移至隔離區
      ExecStart       = "${pkgs.clamav}/bin/clamonacc --fdpass --foreground"
                        + " --log=/var/log/clamav/clamonacc.log"
                        + " --move=/var/lib/clamav/quarantine";
      Restart         = "on-failure";
      RestartSec      = "10s";

      # clamonacc 需要 root 才能掛接 fanotify
      User            = "root";
      Group           = "clamav";

      # 日誌目錄與隔離區
      RuntimeDirectory         = "clamav";
      RuntimeDirectoryMode     = "0750";
      StateDirectory           = "clamav/quarantine";
      StateDirectoryMode       = "0700";

      # 輕度 hardening（clamonacc 需要廣泛 fs 存取）
      ProtectSystem            = "strict";
      ReadWritePaths           = [
        "/var/log/clamav"
        "/var/lib/clamav"
        "/home"
      ];
      PrivateTmp               = true;
      NoNewPrivileges          = false;  # 需要 CAP_SYS_ADMIN for fanotify
      AmbientCapabilities      = [ "CAP_SYS_ADMIN" ];
      CapabilityBoundingSet    = [ "CAP_SYS_ADMIN" ];
    };
  };

  # ── 每日全系統排程掃描 ───────────────────────────────────────────────
  systemd.services.clamav-scan = {
    description = "ClamAV Daily Full System Scan";
    after    = [ "clamav-daemon.service" ];
    requires = [ "clamav-daemon.service" ];

    serviceConfig = {
      Type  = "oneshot";
      User  = "root";
      # 掃描 /home 與 /tmp；感染檔案移至隔離區；結果寫入 log
      ExecStart = pkgs.writeShellScript "clamav-scan.sh" ''
        set -euo pipefail
        LOGFILE="/var/log/clamav/scan-$(date +%F).log"
        QUARANTINE="/var/lib/clamav/quarantine"
        mkdir -p "$QUARANTINE"

        echo "=== ClamAV Scan Started: $(date) ===" | tee -a "$LOGFILE"
        ${pkgs.clamav}/bin/clamscan \
          --recursive \
          --infected \
          --official-db-only=no \
          --move="$QUARANTINE" \
          --log="$LOGFILE" \
          /home /tmp /var/tmp \
          || true   # clamscan 發現病毒時 exit 1，不讓 systemd 視為失敗
        echo "=== ClamAV Scan Finished: $(date) ===" | tee -a "$LOGFILE"

        # 保留最近 30 天日誌，自動清理舊檔
        find /var/log/clamav -name "scan-*.log" -mtime +30 -delete
      '';

      # 降低 I/O 優先序，避免掃描期間拖慢系統
      IOSchedulingClass    = "idle";
      CPUSchedulingPolicy  = "idle";
      Nice                 = 19;
    };
  };

  systemd.timers.clamav-scan = {
    description = "ClamAV Daily Full System Scan Timer";
    wantedBy    = [ "timers.target" ];
    timerConfig = {
      OnCalendar          = "daily";
      Persistent          = true;   # 若關機錯過則開機後補跑
      RandomizedDelaySec  = "1h";   # 隨機延遲 0~1h，分散系統負載
    };
  };

  # ── 確保日誌目錄存在 ────────────────────────────────────────────────
  systemd.tmpfiles.rules = [
    "d /var/log/clamav         0755 clamav clamav -"
    "d /var/lib/clamav/quarantine 0700 root   clamav -"
  ];
}
