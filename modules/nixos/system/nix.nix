{ ... }:
{
  nix = {
    # NixOS 的 systemd 定时器使用 calendar 表达式；Darwin 默认每周。
    gc.dates = "weekly";
    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "configurable-impure-env"
      ];
      # 自动分配构建 UID，替代预创建的 nixbld 用户池。
      auto-allocate-uids = true;
      # nix-cachyos-kernel 上游 Hydra 的二进制缓存；只在 NixOS 侧需要。
      # 与 modules/common/nix.nix 的 substituters 列表合并。
      substituters = [ "https://cache.lantian.pub/lantian" ];
      trusted-public-keys = [
        "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      ];
    };
  };
}
