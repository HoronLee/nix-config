{ pkgs, ... }:

{
  # 文件管理示例，暂不启用。
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;
  #   executable = true;
  # };
  # home.file.".xxx".text = ''
  #   xxx
  # '';

  # 原作者的 X11 DPI 设置，暂不启用。
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  home.packages = with pkgs; [
    # 系统信息与终端文件管理器
    fastfetch
    yazi
    # neofetch  # 已被 fastfetch 替代
    # nnn       # 使用 yazi

    # 压缩与解压
    zip xz unzip p7zip

    # 搜索、数据处理与目录列表
    ripgrep jq yq-go eza fzf

    # 网络诊断与传输
    mtr iperf3 dnsutils ldns aria2 socat nmap ipcalc

    # 杂项基础工具
    cowsay file which tree
    gnused gnutar gawk zstd gnupg

    # Nix 构建日志
    nix-output-monitor

    # 性能与资源监控
    btop iotop iftop

    # 程序调试与文件占用排查
    strace ltrace lsof

    # 系统与硬件信息
    sysstat lm_sensors ethtool pciutils usbutils
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "HoronLee";
      email = "horonlee@foxmail.com";
    };
  };

  programs.starship = {
    enable = true;
  };

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

  fonts.fontconfig.enable = true;

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

  programs.ghostty= {
    enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.bash = {
    enable = true;

    # 暂不添加 PATH 扩展。
    # bashrcExtra = ''
    #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    # '';
  };

  # 简单别名放在这里，可供 HomeManager 管理的 Bash、Zsh、Fish 共用。
  home.shellAliases = {
    ls = "eza";
    ll = "eza -lh";
    la = "eza -lah";
    lt = "eza --tree --level=2";

    # 别名暂不启用。
    # k = "kubectl";
  };

  home.stateVersion = "26.05";
}
