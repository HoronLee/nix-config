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
        # Telegram 的 nixpkg 版本明显落后，使用官方 cask。
        "telegram"
        # 鼠须管；nixpkgs 没有可用的 Squirrel Darwin 包。
        "squirrel-app"
        # 以下应用没有可用的 Darwin nixpkg，保留官方 cask。
        "keycastr"
        "motrix"
        "nyaterm"
      ];
    }
    # nixpkgs 的 clash-verge-rev 只支持 Linux，macOS 使用官方 cask。
    (lib.mkIf config.my.apps.clash-verge.enable {
      homebrew.casks = [ "clash-verge-rev" ];
    })
    (lib.mkIf config.my.apps.obs.enable {
      homebrew.casks = [ "obs" ];
    })
    {
      # mole 的 nixpkgs Darwin 构建标记为 broken，使用官方 formula。
      homebrew.brews = [ "mole" ];
    }
  ];
}
