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
    # 只声明与本机一致的通用外观和行为；模型、provider 与授权状态由 Magpie 管理。
    settings = {
      theme = {
        light = "light-catppuccin";
        dark = "dark-catppuccin";
      };
      symbolPreset = "nerd";
      colorBlindMode = true;
      composer.shape = "rule";

      statusLine = {
        sessionAccent = true;
        transparent = true;
        compactThinkingLevel = false;
        showHookStatus = true;
      };

      display = {
        showTokenUsage = true;
        cacheMissMarker = true;
        collapseCompacted = true;
      };

      hideThinkingBlock = true;
      terminal.showProgress = false;
      branchSummary.enabled = false;

      task = {
        showResolvedModelBadge = false;
        enableLsp = true;
      };

      astGrep.enabled = true;
      contextPromotion.enabled = true;

      bash = {
        enabled = true;
        autoBackground.enabled = true;
      };

      vault.enabled = true;
      github.enabled = true;
      lsp.formatOnWrite = true;
      read.renderMarkdown = true;

      advisor.enabled = false;
      prewalk.enabled = false;
      externalThinking = false;
      exa.enabled = true;
      launch.enabled = true;

      checkpoint.enabled = true;
      computer.enabled = true;
      generate_image.enabled = true;
      skills.enableSkillCommands = true;
      browser.headless = true;
      security.enabled = false;

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
