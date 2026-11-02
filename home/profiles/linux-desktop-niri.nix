{ ... }:
{
  imports = [
    ../gui.nix
    ../linux
    ../linux/gui
    ../linux/desktops/niri-noctalia.nix
    ../linux/im/rime
    ../linux/ssh-agent.nix
  ];
}
