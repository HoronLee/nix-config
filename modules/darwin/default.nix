{ pkgs, ... }:
{
  imports = [
    ../common/home-manager.nix
    ../common/nix.nix
    ./apps.nix
  ];
  # TODO(darwin-rust-deps): 跟踪 NixOS/nixpkgs，见 TODO.md；修复进入锁定版本并验证后移除。
  # 仅剩 cargo-bundle（Zed 依赖）与 viddy 两条，Codex 和 OMP 已改由 mise 管理。
  nixpkgs.overlays = [
    (final: prev: {
      # cargo-bundle 0.12.0 漏声明 Darwin 依赖；Rust hook 强制使用系统 AWS-LC。
      cargo-bundle = prev.cargo-bundle.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.pkg-config ];
        buildInputs = (old.buildInputs or [ ]) ++ [ final.aws-lc ];
      });
      # Codex 改由 mise 管理，不再从 nixpkgs 取包。
      # # Codex 0.167.0 漏声明 Rust 系统库；回补 nixpkgs master 的依赖声明。
      # codex = prev.codex.overrideAttrs (old: {
      #   buildInputs = (old.buildInputs or [ ]) ++ [
      #     final.aws-lc
      #     final.oniguruma
      #     final.sqlite
      #     final.zstd
      #   ];
      # });
      # OMP 改由 mise 管理，不再从 nixpkgs 取包。
      # # OMP 18.16.0 的原生扩展使用系统 Oniguruma 和 Zstd。
      # omp = prev.omp.overrideAttrs (old: {
      #   buildInputs = (old.buildInputs or [ ]) ++ [
      #     final.oniguruma
      #     final.zstd
      #   ];
      # });
      # Viddy 1.3.1 在 Rust hook 禁用内置 SQLite 后缺少链接库。
      viddy = prev.viddy.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ final.sqlite ];
      });
    })
  ];

  # 由 nix-darwin 初始化 Fish 环境，避免 macOS 登录时重排 Nix PATH。
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  # sudo 的密码提示走 PAM，与具体 shell 无关：开启后 fish 里的 sudo 直接弹指纹。
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # zellij、tmux 中的 sudo 会脱离登录 bootstrap session，重新挂回后指纹才可用。
    reattach = true;
  };
  # 所有 Darwin 主机统一使用已有 Homebrew；Nix 重建不升级 brew 包。
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "check";
    };
  };
}
