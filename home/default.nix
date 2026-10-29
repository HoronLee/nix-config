{ ... }:
{
  imports = [
    ./common/git.nix
    ./common/shell.nix
    ./common/yazi.nix
    ./common/neovim.nix
    ./common/terminals
    ./linux
  ];

  home.stateVersion = "26.05";
}
