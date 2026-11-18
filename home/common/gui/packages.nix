{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 密码管理
    bitwarden-desktop
    # 网页浏览器
    microsoft-edge
    google-chrome
    # 编辑器；配置与扩展由 Microsoft 账号同步
    vscode
    # Minecraft 启动器；Java 由 mise 提供（设置 → Java 手动添加），
    # 不随包携带 JDK。不能用空列表：上游 makeSearchPath 会产生空参数，导致 makeBinaryWrapper 参数错位（Unknown argument LD_LIBRARY_PATH）。
    (prismlauncher.override { jdks = [ pkgs.emptyDirectory ]; })
    # 笔记
    obsidian
  ];
}
