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
    jdk25
    # 包管理器。
    mise
    uv
    pipx
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
    biome
    pyright
    golangci-lint
    just-lsp
    typescript
    # 构建工具。
    cmake
    gnumake
    just
    prek
    stdenv.cc
    pkg-config
    nsis
    # 代码统计与内容提取。
    cloc
    defuddle
    # 开发辅助。
    agent-browser
    buf
    chezmoi
    gh
    helix
    emacs
    imagemagick
    protobuf
    rtk
    tea
    tmux
    tokei
    upx
    viddy
    viu
    watch
    chafa
    figlet
    # 文档与媒体。
    ffmpeg
    poppler
    # 网络诊断与自动化。
    grpcurl
    sshpass
    # 分布式存储。
    etcd
    # Kubernetes。
    kubebuilder
    kubectl
    kubernetes-helm
    # 负载测试。
    k6
    # 权限服务。
    openfga
    # 虚拟化。
    qemu
  ];
  # Go / Cargo / uv 等用户安装的命令不写入只读 Nix profile。
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
  home.sessionVariables = {
    # Java 工具链由 Nix 提供，供 Gradle、Maven 和 IDE 使用。
    JAVA_HOME = "${pkgs.jdk25.home}";
    # Python 解释器由 Nix 提供；uv 继续管理虚拟环境及项目依赖。
    UV_PYTHON_DOWNLOADS = "never";
    UV_PYTHON_PREFERENCE = "only-system";
    # npm 的全局包使用用户可写目录。
    NPM_CONFIG_PREFIX = "$HOME/.local";
  };
}
