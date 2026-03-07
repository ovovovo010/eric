## home/wayfire/wayfire.nix
{pkgs, ...}: let
  # Catppuccin Mocha 颜色 (RGBA 格式，Wayfire 使用 0xRRGGBBAA)
  mocha = {
    rosewater = 0 xf5e0dcee;
    flamingo = 0 xf2cdcdee;
    pink = 0 xf5c2e7ee;
    mauve = 0 xcba6f7ee;
    red = 0 xf38ba8ee;
    maroon = 0 xeba0acee;
    peach = 0 xfab387ee;
    yellow = 0 xf9e2afee;
    green = 0 xa6e3a1ee;
    teal = 0 x94e2d5ee;
    sky = 0 x89dcebee;
    sapphire = 0 x74c7ecee;
    blue = 0 x89b4faee;
    lavender = 0 xb4befe;
    text = 0 xcdd6f4ff;
    subtext1 = 0 xbac2deff;
    subtext0 = 0 xa6adc8ff;
    overlay2 = 0 x9399b2ff;
    overlay1 = 0 x7f849cff;
    overlay0 = 0 x6c7086ff;
    surface2 = 0 x585b70ff;
    surface1 = 0 x45475aff;
    surface0 = 0 x313244ff;
    base = 0 x1e1e2eff; # 之前错误是这里写了空格：0 x1e1e2eff
    mantle = 0 x181825ff;
    crust = 0 x11111bff;
  };
in {
  home.packages = with pkgs; [
    kitty
    yazi
    rofi-wayland
    hyprlock
    wlogout
    hyprshot
    swww
    mako
    waybar
    fcitx5
    fcitx5-gtk
    libnotify
    brightnessctl
    playerctl
    pamixer
    pulseaudio
    wireplumber
  ];

  home.sessionVariables = {
    WLR_RENDERER = "vulkan";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XCURSOR_THEME = "catppuccin-mocha-lavender-cursors";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
  };

  xdg.configFile."wayfire.ini".text = ''
    [core]
    plugins = \
      animate \
      autostart \
      command \
      decoration \
      move \
      place \
      resize \
      wm-actions \
      wobbly \
      blur \
      window-rules

    xwayland = true
    close_top_view = <super> KEY_C | <alt> KEY_F4

    # ── 動畫 ────────────────────────────────────────────────
    [animate]
    open_animation  = zoom
    close_animation = zoom
    duration        = 250
    zoom_factor     = 0.87

    # ── 視窗裝飾（Catppuccin Mocha）──────────────────────────
    [decoration]
    title_height   = 32
    border_size    = 2
    corner_radius  = 20
    font           = JetBrainsMono Nerd Font Bold 10
    active_color   = ${toString mocha.surface0}
    inactive_color = ${toString mocha.surface2}
    text_color     = ${toString mocha.text}

    # ── 模糊 ─────────────────────────────────────────────────
    [blur]
    method    = kawase
    iterations = 2
    offset    = 5

    # ── 移動/縮放 ────────────────────────────────────────────
    [move]
    activate = <super> BTN_LEFT

    [resize]
    activate = <super> BTN_RIGHT

    # ── 視窗放置（預設居中，純浮動）────────────────────────────
    [place]
    mode = center

    # ── 快捷鍵 ───────────────────────────────────────────────
    [command]
    binding_terminal     = <super> KEY_Q
    command_terminal     = kitty

    binding_filemanager  = <super> KEY_E
    command_filemanager  = kitty -e yazi

    binding_launcher     = <super> KEY_R
    command_launcher     = rofi -show drun

    binding_lock         = <super> KEY_L
    command_lock         = hyprlock

    binding_logout       = <super> <shift> KEY_E
    command_logout       = wlogout

    binding_screenshot        = KEY_PRINT
    command_screenshot        = hyprshot -m output --clipboard-only

    binding_screenshot_region = <super> KEY_PRINT
    command_screenshot_region = hyprshot -m region -o ~/Pictures/Screenshots

    binding_screenshot_clip   = <super> <shift> KEY_S
    command_screenshot_clip   = hyprshot -m region --clipboard-only

    binding_vol_up   = KEY_VOLUMEUP
    command_vol_up   = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

    binding_vol_down = KEY_VOLUMEDOWN
    command_vol_down = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

    binding_mute     = KEY_MUTE
    command_mute     = wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    binding_bright_up   = KEY_BRIGHTNESSUP
    command_bright_up   = brightnessctl set +5%

    binding_bright_down = KEY_BRIGHTNESSDOWN
    command_bright_down = brightnessctl set 5%-

    binding_play_pause = KEY_PLAYPAUSE
    command_play_pause = playerctl play-pause

    binding_next       = KEY_NEXTSONG
    command_next       = playerctl next

    binding_prev       = KEY_PREVIOUSSONG
    command_prev       = playerctl previous

    # ── 自動啟動 ─────────────────────────────────────────────
    [autostart]
    autostart_wf_shell = false
    fcitx5    = fcitx5 -d
    wallpaper = swww-daemon --daemonize && swww img /etc/nixos/root/wallpaper.png
    mako      = mako
    bar       = waybar

    # ── 視窗規則（純浮動）─────────────────────────────────────
    [window-rules]
    rule_claude = on created if app_id is "Claude" \
      then set floating true; set geometry 100 100 1000 750

    rule_opacity_kitty = on created if app_id is "kitty" \
      then set opacity 0.90

    rule_dialogs_float = on created if window_type is "dialog" \
      then set floating true

    # ── Wobbly ───────────────────────────────────────────────
    [wobbly]
    spring_k = 8.0
    friction = 3.0
    mass     = 30.0
  '';
}
