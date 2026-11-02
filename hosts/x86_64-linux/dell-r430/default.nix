# hardware-configuration.nix 由装机时的 nixos-generate-config 生成；
# 生成前不要在 flake.nix 中注册此 host。
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/system
    ../../../modules/nixos/server.nix
  ];

  networking.hostName = "dell-r430";

  # 使用 26.05 ISO 安装，状态版本保持安装时的 release。
  system.stateVersion = "26.05";
}
