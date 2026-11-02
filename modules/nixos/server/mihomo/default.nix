{ pkgs, ... }:
let
  clashtui = pkgs.writeShellScriptBin "clashtui" ''
    export CLASHTUI_CONFIG_DIR=/var/lib/clashtui
    exec ${pkgs.clashtui}/bin/clashtui "$@"
  '';
in
{
  environment.systemPackages = [
    clashtui
    pkgs.mihomo
  ];

  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    webui = pkgs.metacubexd;
    tunMode = true;
  };

  systemd.services.mihomo.unitConfig.ConditionPathExists = "/etc/mihomo/config.yaml";

  system.activationScripts.clashtuiConfig = ''
    install -d -m 700 /etc/mihomo /var/lib/clashtui /var/lib/clashtui/mihomo

    if [ ! -e /etc/mihomo/config.yaml ]; then
      install -m 600 ${./initial.yaml} /etc/mihomo/config.yaml
    fi

    if [ ! -e /var/lib/clashtui/config.yaml ]; then
      install -m 600 ${./config.yaml} /var/lib/clashtui/config.yaml
    fi

    if [ ! -e /var/lib/clashtui/mihomo/core_override_config.yaml ]; then
      install -m 600 ${./override.yaml} /var/lib/clashtui/mihomo/core_override_config.yaml
    fi
  '';
}
