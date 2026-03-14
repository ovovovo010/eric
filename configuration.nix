{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./system/fcitx5/fcitx5.nix
    ./system/boot/boot.nix
    ./system/networking/networking.nix
    ./system/locale/locale.nix
    ./system/audio/audio.nix
    ./system/driver/driver.nix
    ./system/desktop/desktop.nix
    ./system/users/users.nix
    ./system/packages/packages.nix
    ./system/stylix/stylix.nix
    ./system/mirror/mirror.nix
    ./system/steam/steam.nix
    ./system/nushell/nushell.nix
    ./system/data/data.nix
    ./system/polkit/polkit.nix
    ./system/flatpak/flatpak.nix
    ./system/thunar/thunar.nix
    ./system/zen/zen.nix
    ./system/clamav/clamav.nix
    ./system/systemd/systemd.nix
    ./system/seatd/seatd.nix
    ./system/wayland/wayland.nix
    ./system/obs/obs.nix
    ./system/zram/zram.nix
    ./system/lact/lact.nix
    ./system/ssh/ssh.nix
    ./system/distrobox/distrobox.nix
    ./system/fish/fish.nix
    ./system/zsh/zsh.nix
    ./system/sched_ext/sched_ext.nix
    ./system/pipewire/pipewire.nix
    ./system/sddm/sddm.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
