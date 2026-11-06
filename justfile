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

# 更新 flake 输入；可传入零个或多个 input 名。
[positional-arguments]
update *inputs:
    nix flake update -- "$@"
