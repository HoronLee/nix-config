{ ... }:
{
  # 允许 unfree 包；Linux 与 macOS 都通过 Nix 管理应用。
  nixpkgs.config.allowUnfree = true;
  # 两个平台都需要的 flake 命令；平台专属 feature 留在各自模块。
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
