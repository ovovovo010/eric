# ~/nixos-config/root/zfs.nix
# NixOS 系統級 ZFS 設定
#
# 你的 dataset 結構：
#   rpool/root   — / (系統根目錄)
#   rpool/nix    — /nix (store，不需快照)
#   rpool/home   — /home
#   rpool/var    — /var
#
# 套用後執行：
#   sudo zfs set com.sun:auto-snapshot=false rpool/nix
#   sudo zfs set com.sun:auto-snapshot=false rpool/root

{ config, pkgs, lib, ... }:

{
  ###########################
  ### 基礎設定             ###
  ###########################

  # 強制匯入 ZFS pool（安全模式，不強制匯入避免資料損壞）
  boot.zfs.forceImportRoot = false;

  # 支援 ZFS 檔案系統
  boot.supportedFilesystems = [ "zfs" ];

  # 主機 ID（ZFS 需要，防止多台機器誤匯入同一個 pool）
  # 已在 hardware-configuration.nix 設定，這裡不重複

  ###########################
  ### ARC 記憶體限制       ###
  ###########################

  # 限制 ZFS ARC 快取最大 12GB
  # 預設 ARC 會吃掉一半以上 RAM，限制後讓系統有更多可用記憶體
  boot.kernelParams = [
    "zfs.zfs_arc_max=${toString (12 * 1024 * 1024 * 1024)}" # 12 GB（單位：bytes）
  ];

  # 也可用 extraModprobeConfig 設定（二選一，效果相同）
  # boot.extraModprobeConfig = ''
  #   options zfs zfs_arc_max=12884901888
  # '';

  ###########################
  ### 自動 Scrub           ###
  ###########################

  # 定期掃描 pool 資料完整性，偵測並修復位元腐爛
  # 預設每月執行一次
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly"; # systemd 時間格式，可改 "weekly"
    pools = [ "rpool" ];  # 指定 pool，留空則掃全部
  };

  ###########################
  ### 自動快照             ###
  ###########################

  # 使用 sanoid 風格的 auto-snapshot
  # 套用前需在 shell 執行：
  #   sudo zfs set com.sun:auto-snapshot=false rpool/nix
  #   sudo zfs set com.sun:auto-snapshot=false rpool/root
  # 讓 /nix 和 / 不產生快照（這兩個 dataset 重建即可，不需保留歷史）
  services.zfs.autoSnapshot = {
    enable = true;

    # 保留數量
    frequent = 4;    # 每 15 分鐘一次，保留最近 4 個（1 小時內）
    hourly   = 24;   # 每小時一次，保留 24 個（1 天內）
    daily    = 7;    # 每天一次，保留 7 個（1 週內）
    weekly   = 4;    # 每週一次，保留 4 個（1 個月內）
    monthly  = 6;    # 每月一次，保留 6 個（半年內）

    # 快照旗標：只對有 com.sun:auto-snapshot=true 的 dataset 生效
    # 或對沒有明確設定 false 的 dataset 生效（預設行為）
    flags = "-k -p"; # -k: 保留快照即使 pool 空間不足；-p: 遞迴子 dataset
  };

  ###########################
  ### 自動 Trim（SSD）     ###
  ###########################

  # 定期對 SSD 執行 TRIM，釋放已刪除資料佔用的區塊
  # 你的 NVMe 上跑 ZFS，建議開啟
  services.zfs.trim = {
    enable = true;
    interval = "weekly"; # 每週一次，不需要太頻繁
  };

  ###########################
  ### ZED 事件通知         ###
  ###########################

  # ZFS Event Daemon：監聽 ZFS 事件（磁碟錯誤、scrub 結果等）
  # 需要設定 email 才能收到通知
  services.zfs.zed = {
    # 設定 ZED 在事件發生時寄信
    settings = {
      ZED_DEBUG_LOG       = "/tmp/zed.debug.log";
      ZED_EMAIL_ADDR      = [ "eric@example.com" ]; # 改成你的 email
      ZED_EMAIL_PROG      = "${pkgs.mailutils}/bin/mail";
      ZED_EMAIL_OPTS      = "-s '@SUBJECT@' @ADDRESS@";

      # 哪些事件要寄信
      ZED_NOTIFY_INTERVAL_SECS = 3600; # 同一事件最多每小時通知一次
      ZED_NOTIFY_VERBOSE       = false; # true = 連成功事件也通知

      # Scrub 結束時通知
      ZED_SCRUB_MIN_ERROR_CNT = 0; # 0 = 有任何錯誤就通知

      # 降級（degraded）狀態立即通知
      ZED_SPARE_ON_DEGRADE = false; # 沒有熱備碟，設 false
    };

    # 不需要 email 的話，改用 notify-send（Hyprland 桌面通知）
    # 需要自己寫 zed.d script，這裡留作參考
  };

  ###########################
  ### 進階設定             ###
  ###########################

  # 啟用 ZFS 使用者空間工具
  environment.systemPackages = with pkgs; [
    zfs          # 主工具
    zfstools     # 額外腳本（auto-snapshot 等）
    # sanoid     # 進階快照管理（可替代 autoSnapshot，功能更強）
    # zrepl      # ZFS 備份/複製工具（可備份到遠端）
  ];

  # 開機時自動匯入 pool（systemd 整合）
  # NixOS 預設已開啟，這裡明確標示
  systemd.services."zfs-import-rpool" = {
    after = [ "systemd-udev-settle.service" ];
  };
}
