# home/nixpak/nixpak.nix
{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;

  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  # ── 共用 helper ────────────────────────────────────────────────────────────

  # Wayland socket bind（runtime）
  waylandBinds = {sloth, ...}: [
    (sloth.concat [(sloth.env "XDG_RUNTIME_DIR") "/wayland-1"])
  ];

  # XDG portal + dconf（大多數 GUI 程式都需要）
  commonDbus = {
    "org.freedesktop.portal.Desktop" = "talk";
    "org.freedesktop.portal.FileChooser" = "talk";
    "org.freedesktop.portal.OpenURI" = "talk";
    "org.freedesktop.Notifications" = "talk";
    "ca.desrt.dconf" = "talk";
  };
  # ── 各程式沙盒定義 ─────────────────────────────────────────────────────────
in {
  # ── 把沙盒包裝好的 binary 裝進 home ────────────────────────────────────────
  home.packages = [
  ];
}
