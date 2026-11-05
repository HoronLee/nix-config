# Hosts
按 `<system>/<host>/` 组织系统层配置，每台机器一个目录。
| 文件 | 作用 |
| --- | --- |
| `default.nix` | hostname、bootloader、`system.stateVersion`、系统模块 imports |
| `hardware-configuration.nix` | `nixos-generate-config` 生成的文件系统与内核模块 |
## 新增 NixOS 主机
1. 用 UEFI 模式装好系统，进入新系统后开启 flakes。`/etc/nix/nix.conf` 是 Nix store 软链，改写成 root 的用户级配置：
   ```sh
   sudo mkdir -p /root/.config/nix
   printf 'experimental-features = nix-command flakes\n' \
     | sudo tee /root/.config/nix/nix.conf
   ```
2. 克隆仓库并生成硬件配置。先把新机器的公钥加到 GitHub；`--show-hardware-config` 只取输出，避免覆盖 `/etc/nixos/configuration.nix`：
   ```sh
   nix-shell -p git
   git clone git@github.com:HoronLee/nix-config.git ~/projects/nix-config
   cd ~/projects/nix-config
   sudo nixos-generate-config --show-hardware-config \
     > hosts/x86_64-linux/<host>/hardware-configuration.nix
   ```
3. 在 `default.nix` 配置 bootloader。UEFI 示例：
   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```
   BIOS 使用 `boot.loader.grub`。
4. 在 `flake.nix` 注册 `nixosConfigurations.<host>`，指向对应的 `home/profiles`。
5. `git add` 硬件配置与 `flake.nix`。flake 只包含 Git 跟踪的文件；host 模块首行就 `import ./hardware-configuration.nix`，漏掉则整个 flake 求值失败。
6. 首次切换在文本终端执行；新配置若停用图形会话，图形终端会被一起关闭：
   ```sh
   sudo nixos-rebuild switch --flake .#<host>
   ```
   重启后主机名与 flake 属性名一致，可简写为 `--flake .`。
7. 未装系统时可跳过 1、6 步，改用 `nixos-install --flake .#<host>`。
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
- 新增 host 时先 `git add` 硬件配置，再在 `flake.nix` 注册输出。
