{ ... }:
{
  programs.herdr = {
    enable = true;
    mutableSettings = true;
    settings = {
      theme = {
        name = "catppuccin";
        auto_switch = true;
        light_name = "catppuccin-latte";
        dark_name = "catppuccin";
      };
    };
  };
}
