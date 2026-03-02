# /etc/nixos/root/nushell.nix
{pkgs, ...}: {
  users.users.eric = {
    shell = pkgs.nushell;
  };

  environment.systemPackages = [pkgs.nushell];
}
