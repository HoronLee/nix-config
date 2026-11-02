{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 通用工具。
    # 系统信息。
    fastfetch
    # nnn       # 使用 yazi

    # 压缩与解压。
    zip
    xz
    unzip
    p7zip
    zstd

    # 搜索、数据处理与目录列表。
    ripgrep
    fd
    jq
    yq-go

    # 网络传输。
    iperf3
    aria2
    socat
    nmap

    # 基础工具。
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    gnupg

    # Nix 构建日志。
    nix-output-monitor

    # 资源监控与文件占用。
    lsof

    # 开发工具。
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

    # LSP & fmt
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

    # 密码管理
    bitwarden-desktop

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
