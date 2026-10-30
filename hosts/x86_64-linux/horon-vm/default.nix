{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/base.nix
    ../../../modules/nixos/user.nix
    ../../../modules/nixos/ssh.nix
    ../../../modules/nixos/desktop.nix
    ../../../modules/nixos/niri.nix
    ../../../modules/nixos/input-method.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  system.stateVersion = "26.05";
}
