{...}: {
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
    configurationLimit = 10;    # 最多保留 10 個開機項目
    # 靜默模式：0 秒倒數，長按 space 才顯示選單
    editor = false;             # 禁止在選單直接編輯 kernel 參數（安全性）
  };

  boot.loader.timeout = 0;      # 0 秒直接開機，長按 space 才顯示選單

  boot.loader.efi.canTouchEfiVariables = true;

  # 靜默開機：隱藏 kernel 訊息，交給 plymouth 接管
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "vt.global_cursor_default=0"
  ];
}
