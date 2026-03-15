{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.noctalia.packages.${pkgs.system}.default
  ];
}
