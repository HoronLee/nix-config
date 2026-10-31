{ ... }:
{
  imports = [
    ./common/packages.nix
    ./common/git.nix
    ./common/shell.nix
    ./common/ssh.nix
    ./common/yazi.nix
    ./common/neovim.nix
    ./common/terminals
  ];

  home.stateVersion = "26.05";
}
