{ lib, ... }:
{
  options.my.apps = {
    clash-verge.enable = lib.mkEnableOption "Clash Verge Rev";
    ghostty.enable = lib.mkEnableOption "Ghostty";
    obs.enable = lib.mkEnableOption "OBS Studio";
  };
}
