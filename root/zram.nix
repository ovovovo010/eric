# ~/nixos-config/root/zram.nix
# zram swap 設定
# 壓縮在 RAM 裡的虛擬 swap，防止 OOM，不磨損 SSD
#
# 你的機器：32GB RAM，固定分配 8GB zram swap

{ ... }:

{
  zramSwap = {
    enable = true;

    memoryPercent = 37;
    # zstd = 壓縮率較好，適合記憶體充裕的機器
    # lz4  = 速度較快，壓縮率略低
    algorithm = "zstd";
  };
}
