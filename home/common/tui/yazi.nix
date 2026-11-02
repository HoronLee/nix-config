{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkFlavor =
    flavor:
    pkgs.linkFarm "yazi-catppuccin-${flavor}" [
      {
        name = "flavor.toml";
        path = "${config.catppuccin.sources.yazi}/${flavor}/catppuccin-${flavor}-${config.catppuccin.accent}.toml";
      }
      {
        name = "tmtheme.xml";
        path = "${config.catppuccin.sources.bat}/Catppuccin ${lib.toSentenceCase flavor}.tmTheme";
      }
    ];
in
{
  catppuccin.yazi.enable = false;

  programs.yazi = {
    enable = true;
    theme.flavor = {
      light = "catppuccin-latte";
      dark = "catppuccin-mocha";
    };
    flavors = {
      catppuccin-latte = mkFlavor "latte";
      catppuccin-mocha = mkFlavor "mocha";
    };
  };
}
