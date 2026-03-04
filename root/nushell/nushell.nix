# /etc/nixos/root/nushell.nix
{pkgs, ...}: {
  users.users.eric = {
    shell = pkgs.nushell;
  };
  # nushell 套件本身由 root/packages.nix 安裝
}
