# 列出可用任务。
default:
    @just --list

# 未传 host 时使用当前主机名；flake 属性名与主机名保持一致。
default_host := `hostname -s`

# 格式化所有 Nix 文件。
fmt:
    nixfmt $(git ls-files '*.nix')

# 求值两台主机的 toplevel。
eval:
    @echo "== nixos-vm"
    @nix eval --raw .#nixosConfigurations.nixos-vm.config.system.build.toplevel.drvPath
    @echo ""
    @echo "== mbp-m2pro"
    @nix eval --raw .#darwinConfigurations.mbp-m2pro.config.system.build.toplevel.drvPath
    @echo ""

# 构建 NixOS 配置
[linux]
build-nixos host="":
    nixos-rebuild build --flake .#{{ if host == "" { default_host } else { host } }} --no-link

# 构建 Darwin 配置
[macos]
build-darwin host="":
    darwin-rebuild build --flake .#{{ if host == "" { default_host } else { host } }} --no-link

# 切换 NixOS。
[linux]
switch-nixos host="":
    sudo nixos-rebuild switch --flake .#{{ if host == "" { default_host } else { host } }}

# 切换 Darwin。
[macos]
switch-darwin host="":
    sudo darwin-rebuild switch --flake .#{{ if host == "" { default_host } else { host } }}

# 检查 flake 输出求值
check:
    nix flake check

# 升级 flake 输入
update:
    nix flake update
