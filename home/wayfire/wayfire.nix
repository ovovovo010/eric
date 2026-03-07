# home/wayfire/wayfire.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    wayfire
    wcm
  ];

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
      blur

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
    active_color   = 0x89b4faee
    inactive_color = 0x595959aa
    text_color     = 0xcdd6f4ff

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

    # ── 自動啟動 ─────────────────────────────────────────────
    [autostart]
    autostart_wf_shell = false
    fcitx5    = fcitx5 -d
    wallpaper = swww-daemon & swww img /etc/nixos/root/wallpaper.png
    mako      = mako
    cursor    = hyprctl setcursor catppuccin-mocha-lavender-cursors 24
    bar       = waybar

    # ── 視窗規則 ─────────────────────────────────────────────
    [window-rules]
    rule_claude = on created if app_id is "Claude" \
      then set floating true; set geometry 100 100 1000 750

    rule_opacity_kitty = on created if app_id is "kitty" \
      then set opacity 0.85

    # ── Wobbly ───────────────────────────────────────────────
    [wobbly]
    spring_k = 8.0
    friction = 3.0
    mass     = 30.0
  '';
}
