{ pkgs, ... }:
{
  programs.herdr = {
    enable = true;
    mutableSettings = true;
    settings = {
      # 不依赖继承的 $SHELL：herdr 服务端若从没有 SHELL 的进程启动（如 agent 会话），
      # default_shell = "" 会回退到 /bin/sh，pane 就变成 sh-5.3$。
      terminal.default_shell = "${pkgs.fish}/bin/fish";
      theme = {
        name = "catppuccin";
        auto_switch = true;
        light_name = "catppuccin-latte";
        dark_name = "catppuccin";
      };
    };
  };
}
