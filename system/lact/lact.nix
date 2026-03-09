# lact.nix (NixOS system module)
# 適用於 NixOS 25.11 stable + Nvidia 顯卡
# 用法：在 configuration.nix 的 imports 加入此檔案路徑

{ config, pkgs, lib, ... }:

{
  # 啟用 LACT daemon 服務
  # NixOS 25.11 已內建此 module（nixos/modules/services/hardware/lact.nix）
  services.lact.enable = true;

  # ─────────────────────────────────────────────────────
  # Nvidia 注意事項：
  # LACT 對 Nvidia 需要 proprietary driver + CUDA libraries
  # 確保你的 configuration.nix 有以下設定（若還沒有）：
  #
  #   hardware.nvidia.modesetting.enable = true;
  #   hardware.nvidia.open = false;  # 使用 proprietary driver
  #   services.xserver.videoDrivers = [ "nvidia" ];
  #
  # CUDA（LACT Nvidia 監控功能需要）：
  #   hardware.nvidia.datacenter.enable = false; # 一般桌機不需要
  #   environment.systemPackages = with pkgs; [ cudaPackages.cuda_cudart ];
  # ─────────────────────────────────────────────────────

  # LACT daemon 預設使用 wheel 或 sudo 群組管理 unix socket 權限
  # 確保你的使用者在 wheel 群組內：
  # users.users.<你的使用者名稱>.extraGroups = [ "wheel" ];
}
