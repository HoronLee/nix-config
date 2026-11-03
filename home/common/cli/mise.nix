{ config, ... }:
{
  # 保留全局配置的可写性，内容通过 Git 同步。
  xdg.configFile."mise/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/projects/nix-config/home/common/cli/mise/config.toml";
}
