# ~/nixos/home/modules/obs.nix
# OBS Studio - Home Manager 設定
# 使用 HM 內建的 programs.obs-studio 模組，不重新定義 options
# 虛擬攝影機（v4l2loopback）需搭配 system 層的 services.obs-studio 設定

{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;

    # 如需指定版本或開啟 CUDA 加速，取消下方註解
    # package = pkgs.obs-studio.override { cudaSupport = true; };

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                    # Wayland 螢幕擷取
      obs-pipewire-audio-capture # PipeWire 音訊擷取
      obs-backgroundremoval     # 背景移除（AI）
      # obs-vaapi               # AMD GPU 加速（選用）
      # obs-vkcapture           # Vulkan/OpenGL 遊戲擷取（選用）
    ];
  };
}
