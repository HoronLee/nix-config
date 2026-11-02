{ config, pkgs, ... }:
{
  programs.noctalia.enable = true;

  # Noctalia 在用户目录生成 GTK 色盘；这里只提供主题依赖。
  home.packages = with pkgs; [
    adw-gtk3
  ];

  # 原生 TOML 指向仓库，编辑后由 Noctalia 热加载。
  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/linux/noctalia/config.toml";
  xdg.configFile."noctalia/bar.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/linux/noctalia/bar.toml";

  home.file."Pictures/Wallpapers/nixos-1.png".source = ../../../assets/wallpapers/nixos-1.png;
}
