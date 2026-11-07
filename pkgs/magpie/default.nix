# 上游 flake 已固定 Magpie 源码和缓存；这里只加本地启动项补丁，
# 并通过 overlay 把 CLI 与桌面包暴露给 nixpkgs。
{ magpie }:
final: _prev:
let
  system = final.stdenv.hostPlatform.system;
  packages = magpie.packages.${system};
in
{
  magpie-cli = packages.magpie-cli;

  # 上游用 os.Executable() 写启动项，会绕过 wrapGAppsHook3 的环境。
  magpie-app = packages.magpie-app.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./exec-wrapper.patch ];
    preFixup = (old.preFixup or "") + ''
      gappsWrapperArgs+=(--set MAGPIE_EXECUTABLE "$out/bin/magpie-app")
    '';
  });
}
