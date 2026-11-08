{ pkgs, ... }:
{
  imports = [
    ../common/home-manager.nix
    ../common/nix.nix
    ./apps.nix
  ];
  # 由 nix-darwin 初始化 Fish 环境，避免 macOS 登录时重排 Nix PATH。
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  # sudo 的密码提示走 PAM，与具体 shell 无关：开启后 fish 里的 sudo 直接弹指纹。
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # zellij、tmux 中的 sudo 会脱离登录 bootstrap session，重新挂回后指纹才可用。
    reattach = true;
  };
  # 所有 Darwin 主机统一使用已有 Homebrew；Nix 重建不升级 brew 包。
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "check";
    };
  };
}
