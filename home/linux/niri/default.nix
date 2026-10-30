{ pkgs, ... }:
{
  # niri 26.04 starts xwayland-satellite on demand when it is on PATH.
  home.packages = [ pkgs.xwayland-satellite ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
