# hardware-configuration.nix 由装机时的 nixos-generate-config 生成；
# 生成前不要在 flake.nix 中注册此 host。
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/system
    ../../../modules/nixos/desktop/niri.nix
    ../../../modules/nixos/desktop/input-method.nix
    ../../../modules/nixos/server.nix
    ../../../modules/nixos/apps.nix
  ];

  networking.hostName = "dell-r430";

  system.stateVersion = "26.05";

  my.apps = {
    clash-verge.enable = true;
    ghostty.enable = true;
  };
}
