{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
