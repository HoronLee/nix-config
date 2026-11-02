{ lib, ... }:
{
  options.my.apps = {
    clash-verge.enable = lib.mkEnableOption "Clash Verge Rev";
    ghostty.enable = lib.mkEnableOption "Ghostty";
    orbstack.enable = lib.mkEnableOption "OrbStack";
  };
}
