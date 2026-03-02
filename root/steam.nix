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
  };

  programs.gamemode.enable = true; # ← system-level

  environment.systemPackages = with pkgs; [
    steam-run
    mangohud
    gamemode
    protonup-qt
  ];
}
