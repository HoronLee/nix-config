{ pkgs, ... }:
let
  grammarModel = import ../../../common/im/rime/grammar-model.nix { inherit pkgs; };
in
{
  # Squirrel 是 macOS 的 Rime 前端，配置目录是 ~/Library/Rime。
  # default.custom.yaml 仍由平台单独维护；这里只共享万象补丁和模型。
  home.file = {
    "Library/Rime/wanxiang.custom.yaml".source = ../../../common/im/rime/wanxiang.custom.yaml;
    "Library/Rime/squirrel.custom.yaml".source = ./squirrel.custom.yaml;
    "Library/Rime/wanxiang-lts-zh-hans.gram".source = grammarModel;
  };
}
