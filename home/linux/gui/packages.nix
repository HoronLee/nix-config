{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
