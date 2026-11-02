{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.my.apps.obsidian.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
