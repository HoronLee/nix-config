{ ... }:
{
  imports = [ ./kitty.nix ];

  programs.alacritty = {
    enable = true;
    # 暂用默认设置，保留原自定义配置供以后参考。
    # settings = {
    #   env.TERM = "xterm-256color";
    #   font.size = 12;
    #   colors.draw_bold_text_with_bright_colors = true;
    #   scrolling.multiplier = 5;
    #   selection.save_to_clipboard = true;
    # };
  };

  programs.ghostty= {
    enable = true;
  };
}
