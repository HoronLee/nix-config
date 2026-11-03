{ lib, pkgs, ... }:
{
  catppuccin.kitty.enable = false;
  programs.kitty = {
    enable = true;
    autoThemeFiles = {
      light = "Catppuccin-Latte";
      dark = "Catppuccin-Mocha";
      noPreference = "Catppuccin-Mocha";
    };
    font = {
      package = pkgs.maple-mono.NF-CN;
      name = "Maple Mono NF CN";
      size = 12;
    };
    settings = {
      hide_window_decorations = true;
      cursor_trail = 3;
      background_opacity = 0.85;
      # Linux 下由合成器决定模糊；macOS 使用原生模糊半径。
      background_blur = 1;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      enabled_layouts = "splits,fat,grid,horizontal,stack,tall,vertical";
      palette_generate = "semantic";
      pixel_scroll = "yes";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      # 把 macOS 的 Option 键作为 Alt 使用。
      macos_option_as_alt = "yes";
      # macOS 的窗口圆角和标题栏样式。
      hide_window_decorations = "titlebar-only";
      window_margin_width = 6;
      background_blur = 30;
      remember_window_position = "yes";
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+[" = "previous_tab";
      "ctrl+shift+]" = "next_tab";
      "ctrl+alt+[" = "previous_window";
      "ctrl+alt+]" = "next_window";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      # Kitty 默认 cmd+t 新建标签、cmd+enter 新建 pane；
      # 这里让新标签和新 pane 继承当前目录。
      "cmd+t" = "new_tab_with_cwd";
      "cmd+enter" = "new_window_with_cwd";
      "cmd+[" = "previous_window";
      "cmd+]" = "next_window";
      "cmd+shift+o" = "copy_last_command_output";
    };
  };
}
