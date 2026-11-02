{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 文件浏览器
    nautilus
    # 网页浏览器
    microsoft-edge
    # 即时通讯
    qq
    wechat
    telegram-desktop
    # 办公套件
    libreoffice
    # 编辑器；配置与扩展由 Microsoft 账号同步
    vscode
    # 远程终端
    (pkgs.callPackage ../../../pkgs/nyaterm { })
    # Minecraft 启动器
    prismlauncher
  ];
}
