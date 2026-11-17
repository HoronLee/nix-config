{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.frpc;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.my.frpc = {
    enable = lib.mkEnableOption "frpc client";

    tokenFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/frp/token";
      description = "存放裸 frp token 的文件路径（0600）。";
    };

    proxies = lib.mkOption {
      type = lib.types.listOf tomlFormat.type;
      default = [ ];
      description = "当前主机暴露的 [[proxies]] 列表。";
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "额外或覆盖的 frpc TOML 配置。";
    };
  };

  config = lib.mkIf cfg.enable {
    services.frp.instances."" = {
      enable = true;
      role = "client";
      settings = lib.mkMerge [
        (
          {
            user = lib.mkDefault config.networking.hostName;
            serverAddr = lib.mkDefault "wrtv4.horon.top";
            serverPort = lib.mkDefault 7000;
            auth = {
              method = lib.mkDefault "token";
              tokenSource = {
                type = lib.mkDefault "file";
                file.path = lib.mkDefault "{{ .Envs.CREDENTIALS_DIRECTORY }}/token";
              };
            };
          }
          // lib.optionalAttrs (cfg.proxies != [ ]) {
            proxies = cfg.proxies;
          }
        )
        cfg.settings
      ];
    };

    systemd.services.frp = {
      unitConfig.ConditionPathExists = cfg.tokenFile;
      serviceConfig.LoadCredential = "token:${cfg.tokenFile}";
    };

    systemd.tmpfiles.rules = [
      "d ${dirOf cfg.tokenFile} 0700 root root -"
    ];
  };
}
