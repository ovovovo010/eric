{ pkgs, inputs, ... }: {
  imports = [
    # 可以在這裡引用共用模組
  ];

  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
  # programs.hyprland.enable = true; # disabled until the module is available

  # 這裡放 user1 專屬的 home.packages 或 program 設定
  home.packages = with pkgs; [
    # 例如：
    # rofi
    # kitty
  ];
}
