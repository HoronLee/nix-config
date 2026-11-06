{ pkgs, ... }:
{
  imports = [
    ./services.nix
    ./firefox.nix
    ./niri.nix
    ./input-method.nix
    ./keyd.nix
  ];
  # 支持 Magpie 官方桌面二进制及其自更新下载的版本。
  programs.nix-ld.libraries = with pkgs; [
    gtk3
    webkitgtk_4_1
    libsoup_3
    wayland
    libX11
    fontconfig
    gdk-pixbuf
    glib
    dbus
  ];
  # 应用启动器为 Terminal=true 的桌面项选择终端。
  environment.sessionVariables.TERMINAL = "kitty";
  # Qt 6 默认平台主题不上报桌面亮暗，QStyleHints::colorScheme() 返回 Unknown，
  # Prism Launcher 等按“系统”主题的应用会固定为浅色。
  # xdgdesktopportal 由 qtbase 自带，经 XDG Portal 读取 org.freedesktop.appearance。
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
}
