{ config, pkgs, ... }:
{
  # Catppuccin 的加载与亮暗选择由 LazyVim Lua 配置负责。
  catppuccin.nvim.enable = false;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    # HM 的 provider 初始化由包装器加载，init.lua 保留给 LazyVim。
    sideloadInitLua = true;
    # 编辑器进程内的 LSP、linter、formatter；终端与 CI 也会用的放在 home/common/packages.nix。
    extraPackages = with pkgs; [
      api-linter
      ast-grep
      bash-language-server
      clang-tools # clangd
      cmake-format # cmake-format / cmake-lint
      cmake-language-server
      dart # dartls
      docker-compose-language-service
      dockerfile-language-server
      gofumpt
      gotools # goimports
      gopls
      hadolint
      helm-ls
      jdt-language-server # jdtls
      just-lsp
      lua-language-server
      markdown-toc
      markdownlint-cli2
      marksman
      neocmakelsp
      nixd
      prisma-language-server
      pyright
      ruff
      rust-analyzer
      shellcheck
      shfmt
      sqlfluff
      sqls
      stylua
      tailwindcss-language-server
      taplo
      vscode-langservers-extracted # jsonls / css / html / eslint
      vtsls
      vue-language-server
      yaml-language-server
    ];
  };

  # 保留 Lua、插件锁文件和 Extras 设置的可写性，内容通过 Git 同步。
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/common/editor/nvim/config";
}
