{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # hyprpolkitagent 置中浮動
      "float, class:(hyprpolkitagent)"
      "center, class:(hyprpolkitagent)"
      "size 500 250, class:(hyprpolkitagent)"
      "stayfocused, class:(hyprpolkitagent)"
      "dimaround, class:(hyprpolkitagent)"

      # 圓角與動畫
      "rounding 16, class:(hyprpolkitagent)"
      "animation popin 80%, class:(hyprpolkitagent)"
    ];
  };
}
