{
  pkgs,
  lib,
  inputs,
  ...
}: let
  colors = {
    active = "rgba(f5bde6ee) rgba(c6a0f6ee) rgba(b7bdf8ee) 45deg";
    inactive = "rgba(6e738daa)";
    shadow = "rgba(1a1a1aee)";
  };

  mainMod = "SUPER";

  workspaceBinds = builtins.concatLists (builtins.genList (
      i: let
        num = toString (i + 1);
      in [
        "${mainMod}, ${num}, vswitch, workspace_${num}"
        "${mainMod} SHIFT, ${num}, vswitch, move_window_to_workspace_${num}"
      ]
    )
    9);

  extraWorkspace = [
    "${mainMod}, 0, vswitch, workspace_10"
    "${mainMod} SHIFT, 0, vswitch, move_window_to_workspace_10"
  ];
in {
  home.file.".config/wayfire.ini".text = ''
    [core]
    plugins = alpha animate autostart command cube decoration expo fast-switcher fisheye foreign-toplevel invert move oswitch place resize session-lock shortcuts-inhibit switcher vswitch  window-rules wm-actions wobbly wrot zoom simple-tile
    preferred_decoration_mode = client
    vwidth = 10
    vheight = 1
    close_top_view = <super> KEY_Q

    [autostart]
    0_env = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
    fcitx5 = fcitx5 -d
    noctalia = noctalia-shell

    [command]
    binding_terminal = <${mainMod}> KEY_Q
    command_terminal = kitty

    binding_filemanager = <${mainMod}> KEY_E
    command_filemanager = kitty -e yazi

    binding_menu = <${mainMod}> KEY_R
    command_menu = noctalia-shell ipc call launcher toggle

    binding_screenshot_region_clip = <${mainMod}> SHIFT KEY_S
    command_screenshot_region_clip = grim -g "$(slurp)" - | wl-copy

    binding_screenshot_full_clip = KEY_PRINT
    command_screenshot_full_clip = grim - | wl-copy

    binding_screenshot_region_save = <${mainMod}> KEY_PRINT
    command_screenshot_region_save = grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%T).png

    binding_kill = <${mainMod}> KEY_C
    command_kill = wm-actions kill

    binding_toggle_float = <${mainMod}> KEY_V
    command_toggle_float = wm-actions toggle_float

    binding_focus_left = <${mainMod}> KEY_LEFT
    command_focus_left = simple-tile focus_left

    binding_focus_right = <${mainMod}> KEY_RIGHT
    command_focus_right = simple-tile focus_right

    binding_focus_up = <${mainMod}> KEY_UP
    command_focus_up = simple-tile focus_above

    binding_focus_down = <${mainMod}> KEY_DOWN
    command_focus_down = simple-tile focus_below

    ${builtins.concatStringsSep "\n" workspaceBinds}
    ${builtins.concatStringsSep "\n" extraWorkspace}

    [move]
    activate = <${mainMod}> BTN_LEFT

    [resize]
    activate = <${mainMod}> BTN_RIGHT

    [simple-tile]
    inner_gap = 5
    outer_horiz = 20
    outer_vert = 20
    tile_by_default = true
    animation_duration = 300

    key_focus_left = <${mainMod}> KEY_LEFT
    key_focus_right = <${mainMod}> KEY_RIGHT
    key_focus_above = <${mainMod}> KEY_UP
    key_focus_below = <${mainMod}> KEY_DOWN

    key_move_left = <${mainMod}> SHIFT KEY_LEFT
    key_move_right = <${mainMod}> SHIFT KEY_RIGHT
    key_move_above = <${mainMod}> SHIFT KEY_UP
    key_move_below = <${mainMod}> SHIFT KEY_DOWN

    key_resize = <${mainMod}> KEY_P

    [decoration]
    rounding = 20
    active_opacity = 0.8
    inactive_opacity = 0.6

    shadow = true
    shadow_radius = 15
    shadow_opacity = 0.5
    shadow_color = ${colors.shadow}

    blur = true
    blur_radius = 13
    blur_passes = 1

    [animate]
    enabled = true

    [grid]
    slot_l = <${mainMod}> KEY_LEFT
    slot_r = <${mainMod}> KEY_RIGHT
    slot_c = <${mainMod}> KEY_UP
    slot_bl = <${mainMod}> KEY_KP1
    slot_br = <${mainMod}> KEY_KP3

    [vswitch]
    binding_left = <ctrl> <${mainMod}> KEY_LEFT
    binding_right = <ctrl> <${mainMod}> KEY_RIGHT
    binding_up = <ctrl> <${mainMod}> KEY_UP
    binding_down = <ctrl> <${mainMod}> KEY_DOWN

    with_win_left = <ctrl> <${mainMod}> SHIFT KEY_LEFT
    with_win_right = <ctrl> <${mainMod}> SHIFT KEY_RIGHT

    [expo]
    toggle = <${mainMod}> KEY_E

  '';
}
