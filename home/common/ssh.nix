{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    # 使用 OpenSSH 自身默认值，不生成 HM 的额外默认设置。
    enableDefaultConfig = false;
    settings."*".AddKeysToAgent = "yes";
  };

  # Home Manager 在 Linux 使用 systemd user service，在 macOS 使用 launchd agent。
  services.ssh-agent.enable = true;

  # macOS 上首次进入交互式 shell 时把默认密钥加入 agent 和 Keychain。
  programs.fish.interactiveShellInit = lib.mkAfter (
    lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"; and test -f ~/.ssh/id_ed25519; and not ssh-add -l >/dev/null 2>&1
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
      end
    ''
  );
}
