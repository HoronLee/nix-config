{ config, lib, ... }:
{
  imports = [ ../common/apps.nix ];
  config = lib.mkMerge [
    # macOS 专属 cask。
    {
      homebrew.casks = [
        "orbstack"
        # Karabiner 需要系统扩展和后台 helper，使用官方 cask。
        "karabiner-elements"
      ];
    }
    # nixpkgs 的 clash-verge-rev 只支持 Linux，macOS 使用官方 cask。
    (lib.mkIf config.my.apps.clash-verge.enable {
      homebrew.casks = [ "clash-verge-rev" ];
    })
    (lib.mkIf config.my.apps.ghostty.enable {
      homebrew.casks = [ "ghostty" ];
    })
    (lib.mkIf config.my.apps.obs.enable {
      homebrew.casks = [ "obs" ];
    })
  ];
}
