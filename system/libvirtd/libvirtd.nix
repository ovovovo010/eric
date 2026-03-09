{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package      = pkgs.qemu_kvm;
      runAsRoot    = false;
      swtpm.enable = true;
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  # virt-manager 裝在 system 層才能正確讀到 UEFI 韌體路徑
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtio-win
  ];

  # dconf 讓 virt-manager 能儲存設定
  programs.dconf.enable = true;
}
