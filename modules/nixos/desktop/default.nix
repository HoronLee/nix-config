{ ... }:
{
  imports = [
    ./services.nix
    ./firefox.nix
    ./niri.nix
    ./input-method.nix
    ./keyd.nix
  ];
  # Qt 6 默认平台主题不上报桌面亮暗，QStyleHints::colorScheme() 返回 Unknown，
  # Prism Launcher 等按“系统”主题的应用会固定为浅色。
  # xdgdesktopportal 由 qtbase 自带，经 XDG Portal 读取 org.freedesktop.appearance。
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
}
