{ config, pkgs, ... }: {
  services.mako = {
    enable = true;
    
    # 2026 年新語法：所有視覺設定都要包在 settings 裡
    settings = {
      # --- 1. 核心視覺 ---
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#b4befe";
      progress-color = "over #313244";
      
      # --- 2. 佈局與幾何 ---
      anchor = "top-right";
      width = 350;
      height = 150;
      margin = "20,20";
      padding = "15";
      border-size = 2;
      border-radius = 10;
      
      # --- 3. 字體與行為 ---
      font = "JetBrainsMono Nerd Font 11";
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      layer = "overlay";
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
