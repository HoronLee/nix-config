{
  lib,
  options,
  pkgs,
  ...
}:
{
  programs.omp = {
    enable = true;
    # 修正锁定 nix-bun 的旧平台判断，保留相同依赖与构建输出。
    package = options.programs.omp.package.default.override (args: {
      bun = args.bun.overrideAttrs (_: {
        nativeBuildInputs = [
          pkgs.unzip
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];
        buildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];
      });
    });
    settings = {
      theme = {
        light = "light-catppuccin";
        dark = "dark-catppuccin";
      };
      memory.backend = "mnemopi";
      edit.mode = "hashline";
      tui = {
        tight = false;
        codexResetFireworks = false;
        textSizing = true;
      };
    };
  };
}
