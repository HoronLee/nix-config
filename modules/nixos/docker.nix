{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.horonlee.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];

  # Docker CLI 只搜索内置插件目录；Nix 包把 compose/buildx 放在 libexec。
  environment.sessionVariables.DOCKER_CLI_PLUGIN_EXTRA_DIRS =
    "${pkgs.docker-compose}/libexec/docker/cli-plugins:${pkgs.docker-buildx}/libexec/docker/cli-plugins";
}
