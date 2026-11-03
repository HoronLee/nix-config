{ pkgs, ... }:
let
  grammarModel = import ../../../common/im/rime/grammar-model.nix { inherit pkgs; };
in
{
  # 仅链接静态文件；rime/ 本身、build/、userdb 和运行时数据由 Fcitx/Rime 写入。
  xdg.dataFile = {
    "fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
    "fcitx5/rime/wanxiang.custom.yaml".source = ../../../common/im/rime/wanxiang.custom.yaml;
    "fcitx5/rime/wanxiang-lts-zh-hans.gram".source = grammarModel;
  };
}
