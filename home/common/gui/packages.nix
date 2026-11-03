{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    # 密码管理
    bitwarden-desktop
    # 网页浏览器
    microsoft-edge
    google-chrome
    # 编辑器；配置与扩展由 Microsoft 账号同步
    vscode
    # Minecraft 启动器
    prismlauncher
    # 笔记
    obsidian
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # macOS 上 Telegram 官方 cask 版本更新，Linux 使用 nixpkgs。
    telegram-desktop
  ];
}
