{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./root/fcitx5.nix
    ./root/boot.nix
    ./root/networking.nix
    ./root/locale.nix
    ./root/audio.nix
    ./root/driver.nix
    ./root/desktop.nix
    ./root/users.nix
    ./root/packages.nix
    ./root/stylix.nix
    ./root/mirror.nix
    ./root/greetd.nix
    ./root/steam.nix
    ./root/nushell.nix
    ./root/data.nix
    ./root/polkit.nix
    ./root/flatpak.nix
    ./root/thunar.nix
    ./root/zen.nix
    ./root/clamav.nix
    ./root/systemd.nix
    ./root/seatd.nix
    ./root/wayland.nix
    ./root/obs.nix
    ./root/zfs.nix
    ./root/zram.nix
    ./root/lact.nix
    ./root/ssh.nix
    ./root/code-cursor.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
