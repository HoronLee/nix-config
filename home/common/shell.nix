{ ... }:
{
  programs.starship = {
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
}
