{
  pkgs,
  lib,
  magpieApp,
  ...
}:
{
  # Magpie 官方二进制不在 Nix 构建；此包固定上游源码并带桌面入口。
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ magpieApp ];
}
