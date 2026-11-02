# Horon's NixOS 配置

用 Nix Flakes 管理 NixOS、nix-darwin 和内嵌 Home Manager。系统层和用户层分开：`hosts/` 管硬件、启动和系统服务，`home/` 管用户环境。

## 主机

| 主机 | 平台 | 入口 | 说明 |
| --- | --- | --- | --- |
| `nixos-vm` | NixOS x86_64 | `nixosConfigurations.nixos-vm` | UEFI + systemd-boot，Niri + Noctalia，Fcitx5-Rime |
| `mbp-m2pro` | nix-darwin aarch64 | `darwinConfigurations.mbp-m2pro` | Apple Silicon，Homebrew cask |
| `dell-r430` | NixOS x86_64 | 待注册 | 1U 服务器，装机时生成硬件配置 |

## 快速开始

### 新 NixOS 主机

1. 用 UEFI 模式启动安装介质。
2. 分区并挂载到 `/mnt`，生成硬件配置：

   ```sh
   nixos-generate-config --root /mnt
   ```

3. 克隆仓库：

   ```sh
   nix-shell -p git
   git clone https://github.com/HoronLee/nix-config.git ~/projects/nix-config
   ```

4. 把 `/mnt/etc/nixos/hardware-configuration.nix` 复制到目标 host 目录：

   ```sh
   cp /mnt/etc/nixos/hardware-configuration.nix \
     ~/projects/nix-config/hosts/x86_64-linux/<host>/hardware-configuration.nix
   ```

5. 在 host 模块补 bootloader。`nixos-generate-config` 同时生成的 `configuration.nix` 里有 systemd-boot 或 GRUB 的参考配置。
6. 在 `flake.nix` 注册 host，并 `git add` 新文件。flake 只包含 Git 跟踪的文件。
7. 安装：

   ```sh
   nixos-install --flake ~/projects/nix-config#<host>
   ```

### 日常应用

```sh
sudo nixos-rebuild switch --flake ~/projects/nix-config#nixos-vm
```

macOS：

```sh
sudo darwin-rebuild switch --flake ~/projects/nix-config#mbp-m2pro
```

## 目录

```text
flake.nix                  # 输入、host 输出
lib/
  mkNixosHost.nix          # NixOS + 内嵌 HM
  mkDarwinHost.nix         # nix-darwin + 内嵌 HM
  scanPaths.nix            # 叶子目录自动导入
hosts/<system>/<host>/     # 机器级系统配置
modules/
  common/apps.nix          # 跨平台应用选项
  nixos/system/            # base、nix、user、ssh
  nixos/desktop/           # services、firefox、niri、greeter、input-method
  nixos/apps.nix           # NixOS 侧应用安装
  nixos/server.nix         # 服务器基础模块
  darwin/apps.nix          # macOS cask 安装
home/
  core.nix                 # 无 GUI 的用户层
  gui.nix                  # core + 跨平台 GUI
  common/                  # CLI、TUI、GUI、编辑器、终端
  linux/                   # Linux core、GUI、WM、WS、IM
  profiles/                # 按角色组合 home 模块
```

## 分层规则

- `hosts/`：硬件、bootloader、hostname、`system.stateVersion`。不放用户 dotfiles。
- `modules/nixos/system/`：所有 NixOS 主机共享的系统基础。
- `modules/nixos/desktop/`：桌面服务、Firefox、Niri、输入法。`greeter.nix` 单独导入，服务器默认不启动图形登录。
- `modules/nixos/apps.nix`：跨平台应用的 NixOS 安装实现；`modules/darwin/apps.nix` 负责 macOS cask。
- `home/core.nix`：CLI、TUI、Neovim、字体和主题，不含 GUI。服务器使用这一层。
- `home/gui.nix`：`core.nix` 加上跨平台 GUI，桌面和 macOS 使用。
- `home/linux/default.nix`：Linux 专属 CLI/TUI；`home/linux/gui/`：Linux GUI 应用。
- `home/profiles/`：把上面的层组合成某类主机。

## 桌面与服务器

| Profile | 导入内容 | 用途 |
| --- | --- | --- |
| `linux-server.nix` | `core.nix` + `linux` + `ssh-agent` | 无 GUI 的服务器 |
| `linux-desktop-niri.nix` | `gui.nix` + `linux` + `linux/gui` + Niri/Noctalia + Rime + SSH agent | Linux 桌面 |
| `darwin.nix` | `gui.nix` | macOS |

`linux-server` 仍包含 btop、yazi、OMP 等 TUI 工具，只是不安装 GUI 应用。

## 跨平台应用开关

`clash-verge` 和 `ghostty` 用 `my.apps` 控制：

```nix
my.apps = {
  clash-verge.enable = true;
  ghostty.enable = true;
};
```

选项定义在 `modules/common/apps.nix`。NixOS 侧由 `modules/nixos/apps.nix` 安装，macOS 侧由 `modules/darwin/apps.nix` 安装 cask。它负责“这台桌面主机装不装某个跨平台应用”，不负责 GUI/无 GUI 的划分。

## 状态版本

- NixOS 的 `system.stateVersion` 使用首次安装的 release。`nixos-vm` 和 `dell-r430` 是 `26.05`，升级 nixpkgs 后不要跟着改。
- nix-darwin 的 `system.stateVersion` 是整数，当前为 `7`。
- Home Manager 的 `home.stateVersion` 在 `home/core.nix`，当前为 `26.05`。

## 硬件配置

`hardware-configuration.nix` 按主机提交到仓库，包含文件系统 UUID、subvol 和内核模块，不含密钥。换磁盘或重装后重新生成并提交。

## 验证

```sh
nixfmt $(git ls-files '*.nix')

nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel --no-link

nix eval --raw \
  .#darwinConfigurations.mbp-m2pro.config.system.build.toplevel.drvPath
```

`dell-r430` 在生成 `hardware-configuration.nix` 前不会注册到 `flake.nix`，避免整个 flake 求值失败。

## 更多文档

- [hosts/README.md](hosts/README.md)：新增系统主机
- [modules/README.md](modules/README.md)：系统模块分层
- [home/README.md](home/README.md)：用户层与 profile
- [home/common/README.md](home/common/README.md)：跨平台用户模块
- [home/linux/README.md](home/linux/README.md)：Linux 桌面、WM、WS、IM
