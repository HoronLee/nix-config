{ ... }:
{
  imports = [
    ../default.nix
    ../linux
    ../linux/desktops/niri-noctalia.nix
    ../linux/im/rime
    ../linux/ssh-agent.nix
  ];
}
