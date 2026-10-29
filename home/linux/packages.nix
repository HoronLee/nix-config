{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 系统信息与终端文件管理器
    fastfetch
    yazi
    # neofetch  # 已被 fastfetch 替代
    # nnn       # 使用 yazi

    # 压缩与解压
    zip xz unzip p7zip

    # 搜索、数据处理与目录列表
    ripgrep jq yq-go eza fzf

    # 网络诊断与传输
    mtr iperf3 dnsutils ldns aria2 socat nmap ipcalc

    # 杂项基础工具
    cowsay file which tree
    gnused gnutar gawk zstd gnupg

    # Nix 构建日志
    nix-output-monitor

    # 性能与资源监控
    btop iotop iftop

    # 程序调试与文件占用排查
    strace ltrace lsof

    # 系统与硬件信息
    sysstat lm_sensors ethtool pciutils usbutils
  ];
}
