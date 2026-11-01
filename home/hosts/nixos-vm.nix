{ ... }:
{
  imports = [
    ../default.nix
    ../linux
    ../linux/desktops/niri-noctalia.nix
    ../linux/rime
    ../linux/ssh-agent.nix
  ];
}
