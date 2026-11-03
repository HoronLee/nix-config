{ config, pkgs, ... }:
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
    # Protobuf 与接口定义。
    buf
    protobuf
    # LSP 与格式化。
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
    # 构建与发布。
    cmake
    gnumake
    just
    prek
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
    # AI 工具。
    agent-browser
    rtk
    # 终端文本与图像展示。
    cowsay
    figlet
    chafa
    viu
    # 文档与媒体。
    ffmpeg
    poppler
    imagemagick
    defuddle
    # 网络诊断与自动化。
    grpcurl
    sshpass
    # Kubernetes。
    kubebuilder
    kubectl
    kubernetes-helm
    # 负载测试。
    k6
    # 虚拟化。
    qemu
    # 配置管理。
    chezmoi
    # 终端会话。
    tmux
  ];
  # Nix profile 在 useUserPackages 下位于 /etc/profiles/per-user/<user>，
  # Fish 不会继承 nix-darwin 的 zshenv PATH，这里显式放在最前面。
  home.sessionPath = [
    "${config.home.profileDirectory}/bin"
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
