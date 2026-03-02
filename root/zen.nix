# ~/nixos-config/root/zen.nix
{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
