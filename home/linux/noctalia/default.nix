{ ... }:
{
  programs.noctalia = {
    enable = true;
    settings = ./config.toml;
  };

  # Noctalia 自动合并配置目录中的 TOML 文件。
  xdg.configFile."noctalia/bar.toml".source = ./bar.toml;

  home.file."Pictures/Wallpapers/nixos-1.png".source = ../../../assets/wallpapers/nixos-1.png;
}
