{ ... }:
{
  # 允许 unfree 包；Linux 与 macOS 都通过 Nix 管理应用。
  nixpkgs.config.allowUnfree = true;
  # 两个平台都需要的 flake 命令；平台专属 feature 留在各自模块。
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # 两个平台一致的 store 维护：每周回收，删除超过 14 天的历史代次。
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.settings = {
    # 将内容相同的 store 文件合并为硬链接。
    auto-optimise-store = true;
    # 构建期间可用空间低于 5 GiB 时，尝试回收到 10 GiB。
    min-free = 5 * 1024 * 1024 * 1024;
    max-free = 10 * 1024 * 1024 * 1024;
    # 国内镜像与 magpie 缓存；官方 cache.nixos.org 由平台模块追加。
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://magpie.cachix.org"
    ];
    trusted-public-keys = [
      "magpie.cachix.org-1:ITAJciUQeU2SXzGFZvLXLMguTs0Uu9pYjT76gLmW4gs="
    ];
  };
}
