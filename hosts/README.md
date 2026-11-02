# Hosts

按 `<system>/<host>/` 组织系统层配置。每台机器一个目录。

## 文件

| 文件 | 作用 |
| --- | --- |
| `default.nix` | hostname、bootloader、`system.stateVersion`、系统模块 imports |
| `hardware-configuration.nix` | `nixos-generate-config` 生成的文件系统、内核模块；提交到仓库 |

## 新增 NixOS 主机

1. 在安装介质上生成硬件配置：

   ```sh
   nixos-generate-config --root /mnt
   ```

2. 复制到 `hosts/x86_64-linux/<host>/hardware-configuration.nix`。
3. 在 `default.nix` 补 bootloader。UEFI 参考：

   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```

   BIOS 使用 `boot.loader.grub`。
4. 在 `flake.nix` 注册 `nixosConfigurations.<host>`，并指向对应的 `home/profiles`。
5. `git add` 新增文件；flake 只包含 Git 跟踪的文件。
6. 安装：

   ```sh
   nixos-install --flake /path/to/nix-config#<host>
   ```

## 约定

- 这里只放系统层配置，用户 dotfiles 放 `home/`。
- `system.stateVersion` 使用首次安装的 NixOS release，升级 nixpkgs 后不要改。
- bootloader 与固件、磁盘布局相关，放在 host 模块，不放进 `hardware-configuration.nix`。
- `dell-r430` 在生成 `hardware-configuration.nix` 前不会注册到 flake。
