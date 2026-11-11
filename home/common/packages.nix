{
  config,
  pkgs,
  ...
}:
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
    _7zz
    zstd
    # 搜索、数据处理与目录列表。
    ripgrep
    fd
    jq
    yq-go
    tree-sitter
    # 网络传输。
    iperf3
    aria2
    socat
    nmap
    wget
    # 基础工具。
    file
    which
    tree
    gnused
    gnutar
    gawk
    gnupg
    viddy
    lsof
    # Nix 构建日志。
    nix-output-monitor
    # 编程语言。
    lua5_5
    # 包管理器。
    mise
    lua55Packages.luarocks
    # Protobuf 与接口定义。
    protobuf
    # LSP 与格式化。
    nixd
    nixfmt
    just-lsp
    # 构建与发布。
    cmake
    gnumake
    just
    stdenv.cc
    pkg-config
    nsis
    upx
    # 代码统计。
    tokei
    # 代码托管与协作。
    gh
    tea
    # 权限与身份。
    openfga-cli
    # 终端文本与图像展示。
    cowsay
    figlet
    chafa
    viu
    # 文档与媒体。
    ffmpeg
    poppler-utils # 提供 pdftotext/pdfinfo 等 CLI；poppler 只是 glib 库。
    imagemagick
    defuddle
    # 网络诊断与自动化。
    grpcurl
    sshpass
    # 虚拟化。
    qemu
    # 配置管理。
    chezmoi
    # 终端会话。
    tmux
  ];
  # Nix profile 在 useUserPackages 下位于 /etc/profiles/per-user/<user>。
  # 系统路径由 NixOS/nix-darwin 的 Fish 集成提供。
  # mise shims 与 Go / Cargo / uv 等用户安装的命令放后面。
  home.sessionPath = [
    "${config.home.profileDirectory}/bin"
    "$HOME/.local/share/mise/shims"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
}
