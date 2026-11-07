{
  pkgs,
  ...
}:
{
  # 由 flake.lock 固定版本；需要 magpie 自更新时改用官方用户目录安装。
  home.packages = [
    pkgs.magpie-cli
  ];
}
