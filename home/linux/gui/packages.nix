{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # GTK 图标主题；nautilus、ghostty 等应用的 symbolic 与界面图标来源。
    adwaita-icon-theme
    # 文件浏览器
    nautilus
    # 即时通讯
    telegram-desktop
    qq
    wechat
    # 办公套件
    libreoffice
    # 远程终端
    (pkgs.callPackage ../../../pkgs/nyaterm { })
  ];
}
