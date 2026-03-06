{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package    = pkgs.qemu_kvm;
      runAsRoot  = false;
      swtpm.enable = true;   # TPM 模擬（Windows 11 需要）
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
