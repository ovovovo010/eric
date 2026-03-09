# root/pipewire.nix
{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "99-hifi" = {
        "context.properties" = {
          "default.clock.rate"          = 48000;
          "default.clock.allowed-rates" = [ 44100 48000 ];
          "default.clock.quantum"       = 256;
          "default.clock.min-quantum"   = 64;
          "default.clock.max-quantum"   = 2048;
        };
      };
    };

    extraConfig.pipewire-pulse = {
      "99-hifi" = {
        "pulse.properties" = {
          "pulse.default.format"      = "F32";
          "pulse.default.rate"        = 48000;
          "pulse.min.quantum"         = "256/48000";
        };
      };
    };
  };

  # EasyEffects 音效處理（EQ、compression、loudness）
  environment.systemPackages = with pkgs; [
    easyeffects
  ];
}
