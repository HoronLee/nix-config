{ ... }:
{
  imports = [
    ../../common/nix.nix
    ./base.nix
    ./nix.nix
    ./user.nix
    ./ssh.nix
  ];
}
