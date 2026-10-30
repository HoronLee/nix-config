{ config, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    # HM 的 provider 初始化由包装器加载，init.lua 留给现有 LazyVim。
    sideloadInitLua = true;
  };

  # 保留 Lua、插件锁文件和 Extras 设置的可写性，内容通过 Git 同步。
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/common/nvim";
}
