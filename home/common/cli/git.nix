{ config, pkgs, ... }:
{
  catppuccin.lazygit.enable = false;

  programs.git = {
    enable = true;
    settings.user = {
      name = "HoronLee";
      email = "horonlee@foxmail.com";
    };
  };
  programs.lazygit.enable = true;

  home.sessionVariables.LG_CONFIG_FILE = toString (
    pkgs.runCommand "lazygit-catppuccin.yml" { nativeBuildInputs = [ pkgs.yq-go ]; } ''
      yq --null-input '
        .gui.colorScheme = "auto" |
        .gui.darkTheme = load("${config.catppuccin.sources.lazygit}/mocha/${config.catppuccin.accent}.yml").gui.theme |
        .gui.lightTheme = load("${config.catppuccin.sources.lazygit}/latte/${config.catppuccin.accent}.yml").gui.theme
      ' > "$out"
    ''
  );
}
