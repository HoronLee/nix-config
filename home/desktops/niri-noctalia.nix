{ lib, ... }:
{
  imports = [
    ../linux/niri
    ../linux/noctalia
  ];

  xdg.configFile = {
    "niri/config.kdl".text = lib.mkAfter ''
      include "./desktop-niri-noctalia.kdl"
    '';
    "niri/desktop-niri-noctalia.kdl".source = ./niri-noctalia.kdl;
  };
}
