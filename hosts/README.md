# Hosts
按 `<system>/<host>/` 组织系统层配置，每台机器一个目录。
| 文件 | 作用 |
| --- | --- |
| `default.nix` | hostname、bootloader、`system.stateVersion`、系统模块 imports |
| `hardware-configuration.nix` | `nixos-generate-config` 生成的文件系统与内核模块 |
## 新增 NixOS 主机
1. 安装介质中生成硬件配置：
   ```sh
   nixos-generate-config --root /mnt
   ```
2. 复制到 `hosts/x86_64-linux/<host>/hardware-configuration.nix`。
3. 在 `default.nix` 配置 bootloader。UEFI 示例：
   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```
   BIOS 使用 `boot.loader.grub`。
4. 在 `flake.nix` 注册 `nixosConfigurations.<host>`，指向对应的 `home/profiles`。
5. `git add` 新文件；flake 只包含 Git 跟踪的文件。
6. 安装：
   ```sh
   nixos-install --flake /path/to/nix-config#<host>
   ```
## 内核选择
默认使用 NixOS 自带内核。`flake.nix` 引入的 `nix-cachyos-kernel` 只通过 `lib/mkNixosHost.nix` 提供 `pkgs.cachyosKernels` overlay，不会自动切换内核。

需要 CachyOS 的 host 在 `default.nix` 中显式声明：
```nix
{ pkgs, ... }:
{
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
```
当前只有 `nixos-vm` 使用 CachyOS latest。其他 host 不写 `boot.kernelPackages` 即使用默认内核。

也可以使用 NixOS 自带的其他内核：
```nix
boot.kernelPackages = pkgs.linuxPackages_zen;
boot.kernelPackages = pkgs.linuxPackages_latest;
```
CachyOS 内核目前只支持 `x86_64-linux`。
## 约定
- 只放系统层配置；用户 dotfiles 放 `home/`。
- `system.stateVersion` 使用首次安装的 release，升级 nixpkgs 后不要改。
- bootloader、固件和磁盘布局放在 host 模块，不放 `hardware-configuration.nix`。
- `dell-r430` 在生成 `hardware-configuration.nix` 前不会注册到 flake。
