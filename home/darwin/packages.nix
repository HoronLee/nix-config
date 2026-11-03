{ pkgs, ... }:
{
  # 仅提供 Darwin 版本的 CLI 工具。
  home.packages = with pkgs; [
    cocoapods
    macism
    pngpaste
    xcodegen
  ];
}
