# home/openbox/openbox.nix
{ pkgs, ... }: let
  terminal = "kitty";
  launcher = "rofi -show drun";
in {
  home.packages = with pkgs; [
    openbox
    obconf
    xorg.xinit
    xorg.xorgserver
    picom
  ];

  # ── rc.xml ────────────────────────────────────────────────
  xdg.configFile."openbox/rc.xml".text = ''
    <?xml version="1.0"?>
    <openbox_config xmlns="http://openbox.org/3.4/rc">

      <focus>
        <focusNew>yes</focusNew>
        <followMouse>no</followMouse>
        <focusLast>yes</focusLast>
        <raiseOnFocus>no</raiseOnFocus>
      </focus>

      <placement>
        <policy>Smart</policy>
      </placement>

      <theme>
        <name>Catppuccin-Mocha</name>
        <titleLayout>NLIMC</titleLayout>
        <keepBorder>yes</keepBorder>
        <animateIconify>no</animateIconify>
        <font place="ActiveWindow">
          <name>JetBrainsMono Nerd Font</name>
          <size>10</size>
          <weight>Bold</weight>
        </font>
        <font place="InactiveWindow">
          <name>JetBrainsMono Nerd Font</name>
          <size>10</size>
          <weight>Normal</weight>
        </font>
      </theme>

      <desktops>
        <number>4</number>
        <firstdesk>1</firstdesk>
        <names>
          <name>1</name>
          <name>2</name>
          <name>3</name>
          <name>4</name>
        </names>
      </desktops>

      <mouse>
        <dragThreshold>8</dragThreshold>
        <context name="Frame">
          <mousebind button="A-Left" action="Drag">
            <action name="Move"/>
          </mousebind>
          <mousebind button="A-Right" action="Drag">
            <action name="Resize"/>
          </mousebind>
          <mousebind button="A-Middle" action="Press">
            <action name="Lower"/>
          </mousebind>
        </context>
        <context name="Titlebar">
          <mousebind button="Left" action="Drag">
            <action name="Move"/>
          </mousebind>
          <mousebind button="Left" action="DoubleClick">
            <action name="ToggleMaximize"/>
          </mousebind>
          <mousebind button="Up" action="Scroll">
            <action name="IconifyWindow"/>
          </mousebind>
        </context>
        <context name="Root">
          <mousebind button="Right" action="Press">
            <action name="ShowMenu"><menu>root-menu</menu></action>
          </mousebind>
          <mousebind button="Middle" action="Press">
            <action name="ShowMenu"><menu>client-list-combined-menu</menu></action>
          </mousebind>
        </context>
        <context name="Desktop">
          <mousebind button="Up" action="Scroll">
            <action name="GoToDesktop"><to>previous</to></action>
          </mousebind>
          <mousebind button="Down" action="Scroll">
            <action name="GoToDesktop"><to>next</to></action>
          </mousebind>
        </context>
      </mouse>

      <keyboard>
        <chainQuitKey>C-g</chainQuitKey>

        <!-- 基本 -->
        <keybind key="A-F4">
          <action name="Close"/>
        </keybind>
        <keybind key="A-Tab">
          <action name="NextWindow"/>
        </keybind>
        <keybind key="A-S-Tab">
          <action name="PreviousWindow"/>
        </keybind>

        <!-- 啟動程式 -->
        <keybind key="Super_L">
          <action name="Execute">
            <command>${launcher}</command>
          </action>
        </keybind>
        <keybind key="Super-Return">
          <action name="Execute">
            <command>${terminal}</command>
          </action>
        </keybind>

        <!-- 視窗管理 -->
        <keybind key="Super-q">
          <action name="Close"/>
        </keybind>
        <keybind key="Super-f">
          <action name="ToggleFullscreen"/>
        </keybind>
        <keybind key="Super-m">
          <action name="ToggleMaximize"/>
        </keybind>
        <keybind key="Super-h">
          <action name="Iconify"/>
        </keybind>

        <!-- 視窗移動到各桌面 -->
        <keybind key="Super-1">
          <action name="GoToDesktop"><to>1</to></action>
        </keybind>
        <keybind key="Super-2">
          <action name="GoToDesktop"><to>2</to></action>
        </keybind>
        <keybind key="Super-3">
          <action name="GoToDesktop"><to>3</to></action>
        </keybind>
        <keybind key="Super-4">
          <action name="GoToDesktop"><to>4</to></action>
        </keybind>
        <keybind key="Super-S-1">
          <action name="SendToDesktop"><to>1</to></action>
        </keybind>
        <keybind key="Super-S-2">
          <action name="SendToDesktop"><to>2</to></action>
        </keybind>
        <keybind key="Super-S-3">
          <action name="SendToDesktop"><to>3</to></action>
        </keybind>
        <keybind key="Super-S-4">
          <action name="SendToDesktop"><to>4</to></action>
        </keybind>

        <!-- 視窗位置 snap -->
        <keybind key="Super-Left">
          <action name="UnmaximizeFull"/>
          <action name="MoveResizeTo">
            <x>0</x><y>0</y>
            <width>50%</width><height>100%</height>
          </action>
        </keybind>
        <keybind key="Super-Right">
          <action name="UnmaximizeFull"/>
          <action name="MoveResizeTo">
            <x>50%</x><y>0</y>
            <width>50%</width><height>100%</height>
          </action>
        </keybind>
        <keybind key="Super-Up">
          <action name="ToggleMaximize"/>
        </keybind>
        <keybind key="Super-Down">
          <action name="UnmaximizeFull"/>
          <action name="MoveResizeTo">
            <x>10%</x><y>10%</y>
            <width>80%</width><height>80%</height>
          </action>
        </keybind>
      </keyboard>

    </openbox_config>
  '';

  # ── menu.xml ──────────────────────────────────────────────
  xdg.configFile."openbox/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu xmlns="http://openbox.org/">
      <menu id="root-menu" label="Menu">
        <item label="Terminal">
          <action name="Execute"><command>${terminal}</command></action>
        </item>
        <item label="Launcher">
          <action name="Execute"><command>${launcher}</command></action>
        </item>
        <separator/>
        <item label="Reconfigure">
          <action name="Reconfigure"/>
        </item>
        <item label="Exit">
          <action name="Exit"/>
        </item>
      </menu>
    </openbox_menu>
  '';

  # ── autostart ─────────────────────────────────────────────
  xdg.configFile."openbox/autostart".text = ''
    # compositor
    picom --daemon &

    # 桌面壁紙
    feh --bg-fill ~/wallpaper.png &
  '';

  # ── xinitrc（startx 用）───────────────────────────────────
  home.file.".xinitrc".text = ''
    exec ${pkgs.openbox}/bin/openbox-session
  '';
}
