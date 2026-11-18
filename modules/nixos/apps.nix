{ config, lib, ... }:
{
  imports = [ ../common/apps.nix ];

  config = lib.mkMerge [
    (lib.mkIf config.my.apps.clash-verge.enable {
      programs.clash-verge = {
        enable = true;
        serviceMode = true;
        tunMode = true;
        autoStart = true;
      };
    })
    (lib.mkIf config.my.apps.steam.enable {
      programs.steam = {
        enable = true;
        # Proton 兼容层的 winetricks 前端；Steam 本体不含此工具。
        protontricks.enable = true;
        # Wayland 下把 X11 输入事件转成 uinput，Steam Input 手柄才可靠。
        extest.enable = true;
        # 防火墙默认开启，不放行时 Remote Play 与局域网传输静默失败。
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    })
  ];
}
