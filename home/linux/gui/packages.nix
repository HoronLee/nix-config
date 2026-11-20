{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # GTK 图标主题；nautilus、ghostty 等应用的 symbolic 与界面图标来源。
    adwaita-icon-theme
    # 文件浏览器
    nautilus
    # 即时通讯
    telegram-desktop
    # QQ 是 Electron：默认走 XWayland，GTK 在未设 GTK_IM_MODULE 时按 locale 回落 im-xim，
    # Fcitx5 的 XIM 前端转发不同步，快打时按键绕过预编辑直接落进输入框。
    # 强制原生 Wayland + text-input-v3，改用 fcitx5 的 wayland 前端。
    (qq.override {
      commandLineArgs = "--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime --wayland-text-input-version=3";
    })
    wechat
    # 办公套件
    libreoffice
    # VNC 服务端；走 wlr-screencopy 抓屏，niri 下可用
    wayvnc
    # 远程终端
    (pkgs.callPackage ../../../pkgs/nyaterm { })
    # Coding agents 控制面板（桌面端 + t3 CLI）；禁用默认捆绑的 codex，避免 --prefix PATH 遮挡 mise 管理的 codex。
    (t3code.override { enableCodex = false; })
  ];
}
