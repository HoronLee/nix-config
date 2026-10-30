{ pkgs, ... }:
let
  # LTS 上游会覆盖同名资产：hash 固定内容，覆盖后新机下载会失败，需核对后更新。
  # 此 URL 目前重定向到 amzxyz/rime-wanxiang-data；模型不提交到 Git。
  grammarModel = pkgs.fetchurl {
    url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
    hash = "sha256-40UAq0RibcA5oGQXkuy6mKtjMHZG6z0pGGvlZgj/4JQ=";
  };
in
{
  # 仅链接静态文件，rime/ 本身、build/、userdb 和运行时数据由 Fcitx/Rime 写入。
  xdg.dataFile = {
    "fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
    "fcitx5/rime/wanxiang.custom.yaml".source = ./wanxiang.custom.yaml;
    "fcitx5/rime/wanxiang-lts-zh-hans.gram".source = grammarModel;
  };
}
