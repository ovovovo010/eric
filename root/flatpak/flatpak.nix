{...}: {
  services.flatpak = {
    enable = true;

    # 關鍵：在每次 nixos-rebuild switch 時立刻下載/安裝
    update.onActivation = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "com.github.tchx84.Flatseal"
      "org.vinegarhq.Sober"
      "com.usebottles.bottles"
      "net.lutris.Lutris"
      "com.heroicgameslauncher.hgl"
      "io.github.flattool.Warehouse"
    ];
  };
}
