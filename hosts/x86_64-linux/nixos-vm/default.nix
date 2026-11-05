{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/system
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/desktop
    ../../../modules/nixos/desktop/greeter.nix
    ../../../modules/nixos/apps.nix
  ];
  networking.hostName = "nixos-vm";
  system.stateVersion = "26.05";
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # 限制启动菜单代次数量及对应的启动分区文件。
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  # 使用 CachyOS latest 内核
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  my.apps = {
    clash-verge.enable = true;
    ghostty.enable = true;
    obs.enable = true;
  };
}
