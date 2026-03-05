{ pkgs, config, lib, ... }:
{
  # 啟用 KVM/libvirt 虛擬化
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;        # TPM 模擬（Windows 11 需要）
      ovmf = {
        enable = true;            # UEFI 支援
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  # virt-manager GUI
  programs.virt-manager.enable = true;

  # 將使用者加入 libvirtd 群組
  users.users.eric.extraGroups = [ "libvirtd" "kvm" ];

  # 讓 virtio 網路正常運作
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer        # 獨立 SPICE/VNC 連線器
    spice-gtk          # SPICE 支援
    win-virtio         # Windows virtio 驅動 ISO
    win-spice          # Windows SPICE guest agent
  ];
}
