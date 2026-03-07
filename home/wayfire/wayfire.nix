# ~/.config/home-manager/wayfire.nix  (或直接并入 home.nix)
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
    base = 0 x1e1e2eff;
    mantle = 0 x181825ff;
    crust = 0 x11111bff;
  };
in {
  home.packages = with pkgs; [
    # 工具链（与 Hyprland 保持一致）
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
    pulseaudio # 提供 wpctl 替代？实际 wpctl 属于 wireplumber，默认已安装
    wireplumber
  ];

  # 为 NVIDIA 设置必要的环境变量（可防止破图、提升性能）
  home.sessionVariables = {
    # 强制 Wayfire 使用 Vulkan 渲染器（对 NVIDIA 更友好）
    WLR_RENDERER = "vulkan";
    # 告诉 GL 库使用 NVIDIA 专有驱动
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # 光标主题与大小（Hyprland 风格）
    XCURSOR_THEME = "catppuccin-mocha-lavender-cursors";
    XCURSOR_SIZE = "24";
    # 让 Qt 应用使用 Wayland 后端
    QT_QPA_PLATFORM = "wayland";
  };

  # Wayfire 主配置文件
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

    # ---- 动画 ----
    [animate]
    open_animation  = zoom
    close_animation = zoom
    duration        = 250
    zoom_factor     = 0.87

    # ---- 窗口装饰（Catppuccin Mocha）----
    [decoration]
    title_height   = 32
    border_size    = 2
    corner_radius  = 20
    font           = JetBrainsMono Nerd Font Bold 10
    active_color   = ${toString mocha.surface0}
    inactive_color = ${toString mocha.surface2}
    text_color     = ${toString mocha.text}

    # ---- 模糊效果 ----
    [blur]
    method    = kawase
    iterations = 2
    offset    = 5

    # ---- 移动 / 缩放 ----
    [move]
    activate = <super> BTN_LEFT

    [resize]
    activate = <super> BTN_RIGHT

    # ---- 窗口放置（默认浮动，无需平铺插件）----
    [place]
    mode = center  # 新窗口默认居中

    # ---- 快捷键 ----
    [command]
    # 终端
    binding_terminal     = <super> KEY_Q
    command_terminal     = kitty

    # 文件管理器 (yazi)
    binding_filemanager  = <super> KEY_E
    command_filemanager  = kitty -e yazi

    # 应用启动器 (rofi)
    binding_launcher     = <super> KEY_R
    command_launcher     = rofi -show drun

    # 锁屏 (hyprlock)
    binding_lock         = <super> KEY_L
    command_lock         = hyprlock

    # 注销/电源菜单 (wlogout)
    binding_logout       = <super> <shift> KEY_E
    command_logout       = wlogout

    # 全屏截图（保存到剪贴板）
    binding_screenshot        = KEY_PRINT
    command_screenshot        = hyprshot -m output --clipboard-only

    # 区域截图（保存到文件）
    binding_screenshot_region = <super> KEY_PRINT
    command_screenshot_region = hyprshot -m region -o ~/Pictures/Screenshots

    # 区域截图（保存到剪贴板）
    binding_screenshot_clip   = <super> <shift> KEY_S
    command_screenshot_clip   = hyprshot -m region --clipboard-only

    # 音量控制 (wpctl)
    binding_vol_up   = KEY_VOLUMEUP
    command_vol_up   = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

    binding_vol_down = KEY_VOLUMEDOWN
    command_vol_down = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

    binding_mute     = KEY_MUTE
    command_mute     = wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # 屏幕亮度 (需要 brightnessctl 并赋予适当权限)
    binding_bright_up   = KEY_BRIGHTNESSUP
    command_bright_up   = brightnessctl set +5%

    binding_bright_down = KEY_BRIGHTNESSDOWN
    command_bright_down = brightnessctl set 5%-

    # 媒体控制 (playerctl)
    binding_play_pause = KEY_PLAYPAUSE
    command_play_pause = playerctl play-pause

    binding_next       = KEY_NEXTSONG
    command_next       = playerctl next

    binding_prev       = KEY_PREVIOUSSONG
    command_prev       = playerctl previous

    # ---- 自动启动 ----
    [autostart]
    # 禁用内置的 wayfire 面板（我们使用 waybar）
    autostart_wf_shell = false

    # 输入法
    fcitx5    = fcitx5 -d

    # 壁纸 (swww)
    wallpaper = swww-daemon --daemonize && swww img /etc/nixos/root/wallpaper.png

    # 通知守护
    mako      = mako

    # 状态栏
    bar       = waybar

    # 设置 GTK 主题 (需提前安装)
    # gsettings set org.gnome.desktop.interface gtk-theme Catppuccin-Mocha-Standard-Lavender-Dark
    # gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark

    # ---- 窗口规则 ----
    [window-rules]
    # Claude 桌面版：浮动并固定大小位置
    rule_claude = on created if app_id is "Claude" \
      then set floating true; set geometry 100 100 1000 750

    # Kitty 终端：半透明效果 (与 blur 配合更佳)
    rule_opacity_kitty = on created if app_id is "kitty" \
      then set opacity 0.90

    # 浮动对话框/弹出窗强制浮动（防止某些应用误平铺）
    rule_dialogs_float = on created if window_type is "dialog" \
      then set floating true

    # ---- Wobbly 效果 ----
    [wobbly]
    spring_k = 8.0
    friction = 3.0
    mass     = 30.0
  '';
}
