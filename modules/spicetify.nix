{pkgs, lib, inputs, ...}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    enable = true;
    spotifyPackage = pkgs.spotify;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
];
  };
}
