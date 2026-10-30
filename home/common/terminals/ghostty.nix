{ pkgs, ... }:
{
  home.packages = [ pkgs.maple-mono.NF-CN ];

  programs.ghostty = {
    enable = true;
    settings = {
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
      gtk-tabs-location = "top";

      # 90 ms 主题色光标拖尾；保留背景透明，仅在聚焦分窗运行动画。
      custom-shader = "${./ghostty/shaders/cursor-trail.glsl}";
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
    };
  };
}
