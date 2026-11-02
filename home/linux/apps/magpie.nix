{
  pkgs,
  lib,
  magpieApp ? null,
  ...
}:
{
  # 上游只发布 Linux 包，其他平台不传该参数。
  home.packages = lib.optionals (magpieApp != null && pkgs.stdenv.hostPlatform.isLinux) [
    magpieApp
  ];
}
