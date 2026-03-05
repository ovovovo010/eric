{ pkgs, config, lib, ... }:
{
  # 啟用 KVM/libvirt 虛擬化
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;        # TPM 模擬（Windows 11 需要）

    };
  };



  # 讓 virtio 網路正常運作
  virtualisation.spiceUSBRedirection.enable = true;
}
