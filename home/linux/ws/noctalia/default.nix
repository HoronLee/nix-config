{ config, pkgs, ... }:
{
  programs.noctalia.enable = true;

  # Noctalia 在用户目录生成 GTK 色盘；这里只提供主题依赖。
  home.packages = with pkgs; [
    adw-gtk3
  ];

  # 声明式配置由 Home Manager 部署，Noctalia 的运行时改动写入 settings.toml。
  xdg.configFile."noctalia/config.toml".source = ./config.toml;
  xdg.configFile."noctalia/bar.toml".source = ./bar.toml;

  # 壁纸资源不是应用运行时状态；目录通过动态链接指向仓库，便于增删图片。
  home.file = {
    "Pictures/Wallpapers/nixos-long.jpg".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/assets/wallpapers/nixos-long.jpg";
    "Pictures/Wallpapers/light".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/assets/wallpapers/light";
    "Pictures/Wallpapers/dark".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/assets/wallpapers/dark";
  };
}
