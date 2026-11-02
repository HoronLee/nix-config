{ pkgs, ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # 系统时区。
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 支持 Magpie 官方桌面二进制及其自更新下载的版本。
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gtk3
      webkitgtk_4_1
      libsoup_3
      wayland
      libX11
      fontconfig
      gdk-pixbuf
      glib
      dbus
    ];
  };

  # 系统级软件包。
  environment.systemPackages = with pkgs; [
    # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
    git
    neovim
    wget
    curl
    gnumake
    just
  ];

  # 系统账户使用基础 Neovim，个人配置由 Home Manager 管理。
  environment.variables.EDITOR = "nvim";

  # 应用启动器为 Terminal=true 的桌面项选择终端；显式指定 kitty。
  environment.sessionVariables.TERMINAL = "kitty";
}
