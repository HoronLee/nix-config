{ ... }:
{
  programs.ssh = {
    enable = true;
    # 使用 OpenSSH 自身默认值，不生成 HM 的额外默认设置。
    enableDefaultConfig = false;
    settings."*".AddKeysToAgent = "yes";
  };
}
