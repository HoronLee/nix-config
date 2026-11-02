{ config, lib, ... }:
{
  imports = [ ../common/apps.nix ];

  config = lib.mkMerge [
    # nixpkgs 的 clash-verge-rev 只支持 Linux，macOS 使用官方 cask。
    (lib.mkIf config.my.apps.clash-verge.enable {
      homebrew.casks = [ "clash-verge-rev" ];
    })
    (lib.mkIf config.my.apps.ghostty.enable {
      homebrew.casks = [ "ghostty" ];
    })
    (lib.mkIf config.my.apps.orbstack.enable {
      homebrew.casks = [ "orbstack" ];
    })
  ];
}
