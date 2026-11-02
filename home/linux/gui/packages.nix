{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 文件浏览器
    nautilus

    # 网页浏览器
    microsoft-edge
  ];
}
