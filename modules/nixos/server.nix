{ ... }:
{
  # 服务器没有本地显示输出；SSH 由 ssh.nix 提供。
  hardware.enableRedistributableFirmware = true;
  services.smartd.enable = true;

  # iDRAC 串口控制台可选：
  # boot.kernelParams = [ "console=ttyS0,115200n8" ];
}
