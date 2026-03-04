{ config, pkgs, lib, ... }: {
  services.mako = {
    enable = true;
    
    settings = {
      # --- 1. 核心視覺 ---
      background-color = lib.mkForce "#1e1e2e";      # 強制使用你的設定
      text-color = lib.mkForce "#cdd6f4";
      border-color = lib.mkForce "#b4befe";
      progress-color = lib.mkForce "over #313244";
      
      # --- 2. 佈局與幾何 ---
      anchor = lib.mkForce "top-right";
      width = lib.mkForce 350;
      height = lib.mkForce 150;
      margin = lib.mkForce "20,20";
      padding = lib.mkForce "15";
      border-size = lib.mkForce 2;
      border-radius = lib.mkForce 10;
      
      # --- 3. 字體與行為 ---
      font = lib.mkForce "JetBrainsMono Nerd Font 11";
      default-timeout = lib.mkForce 5000;
      ignore-timeout = lib.mkForce false;
      max-visible = lib.mkForce 5;
      layer = lib.mkForce "overlay";
    };

    # 4. 進階互動 (這部分保持不變)
    extraConfig = ''
      [urgency=low]
      border-color=#313244

      [urgency=high]
      border-color=#f38ba8
      default-timeout=0

      max-icon-size=64
      on-button-left=dismiss
      on-button-right=dismiss-all
    '';
  };
}

