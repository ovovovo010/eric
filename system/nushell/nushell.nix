# /etc/nixos/root/nushell.nix
{pkgs, ...}: {
  environment.shells = with pkgs; [nushell];
}
