{ ... }:
{
  imports = [
    ./packages.nix
    ./magpie.nix
    ./obs.nix
    ../tui/yazi.nix
  ];
  fonts.fontconfig.enable = true;
}
