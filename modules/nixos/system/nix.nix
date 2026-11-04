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
    };
  };
}
