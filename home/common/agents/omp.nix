{
  pkgs,
  ...
}:
let
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

  configFile = (pkgs.formats.yaml { }).generate "omp-config.yml" settings;
in
{
  # 改由 mise 管理（github:can1357/oh-my-pi），nixpkgs 版本落后于上游 release。
  # home.packages = [ pkgs.omp ];

  # Magpie 把 modelRoles 和 provider 写进 OMP 配置；后续 switch 不能覆盖。
  # 新机器第一次 activation 注入静态设置，已有机器直接跳过。
  home.activation.ompSeed = {
    before = [ ];
    after = [ "writeBoundary" ];
    data = ''
      run mkdir -p "$HOME/.omp/agent"
      if [ ! -e "$HOME/.omp/agent/config.yml" ]; then
        run install -m 600 ${toString configFile} "$HOME/.omp/agent/config.yml"
      fi
    '';
  };
}
