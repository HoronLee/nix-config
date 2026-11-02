{ config, lib, ... }:
{
  imports = [ ../common/apps.nix ];

  config = lib.mkIf config.my.apps.clash-verge.enable {
    programs.clash-verge = {
      enable = true;
      serviceMode = true;
      tunMode = true;
      autoStart = true;
    };
  };
}
