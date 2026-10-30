{ ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # 删除超过 14 天的历史代次，再回收无引用的 store 对象。
      options = "--delete-older-than 14d";
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "configurable-impure-env"
      ];

      # 自动分配构建 UID，替代预创建的 nixbld 用户池。
      auto-allocate-uids = true;

      # 将内容相同的 store 文件合并为硬链接。
      auto-optimise-store = true;

      # 构建期间可用空间低于 5 GiB 时，尝试回收到 10 GiB。
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 10 * 1024 * 1024 * 1024;

      # 二进制缓存；官方缓存由 NixOS 模块保留。
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
    };
  };
}
