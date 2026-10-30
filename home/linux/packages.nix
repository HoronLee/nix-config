{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 文件管理器
    nautilus

    # 浏览器。
    microsoft-edge

    # 性能与资源监控
    iotop

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
