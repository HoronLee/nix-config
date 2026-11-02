{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.my.apps.obs.enable {
    home.packages = [ pkgs.obs-studio ];
  };
}
