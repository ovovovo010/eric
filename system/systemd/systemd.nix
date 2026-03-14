# ./root/systemd.nix
# ClamAV systemd 服務強化模組 v2
# 原則：最小權限、隔離 namespace、限制系統呼叫
# v2 新增：
#   - 全域 timeout 加速（任務/視窗/服務截斷時間）
#   - 各服務個別 TimeoutStartSec / TimeoutStopSec
#   - 權限微調：移除過度嚴格的 ~@resources，放寬 ProcSubset
{
  config,
  pkgs,
  lib,
  ...
}: {
  # ══════════════════════════════════════════════════════════════════════
  #  0. 全域 systemd Manager 截斷時間加速
  #     預設值都是 90s，對桌機/伺服器來說太慢
  # ══════════════════════════════════════════════════════════════════════

  # ── 0a. system manager（root session）─────────────────────────────────
  # NixOS 25.11+：systemd.extraConfig 已棄用，改用 systemd.settings.Manager
  systemd.settings.Manager = {
    # ── 服務截斷時間（start / stop / abort）──
    DefaultTimeoutStartSec = "5s";
    DefaultTimeoutStopSec = "5s";
    DefaultTimeoutAbortSec = "5s";

    # ── 任務截斷時間（Job）──
    DefaultJobTimeoutSec = "5s";
    DefaultJobTimeoutAction = "terminate";

    # ── 視窗（Window）類：設備等待截斷 ──
    DefaultDeviceTimeoutSec = "5s";

    # ── 重啟間隔微調 ──
    DefaultRestartSec = "5s";
  };

  # ── 0b. user manager（每個使用者 session）─────────────────────────────
  # systemd.user.settings 不存在於 NixOS 模組；
  # user manager 仍使用 systemd.user.extraConfig（尚未棄用）
  systemd.user.extraConfig = ''
    DefaultTimeoutStartSec=5s
    DefaultTimeoutStopSec=5s
    DefaultTimeoutAbortSec=5s
    DefaultJobTimeoutSec=5s
    DefaultDeviceTimeoutSec=5s
    DefaultRestartSec=5s
  '';

  # ══════════════════════════════════════════════════════════════════════
  #  1. clamav-daemon（clamd）強化
  # ══════════════════════════════════════════════════════════════════════
  systemd.services.clamav-daemon.serviceConfig = lib.mkForce {
    # --- 個別服務截斷時間 ---
    # clamd 啟動需要載入病毒庫，給較長的啟動時間；停止要快
    TimeoutStartSec = "120s"; # 病毒庫載入可能需要時間
    TimeoutStopSec = "20s"; # 停止訊號後 20s 強制殺
    TimeoutAbortSec = "10s";
    # Job 在佇列中等待上限
    JobTimeoutSec = "150s";

    # --- 重啟策略 ---
    Restart = "on-failure";
    RestartSec = "10s";
    StartLimitIntervalSec = "120s";
    StartLimitBurst = 5;

    # --- 使用者隔離 ---
    User = "clamav";
    Group = "clamav";
    PrivateUsers = true;

    # --- 檔案系統隔離 ---
    ProtectSystem = "strict";
    ProtectHome = true;
    ReadWritePaths = [
      "/var/lib/clamav"
      "/var/log/clamav"
      "/run/clamav"
      "/tmp"
    ];
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    # ▲ 寬鬆：移除 ProcSubset=pid，允許 clamd 讀 /proc/meminfo 等系統資訊
    # ProcSubset             = "pid";  # 已移除

    # --- 網路 ---
    RestrictAddressFamilies = ["AF_UNIX" "AF_INET"];
    IPAddressAllow = ["127.0.0.1/32" "::1/128"];
    IPAddressDeny = "any";

    # --- 能力限制 ---
    NoNewPrivileges = true;
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";

    # --- 系統呼叫過濾 ---
    # ▲ 寬鬆：移除 ~@resources，允許 setrlimit 等資源相關呼叫
    #         ClamAV 在載入大型庫時會調整自身資源限制
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      # "~@resources"  # 已移除，避免 clamd 載入病毒庫時被阻擋
    ];
    SystemCallArchitectures = "native";
    SystemCallErrorNumber = "EPERM";

    # --- 記憶體保護 ---
    LockPersonality = true;
    MemoryDenyWriteExecute = false; # Bytecode JIT 需要
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;

    # --- 資源限制 ---
    LimitNOFILE = 65536;
    LimitNPROC = 256;
    MemoryHigh = "512M";
    MemoryMax = "1G";
    IOSchedulingClass = "best-effort";
    IOSchedulingPriority = 5;

    # --- cgroup slice ---
    Slice = "clamav.slice";
  };

  # ══════════════════════════════════════════════════════════════════════
  #  2. clamav-freshclam（updater）強化
  # ══════════════════════════════════════════════════════════════════════
  systemd.services.clamav-freshclam.serviceConfig = lib.mkForce {
    # --- 個別截斷時間 ---
    # freshclam 需要下載大型病毒庫，給充裕啟動時間；stop 要快
    TimeoutStartSec = "300s"; # 下載病毒庫可能很慢
    TimeoutStopSec = "15s";
    TimeoutAbortSec = "10s";
    JobTimeoutSec = "360s";

    # --- 重啟策略 ---
    Restart = "on-failure";
    RestartSec = "30s";
    StartLimitIntervalSec = "600s";
    StartLimitBurst = 3;

    # --- 使用者 ---
    User = "clamav";
    Group = "clamav";
    PrivateUsers = true;

    # --- 檔案系統隔離 ---
    ProtectSystem = "strict";
    ProtectHome = true;
    ReadWritePaths = [
      "/var/lib/clamav"
      "/var/log/clamav"
    ];
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;

    # freshclam 需要對外
    RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
    IPAddressDeny = "";

    # --- 能力 ---
    NoNewPrivileges = true;
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";

    # ▲ 寬鬆：移除 ~@resources，freshclam 需要調整網路緩衝
    SystemCallFilter = ["@system-service" "~@privileged"];
    SystemCallArchitectures = "native";
    SystemCallErrorNumber = "EPERM";

    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;

    LimitNOFILE = 1024;
    MemoryMax = "256M";
    Slice = "clamav.slice";
  };

  # ══════════════════════════════════════════════════════════════════════
  #  3. clamav-fangfrisch（第三方庫更新）強化
  # ══════════════════════════════════════════════════════════════════════
  systemd.services.clamav-fangfrisch.serviceConfig = lib.mkForce {
    Type = "oneshot";

    # --- oneshot 截斷時間 ---
    TimeoutStartSec = "180s";
    TimeoutStopSec = "15s";
    JobTimeoutSec = "240s";

    User = "clamav";
    Group = "clamav";

    ProtectSystem = "strict";
    ProtectHome = true;
    ReadWritePaths = ["/var/lib/clamav" "/var/log/clamav"];
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;

    NoNewPrivileges = true;
    CapabilityBoundingSet = "";

    # ▲ 寬鬆：移除 ~@resources
    SystemCallFilter = ["@system-service" "~@privileged"];
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    RestrictRealtime = true;
    MemoryMax = "256M";
    Slice = "clamav.slice";
  };

  # ══════════════════════════════════════════════════════════════════════
  #  4. clamav-scan（每日排程掃描）強化
  # ══════════════════════════════════════════════════════════════════════
  # clamav-scan: ExecStart 由 clamav.nix 定義，這裡只補 hardening 與截斷時間
  # 改用 lib.mkForce 而非 lib.mkMerge + config 自我引用（會造成無限遞迴）
  systemd.services.clamav-scan.serviceConfig = lib.mkForce {
    # --- oneshot 截斷時間 ---
    TimeoutStartSec = "6h";
    TimeoutStopSec = "30s";
    JobTimeoutSec = "7h";

    Type = "oneshot";
    User = "root";

    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    PrivateDevices = true;
    PrivateTmp = true;

    # ▲ 寬鬆：不設定 ProtectSystem/ProtectHome，讓 clamscan 讀取全系統檔案
    RestrictAddressFamilies = ["AF_UNIX"];
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;

    # ▲ 寬鬆：移除 ~@resources，clamscan fork 子程序需要 setrlimit
    SystemCallFilter = ["@system-service" "~@privileged"];
    SystemCallArchitectures = "native";

    CPUQuota = "40%";
    MemoryMax = "1G";
    IOSchedulingClass = "idle";
    CPUSchedulingPolicy = "idle";
    Nice = 19;
    Slice = "clamav.slice";
  };

  # ══════════════════════════════════════════════════════════════════════
  #  5. 全域 cgroup slice
  # ══════════════════════════════════════════════════════════════════════
  systemd.slices.clamav = {
    description = "ClamAV Services Slice";
    sliceConfig = {
      MemoryHigh = "1G";
      MemoryMax = "2G";
      CPUWeight = 20;
      IOWeight = 20;
    };
  };
}
