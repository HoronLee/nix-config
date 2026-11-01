{ ... }:
{
  imports = [
    ./common/agents
    ./common/packages.nix
    ./common/theme.nix
    ./common/btop.nix
    ./common/eza.nix
    ./common/fzf.nix
    ./common/git.nix
    ./common/shell.nix
    ./common/ssh.nix
    ./common/yazi.nix
    ./common/neovim.nix
    ./common/terminals
  ];

  home.stateVersion = "26.05";
}
