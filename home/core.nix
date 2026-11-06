{ ... }:
{
  imports = [
    ./common/agents
    ./common/packages.nix
    ./common/theme.nix
    ./common/cli
    ./common/tui
    ./common/shell.nix
    ./common/ssh.nix
    ./common/editor/nvim
  ];

  home.stateVersion = "26.05";
}
