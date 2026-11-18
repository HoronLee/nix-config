{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ../../../modules/nixos/system
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/desktop
    ../../../modules/nixos/desktop/greeter.nix
    ../../../modules/nixos/apps.nix
  ];
  networking.hostName = "dell-t7810";
  system.stateVersion = "26.05";
  # UEFI + systemd-boot。
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # 限制启动菜单代次数量及对应的启动分区文件。
  boot.loader.systemd-boot.configurationLimit = 10;
  # 使用 CachyOS latest 内核
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # NVIDIA GTX 1080 Ti (Pascal)：主线 595 已不再支持，固定 legacy_580 且使用闭源内核模块。
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    branch = "legacy_580";
    open = false;
  };
  my.apps = {
    clash-verge.enable = true;
    ghostty.enable = true;
    obs.enable = true;
    steam.enable = true;
  };
}
