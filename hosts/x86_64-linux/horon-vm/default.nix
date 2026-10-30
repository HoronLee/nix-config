{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/base.nix
    ../../../modules/nixos/nix.nix
    ../../../modules/nixos/user.nix
    ../../../modules/nixos/ssh.nix
    ../../../modules/nixos/desktop.nix
    ../../../modules/nixos/niri.nix
    ../../../modules/nixos/input-method.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # 限制启动菜单代次数量及对应的启动分区文件。
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  system.stateVersion = "26.05";
}
