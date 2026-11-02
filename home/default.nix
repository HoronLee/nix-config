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
    ./common/fonts.nix
    ./common/editor/nvim
    ./common/editor/zed
    ./common/terminals
  ];

  home.stateVersion = "26.05";
}
