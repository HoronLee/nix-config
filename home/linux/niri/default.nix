{ pkgs, ... }:
{
  # niri 26.04 starts xwayland-satellite on demand when it is on PATH.
  home.packages = [ pkgs.xwayland-satellite ];

  xdg.configFile = {
    "niri/config.kdl".text = builtins.readFile ./config.kdl;
    "niri/cfg" = {
      source = ./cfg;
      recursive = true;
    };
  };

  # 只影响 Linux 上的 Kitty，不改变其他应用的装饰或 macOS 配置。
  programs.kitty.settings.hide_window_decorations = true;
}
