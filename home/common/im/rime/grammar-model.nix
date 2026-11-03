{ pkgs }:
pkgs.fetchurl {
  # LTS 上游会覆盖同名资产：hash 固定内容，覆盖后新机下载会失败，需核对后更新。
  # 此 URL 目前重定向到 amzxyz/rime-wanxiang-data；模型不提交到 Git。
  #
  # 更新方法：
  # 1. 取新文件的 SRI hash：
  #    nix store prefetch-file --json \
  #      https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram \
  #      | jq -r .hash
  # 2. 用输出替换下面的 hash。
  # 3. 重新构建/switch，然后在 Fcitx5 或鼠须管中重新部署 Rime。
  url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
  hash = "sha256-40UAq0RibcA5oGQXkuy6mKtjMHZG6z0pGGvlZgj/4JQ=";
}
