{ config, lib, ... }:
{
  imports = [ ../common/apps.nix ];
  config = lib.mkMerge [
    # 第三方 cask 来源；cleanup = "check" 会检查 tap 是否在 Brewfile 中。
    {
      homebrew.taps = [
        "nyakang/nyaterm"
        "penso/tap"
      ];
    }
    # brew formula 形式的 CLI 工具。
    {
      homebrew.brews = [ "mole" ];
    }
    {
      homebrew.casks = [
        # nixpkgs 的 orbstack 只从 dmg 解包 App，不安装 privileged helper；使用官方 cask。
        "orbstack"
        # Karabiner 已停用：Hyper 键与 hyper 快捷键改由 Tinycast 提供。
        # 配置保留在 home/darwin/input/karabiner，需要时取消注释即可恢复。
        # "karabiner-elements"
        # Telegram 的 nixpkg 版本明显落后，使用官方 cask。
        "telegram"
        # 鼠须管；nixpkgs 没有可用的 Squirrel Darwin 包。
        "squirrel-app"
        # nixpkgs 版本落后且上游 auto_updates，使用官方 cask。
        "keycastr"
        "betterdisplay"
        "stats"
        "rustdesk"
        # nixpkgs 只有 0.10.3-beta，官方 cask 是 0.12.8 且上游 auto_updates。
        "tinycast"
        # 以下应用没有可用的 Darwin nixpkg，保留官方 cask。
        "motrix"
        "nyaterm"
        "apifox"
        "herdr-gpui"
        "another-redis-desktop-manager"
        "background-music"
      ];
    }
    # 以下软件在 nixpkgs 只支持 Linux；macOS 使用官方 cask，由 my.apps 统一开关。
    (lib.mkIf config.my.apps.clash-verge.enable {
      homebrew.casks = [ "clash-verge-rev" ];
    })
    (lib.mkIf config.my.apps.obs.enable {
      homebrew.casks = [ "obs" ];
    })
  ];
}
