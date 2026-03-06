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
        enable = true;         # UEFI 韌體
        packages = [ pkgs.OVMFFull.fd ]; # 含 Secure Boot 支援
      };
    };
  };



  # 讓 virtio 網路正常運作
  virtualisation.spiceUSBRedirection.enable = true;
}
