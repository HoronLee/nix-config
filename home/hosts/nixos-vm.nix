{ ... }:
{
  imports = [
    ../default.nix
    ../linux
    ../desktops/niri-noctalia.nix
    ../linux/rime
    ../linux/ssh-agent.nix
  ];
}
