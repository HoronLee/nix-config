{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 语言。
    go_latest
    python315
    nodejs_latest
    rustc
    lua5_5

    # 包管理器。
    uv
    pnpm
    (yarn.override { nodejs = nodejs_latest; })
    cargo
    lua55Packages.luarocks

    # 语言服务与格式化。
    nixd
    nixfmt
    tombi
    rustfmt
    clippy

    # 构建工具。
    gnumake
    just
    stdenv.cc
    pkg-config

    tree-sitter
  ];

  # Go / Cargo / uv 等用户安装的命令不写入只读 Nix profile。
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  # Python 解释器由 Nix 提供；uv 继续管理虚拟环境及项目依赖。
  home.sessionVariables.UV_PYTHON_DOWNLOADS = "never";
  home.sessionVariables.UV_PYTHON_PREFERENCE = "only-system";

  # npm 的全局包使用用户可写目录。
  home.sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.local";
}
