{ lib, ... }:
{
  imports = [
    ./packages.nix
  ];
  # Home Manager 默认启用 fontconfig；仅由 GUI 层重新开启。
  fonts.fontconfig.enable = lib.mkDefault false;
  # 文件管理示例，暂不启用。
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;
  #   executable = true;
  # };
  # home.file.".xxx".text = ''
  #   xxx
  # '';
  # X11 DPI 设置示例，暂不启用。
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };
}
