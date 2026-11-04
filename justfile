# 列出可用任务。
default:
    @just --list

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

# 构建 NixOS 配置，不切换。
[linux]
build-nixos host="nixos-vm":
    nixos-rebuild build --flake .#{{host}} --no-link

# 构建 Darwin 配置，不切换。
[macos]
build-darwin host="mbp-m2pro":
    darwin-rebuild build --flake .#{{host}} --no-link

# 切换 NixOS。
[linux]
switch-nixos host="nixos-vm":
    sudo nixos-rebuild switch --flake .#{{host}}

# 切换 Darwin。
[macos]
switch-darwin host="mbp-m2pro":
    sudo darwin-rebuild switch --flake .#{{host}}

# 检查 flake 输出求值，不构建。
check:
    nix flake check

# 升级 flake 输入，仅在明确需要时运行。
update:
    nix flake update
