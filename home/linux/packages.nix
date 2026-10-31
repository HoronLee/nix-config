{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 文件浏览器
    nautilus

    # 网页浏览器
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
