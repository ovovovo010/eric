{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./root/fcitx5/fcitx5.nix
    ./root/boot/boot.nix
    ./root/networking/networking.nix
    ./root/locale/locale.nix
    ./root/audio/audio.nix
    ./root/driver/driver.nix
    ./root/desktop/desktop.nix
    ./root/users/users.nix
    ./root/packages/packages.nix
    ./root/stylix/stylix.nix
    ./root/mirror/mirror.nix
    ./root/greetd/greetd.nix
    ./root/steam/steam.nix
    ./root/nushell/nushell.nix
    ./root/data/data.nix
    ./root/polkit/polkit.nix
    ./root/flatpak/flatpak.nix
    ./root/thunar/thunar.nix
    ./root/zen/zen.nix
    ./root/clamav/clamav.nix
    ./root/systemd/systemd.nix
    ./root/seatd/seatd.nix
    ./root/wayland/wayland.nix
    ./root/obs/obs.nix
    ./root/zfs/zfs.nix
    ./root/zram/zram.nix
    ./root/lact/lact.nix
    ./root/ssh/ssh.nix
    ./root/distrobox/distrobox.nix
    ./root/libvirtd/libvirtd.nix
    ./root/fish/fish.nix
    ./root/zsh/zsh.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
