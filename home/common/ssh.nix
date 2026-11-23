{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    # 使用 OpenSSH 自身默认值，不生成 HM 的额外默认设置。
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "yes";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      IgnoreUnknown = "UseKeychain";
      UseKeychain = "yes";
    };
  };

  # Linux 由 Home Manager 托管 systemd ssh-agent；macOS 直接使用 launchd 原生 agent，避免与 GUI 应用割裂。
  services.ssh-agent.enable = pkgs.stdenv.hostPlatform.isLinux;

  # macOS 上首次进入交互式 shell 时把默认密钥加入 agent 和 Keychain。
  programs.fish.interactiveShellInit = lib.mkAfter (
    lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"; and test -f ~/.ssh/id_ed25519; and not ssh-add -l >/dev/null 2>&1
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
      end
    ''
  );
}
