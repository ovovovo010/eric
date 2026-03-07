# root/sched_ext.nix
{ pkgs, ... }: {
  services.scx = {
    enable    = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--auto-mode"   # 自動在 power save / performance 間切換
    ];
  };
}
