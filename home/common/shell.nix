{ config, pkgs, ... }:
{
  catppuccin.fish.enable = false;
  catppuccin.starship.enable = false;

  xdg.configFile."fish/themes/catppuccin.theme".source =
    pkgs.runCommand "fish-catppuccin.theme" { }
      ''
        {
          printf '%s\n' '[light]'
          cat "${config.catppuccin.sources.fish}/static/catppuccin-latte.theme"
          printf '%s\n' '[dark]'
          cat "${config.catppuccin.sources.fish}/static/catppuccin-mocha.theme"
          printf '%s\n' '[unknown]'
          cat "${config.catppuccin.sources.fish}/static/catppuccin-mocha.theme"
        } > "$out"
      '';

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_config theme choose catppuccin
      set -g fish_greeting
      mise activate fish | source
    '';
  };

  programs.bash.enable = true;
  programs.starship.enable = true;
}
