{
  config,
  pkgs,
  lib,
  ...
}: let
  # 從你的 Hyprland 繼承的程式
  terminal = "kitty";
  launcher = "rofi -show drun";

  # Openbox 主設定檔內容（純浮動、極簡）
  rcXml = pkgs.writeText "openbox-rc.xml" ''
    <?xml version="1.0"?>
    <openbox_config xmlns="http://openbox.org/3.4/rc">
      <focus>
        <focusNew>yes</focusNew>
        <followMouse>no</followMouse>
        <focusLast>yes</focusLast>
        <raiseOnFocus>yes</raiseOnFocus>
      </focus>
      <mouse>
        <context name="Frame">
          <mousebind button="A-Left" action="Drag">
            <action name="Move"/>
          </mousebind>
          <mousebind button="A-Right" action="Drag">
            <action name="Resize"/>
          </mousebind>
        </context>
        <context name="Root">
          <mousebind button="Right" action="Press">
            <action name="ShowMenu"><menu>root-menu</menu></action>
          </mousebind>
        </context>
      </mouse>
      <keyboard>
        <keybind key="A-F4"><action name="Close"/></keybind>
        <keybind key="A-Tab"><action name="NextWindow"/></keybind>
      </keyboard>
      <applications>
        <!-- 有問題的應用程式規則可在這裡加入 -->
      </applications>
      <theme>
        <name>Clearlooks</name>
        <titleLayout>NLIMC</titleLayout>
        <keepBorder>yes</keepBorder>
        <animateIconify>no</animateIconify>
      </theme>
    </openbox_config>
  '';

  # 右鍵選單設定檔
  menuXml = pkgs.writeText "openbox-menu.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu xmlns="http://openbox.org/">
      <menu id="root-menu" label="Openbox">
        <item label="Terminal (kitty)">
          <action name="Execute">
            <command>${terminal}</command>
          </action>
        </item>
        <item label="Application Launcher (rofi)">
          <action name="Execute">
            <command>${launcher}</command>
          </action>
        </item>
        <separator/>
        <item label="Reconfigure Openbox">
          <action name="Reconfigure"/>
        </item>
        <item label="Exit Openbox">
          <action name="Exit"/>
        </item>
      </menu>
    </openbox_menu>
  '';
in {
  # 將設定檔放到 ~/.config/openbox/ 下（openbox-session 會自動讀取）
  home.file.".config/openbox/rc.xml".source = rcXml;
  home.file.".config/openbox/menu.xml".source = menuXml;

  # 提供方便的腳本：openbox-run <應用程式>
  home.file.".local/bin/openbox-run" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      if [ -z "$1" ]; then
        echo "用法: openbox-run <應用程式指令>"
        echo "範例: openbox-run firefox"
        exit 1
      fi
      exec ${pkgs.openbox}/bin/openbox --startup "$@" --config "${rcXml}"
    '';
    executable = true;
  };

  # 讓 regreetd（或其他顯示管理器）可以選擇 Openbox 工作階段
  xdg.dataFile."xsessions/openbox-nix.desktop".text = ''
    [Desktop Entry]
    Name=Openbox (Nix)
    Comment=Minimal floating Openbox session for problematic apps
    Exec=${pkgs.openbox}/bin/openbox-session
    Type=Application
  '';
}
