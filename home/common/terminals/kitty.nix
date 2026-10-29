{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.maple-mono.NF-CN;
      name = "Maple Mono NF CN";
      size = 12;
    };
    settings = {
      cursor_trail = 3;
      background_opacity = 0.85;
      # 实际模糊效果取决于合成器。
      background_blur = 1;
      tab_bar_edge = "top";
      enabled_layouts = "splits,fat,grid,horizontal,stack,tall,vertical";
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+[" = "previous_tab";
      "ctrl+shift+]" = "next_tab";
      "ctrl+alt+[" = "previous_window";
      "ctrl+alt+]" = "next_window";
    };
  };
}
