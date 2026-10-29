{ ... }:
{
  imports = [
    ./packages.nix
    ./yazi.nix
    ./ssh-agent.nix
  ];

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

  # 原作者的 X11 DPI 设置，暂不启用。
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  fonts.fontconfig.enable = true;
}
