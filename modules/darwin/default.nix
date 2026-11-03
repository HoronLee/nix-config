{ pkgs, ... }:
{
  imports = [
    ../common/home-manager.nix
    ../common/nix.nix
    ./apps.nix
  ];
  # 登录 shell 使用系统 profile 中的 Fish。
  environment.systemPackages = [ pkgs.fish ];
  environment.shells = [ pkgs.fish ];
  # 所有 Darwin 主机统一使用已有 Homebrew；Nix 重建不升级 brew 包。
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
  };
}
