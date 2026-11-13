# 列出可用任务。
default:
    @just --list

# 未传 host 时使用当前主机名；flake 属性名与主机名保持一致。
default_host := `hostname -s`

# 打印 flake 输出下所有属性名（主机名），每行一个。
list_hosts := 'x: builtins.concatStringsSep "\n" (builtins.attrNames x)'

# 求值所有主机的 toplevel，每行打印 host 与 drvPath。
eval_hosts := 'x: builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (n: v: n + " " + v.config.system.build.toplevel.drvPath) x))'

# 格式化所有 Nix 文件。
fmt:
    nixfmt $(git ls-files '*.nix')

# 列出 NixOS 与 Darwin 的所有主机。
hosts:
    @echo "nixosConfigurations:"
    @nix eval --no-write-lock-file --raw .#nixosConfigurations --apply '{{ list_hosts }}'
    @echo ""
    @echo "darwinConfigurations:"
    @nix eval --no-write-lock-file --raw .#darwinConfigurations --apply '{{ list_hosts }}'
    @echo ""

# 求值 NixOS 与 Darwin 所有主机的 toplevel。
eval:
    @echo "nixosConfigurations:"
    @nix eval --no-write-lock-file --raw .#nixosConfigurations --apply '{{ eval_hosts }}'
    @echo ""
    @echo "darwinConfigurations:"
    @nix eval --no-write-lock-file --raw .#darwinConfigurations --apply '{{ eval_hosts }}'
    @echo ""

# 构建配置；macOS 用 darwin-rebuild，Linux 用 nixos-rebuild。
build host="":
    {{ if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" } }} build --flake {{ quote(".#" + if host == "" { default_host } else { host }) }} --no-link

# 切换配置；macOS 用 darwin-rebuild，Linux 用 nixos-rebuild。
switch host="":
    sudo {{ if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" } }} switch --flake {{ quote(".#" + if host == "" { default_host } else { host }) }}

# 检查 flake：先求值所有主机，再执行 flake check。
check: eval
    nix flake check --no-build --all-systems --no-write-lock-file

# GitHub 未认证 API 限速 60 次/小时，分支输入靠 API 解析，共享出口 IP 时会 403。
# 令牌从 gh 钥匙串现取；未登录或取不到时退回匿名请求。
[positional-arguments]
update *inputs:
    @token="$(gh auth token 2>/dev/null || true)"; \
      NIX_CONFIG="${token:+access-tokens = github.com=$token}" nix flake update -- "$@"
