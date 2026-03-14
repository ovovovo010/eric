# /etc/nixos/root/steam.nix
{
  config,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    environment.sessionVariables = {
      STEAM_COMPAT_DATA_PATH = "/mnt/data/steam";
    };
  };

  programs.gamemode.enable = true; # ← system-level，套件由 root/packages.nix 提供
}
