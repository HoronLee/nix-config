{ pkgs, ... }:
{
  # 注册 niri-session，并使用模块提供的 portal、Polkit 和 Keyring 集成。
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
  };
}
