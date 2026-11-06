{ pkgs, ... }:
{
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
}
