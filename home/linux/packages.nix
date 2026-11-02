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
  ];
}
