{ config, pkgs, ... }:
{
  catppuccin.lazygit.enable = false;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "HoronLee";
        email = "horonlee@foxmail.com";
      };
      # 在冲突块中同时展示共同祖先，便于判断双方改动。
      merge.conflictStyle = "zdiff3";
      # 记住已解决的同类冲突，减少反复 rebase 时的重复处理。
      rerere.enabled = true;
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
