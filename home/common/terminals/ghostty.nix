{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.my.apps.ghostty.enable {
    catppuccin.ghostty.enable = false;
    xdg.configFile."ghostty/themes/catppuccin-latte".source =
      "${config.catppuccin.sources.ghostty}/catppuccin-latte.conf";
    xdg.configFile."ghostty/themes/catppuccin-mocha".source =
      "${config.catppuccin.sources.ghostty}/catppuccin-mocha.conf";
    home.packages = [ pkgs.maple-mono.NF-CN ];
    programs.ghostty = {
      enable = true;
      # macOS 由 cask 安装；Home Manager 只负责配置。
      package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
      settings = {
        theme = "light:catppuccin-latte,dark:catppuccin-mocha";
        # 字体
        font-family = "Maple Mono NF CN";
        font-size = 12;
        # 透明背景
        background-opacity = 0.85;
        background-blur = 1;
        alpha-blending = "native";
        window-padding-x = 0;
        window-padding-y = 0;
        unfocused-split-opacity = 1;
        # macOS 上的光标 smear 拖尾。
        custom-shader = "${./ghostty/shaders/cursor_smear.glsl}";
        custom-shader-animation = true;
        # 新标签和分窗继承当前目录，由 shell 集成跟踪 cd。
        shell-integration = "detect";
        tab-inherit-working-directory = true;
        split-inherit-working-directory = true;
        # 自定义快捷键
        keybind = [
          "ctrl+shift+[=previous_tab"
          "ctrl+shift+]=next_tab"
          "ctrl+alt+[=goto_split:previous"
          "ctrl+alt+]=goto_split:next"
        ];
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        gtk-tabs-location = "top";
      };
    };
  };
}
