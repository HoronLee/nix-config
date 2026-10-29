{ ... }:
{
  imports = [
    ./common/git.nix
    ./common/shell.nix
    ./common/terminals
    ./linux
  ];

  home.stateVersion = "26.05";
}
