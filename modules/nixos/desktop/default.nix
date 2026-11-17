{ ... }:
{
  imports = [
    ./services.nix
    ./firefox.nix
    ./niri.nix
    ./input-method.nix
    ./keyd.nix
    ./magpie.nix
  ];
  # GVfs 提供 trash://、network:// 等虚拟文件系统后端，文件浏览器需要它。
  services.gvfs.enable = true;
  # 应用启动器为 Terminal=true 的桌面项选择终端。
  environment.sessionVariables.TERMINAL = "ghostty";
  # Qt 6 默认平台主题不上报桌面亮暗，QStyleHints::colorScheme() 返回 Unknown，
  # Prism Launcher 等按“系统”主题的应用会固定为浅色。
  # xdgdesktopportal 由 qtbase 自带，经 XDG Portal 读取 org.freedesktop.appearance。
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
}
