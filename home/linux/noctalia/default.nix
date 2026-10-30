{ ... }:
{
  programs.noctalia = {
    enable = true;
    settings = ./config.toml;
  };

  home.file."Pictures/Wallpapers/nixos-1.png".source = ../../../assets/wallpapers/nixos-1.png;
}
