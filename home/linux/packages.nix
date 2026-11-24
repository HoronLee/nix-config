{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 性能与资源监控
    iotop
    iftop

    # 网络诊断
    mtr
    ipcalc
    dnsutils
    ldns

    # 程序调试与文件占用排查
    strace
    ltrace

    # 系统与硬件信息
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # C/C++ 工具链（macOS 使用系统 Xcode/CLT，避免 Nix clang-wrapper 遮蔽 /usr/bin/clang）
    stdenv.cc
  ];
}
