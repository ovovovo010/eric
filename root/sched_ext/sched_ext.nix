# root/sched_ext.nix
{ pkgs, ... }: {
  # 需要夠新的 kernel 支援 sched_ext
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.scx = {
    enable    = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--auto-mode"   # 自動在 power save / performance 間切換
    ];
  };
}
