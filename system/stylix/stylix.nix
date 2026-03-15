# /etc/nixos/root/stylix.nix
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    enableReleaseChecks = false;

    # 手動定義配色並加入元數據，這樣就不會顯示為 "untitled"
    base16Scheme = {
      scheme = "Catppuccin Macchiato Pink"; # 這裡定義的名字會出現在生成的文件中
      author = "Pukumaru";
      base00 = "24273a"; # base
      base01 = "1e2030"; # mantle
      base02 = "363a4f"; # surface0
      base03 = "494d64"; # surface1
      base04 = "5b6078"; # surface2
      base05 = "cad3f5"; # text
      base06 = "f4dbd6"; # rosewater
      base07 = "b7bdf8"; # lavender
      base08 = "ed8796"; # red
      base09 = "f5a97f"; # peach
      base0A = "eed49f"; # yellow
      base0B = "a6da95"; # green
      base0C = "8bd5ca"; # teal
      base0D = "f5bde6"; # 把原本的 Blue (8aadf4) 換成 Pink (f5bde6)
      base0E = "f5bde6"; # Pink (主要強調色)
      base0F = "c6a0f6"; # mauve
    };

    polarity = "dark";
    image = ./mika-wallpaper.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    cursor = {
      name = "catppuccin-macchiato-pink-cursors";
      package = pkgs.catppuccin-cursors.macchiatoPink;
      size = 24;
    };
  };
}
