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
      subagentLivePreview = true;
    };
    hideThinkingBlock = true;
    defaultThinkingLevel = "xhigh";
    terminal.showProgress = false;
    branchSummary.enabled = false;
    tui = {
      tight = false;
      codexResetFireworks = false;
    };
    task = {
      showResolvedModelBadge = false;
      enableLsp = true;
    };
    astGrep.enabled = true;
    contextPromotion.enabled = false;
    bash = {
      enabled = true;
      autoBackground.enabled = true;
    };
    bashInterceptor.enabled = false;
    vault.enabled = true;
    github.enabled = true;
    web_search.enabled = true;
    checkpoint.enabled = true;
    computer.enabled = true;
    generate_image.enabled = true;
    skills.enableSkillCommands = true;
    browser = {
      headless = true;
      relay = true;
      cmux = false;
      tern = false;
    };
    security.enabled = false;
    dev.autoqaConsent = "denied";
    codexResets = {
      autoRedeem5h = "yes";
      autoRedeemWeekly = "yes";
    };
    disabledProviders = [
      "claude"
      "codex"
      "opencode"
      "cursor"
      "windsurf"
      "cline"
    ];
    memory.backend = "mnemopi";
    autolearn.enabled = true;
    mnemopi = {
      enhancedRecall = true;
      polyphonicRecall = true;
      proactiveLinking = true;
      recallRelevance = "auto";
      embeddingVariant = "en";
      embeddingModel = "BAAI/bge-small-zh-v1.5";
    };
    edit.mode = "hashline";
    advisor.enabled = true;
  };

  configFile = (pkgs.formats.yaml { }).generate "omp-config.yml" settings;
in
{
  # 改由 mise 管理（github:can1357/oh-my-pi），nixpkgs 版本落后于上游 release。
  # home.packages = [ pkgs.omp ];

  # Magpie 把 modelRoles、provider 和按 agent 的模型路由写进 OMP 配置；这些键不要在此声明。
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
