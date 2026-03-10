{ config, pkgs, lib, ... }:

{
  programs.mpv = {
    enable = true;

    # ── Scripts ──────────────────────────────────────────────────────────────
    scripts = with pkgs.mpvScripts; [
      uosc          # 現代化 UI（會自動隱藏原生 OSC）
      thumbfast      # uosc 進度條縮圖預覽
    ];

    # ── mpv.conf ─────────────────────────────────────────────────────────────
    config = {
      # --- 停用原生 OSC，改用 uosc ---
      osc = "no";
      osd-bar = "no";          # uosc 自帶進度條，關掉原生的

      # --- PipeWire 音訊輸出 ---
      ao = "pipewire";         # 直接走 PipeWire，不經 PulseAudio 相容層

      # --- 音質優化 ---
      audio-channels   = "auto-safe"; # 自動偵測聲道，避免 upmix 失真
      audio-samplerate = 48000;        # PipeWire 預設 48 kHz，避免重採樣
      audio-format     = "floatp";     # 32-bit float，最高精度進入 PipeWire graph
      volume-max       = 100;          # 不過放大，保持訊號乾淨
      audio-pitch-correction = "yes";  # 變速播放時保持音高

      # resampler（只在必要時才會用到）
      audio-resampler         = "soxr";
      audio-resampler-quality = 10;    # SoXR 最高品質（0-10）

      # 音量正規化（選用：消除片源音量落差）
      # af = "acompressor=ratio=4,loudnorm";   # 如不需要請保持註解

      # --- 影像品質（順帶一提） ---
      vo     = "gpu-next";
      gpu-api = "vulkan";       # 或改成 "opengl" 若 Vulkan 有問題
      hwdec  = "auto-safe";
    };

    # ── input.conf（uosc 建議按鍵） ──────────────────────────────────────────
    bindings = {
      # 讓滾輪控制音量（uosc 慣例）
      "WHEEL_UP"   = "add volume  5";
      "WHEEL_DOWN" = "add volume -5";

      # 快速切換音軌
      "a" = "cycle audio";
      "s" = "cycle sub";
    };
  };
}
