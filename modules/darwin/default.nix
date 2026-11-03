{
  imports = [ ./apps.nix ];

  # Darwin 上有 Microsoft Edge、Chrome、VS Code 等 unfree 包。
  nixpkgs.config.allowUnfree = true;

  # 所有 Darwin 主机统一使用已有 Homebrew；Nix 重建不升级 brew 包。
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
  };
}
