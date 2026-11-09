{ config, ... }:
{
  catppuccin.zed.enable = false;

  programs.zed-editor = {
    enable = true;
    # 设置和快捷键由仓库文件提供，Zed 负责写入。
    mutableUserSettings = false;
    mutableUserKeymaps = false;
  };

  # Zed 写入 settings.json 前会 canonicalize，keymap.json 直接写入；
  # 文件符号链接会保留，GUI 修改会落到仓库。
  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/common/editor/zed/settings.json";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/common/editor/zed/keymap.json";
}
