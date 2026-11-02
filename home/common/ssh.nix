{ ... }:
{
  programs.ssh = {
    enable = true;
    # 使用 OpenSSH 自身默认值，不生成 HM 的额外默认设置。
    enableDefaultConfig = false;
    settings."*".AddKeysToAgent = "yes";
  };

  # Home Manager 在 Linux 使用 systemd user service，在 macOS 使用 launchd agent。
  services.ssh-agent.enable = true;
}
