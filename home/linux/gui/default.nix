{ ... }:
{
  imports = [
    ./packages.nix
    ./magpie.nix
    ./obs.nix
    ./wayvnc.nix
    ../tui/yazi.nix
  ];
  fonts.fontconfig.enable = true;
}
