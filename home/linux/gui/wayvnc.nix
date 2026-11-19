{
  pkgs,
  ...
}:
{
  # 跟随图形会话启停：niri.service 绑定 graphical-session.target，
  # wayvnc 需要会话里的 WAYLAND_DISPLAY 与 wlr-screencopy，故排在其后。
  systemd.user.services.wayvnc = {
    Unit = {
      Description = "WayVNC server for the niri session";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      # 无配置文件时默认只监听 localhost，客户端经 SSH 隧道接入。
      # -r 由服务端绘制指针，否则远程看不到光标。
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc -r";
      # wayvnc 0.10.2 有剪贴板竞态：客户端断开后残留的 data_offer 触发
      # libwayland "not a valid new object id"，进程以 0 退出而与会话脱钩。
      # Restart=always 才能在退出码 0 的情况下也拉起来。
      Restart = "always";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
