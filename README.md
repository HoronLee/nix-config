# Horon's NixOS 配置

用 Nix Flakes 管理 NixOS、nix-darwin 和内嵌 Home Manager。系统层和用户层分开：`hosts/` 管硬件、启动和系统服务，`home/` 管用户环境。

## 主机

| 主机 | 平台 | 入口 | 说明 |
| --- | --- | --- | --- |
| `nixos-vm` | NixOS x86_64 | `nixosConfigurations.nixos-vm` | UEFI + systemd-boot，Niri + Noctalia，Fcitx5-Rime，CachyOS latest 内核 |
| `mbp-m2pro` | nix-darwin aarch64 | `darwinConfigurations.mbp-m2pro` | Apple Silicon，Homebrew cask |
| `dell-r430` | NixOS x86_64 | `nixosConfigurations.dell-r430` | 1U 服务器，UEFI + systemd-boot，默认内核，无 GUI |

## 快速开始

### 新 NixOS 主机

1. 用 UEFI 模式启动安装介质，先装好系统并进入新系统。
2. 开启 flakes。`/etc/nix/nix.conf` 是 Nix store 软链，改写成 root 的用户级配置：

   ```sh
   sudo mkdir -p /root/.config/nix
   printf 'experimental-features = nix-command flakes\n' \
     | sudo tee /root/.config/nix/nix.conf
   ```

3. 克隆仓库并生成硬件配置（先把新机器的公钥加到 GitHub；`--show-hardware-config` 只输出内容，不会覆盖 `/etc/nixos/configuration.nix`）：

   ```sh
   nix-shell -p git
   git clone git@github.com:HoronLee/nix-config.git ~/projects/nix-config
   cd ~/projects/nix-config
   sudo nixos-generate-config --show-hardware-config \
     > hosts/x86_64-linux/<host>/hardware-configuration.nix
   ```

4. 在 host 模块补 bootloader，并在 `flake.nix` 注册 `nixosConfigurations.<host>`。
5. `git add` 硬件配置与 `flake.nix`。flake 只包含 Git 跟踪的文件，漏掉就报路径不存在。
6. 首次切换，在文本终端执行；新配置若停用图形会话，图形终端会连同进程一起被关闭：

   ```sh
   sudo nixos-rebuild switch --flake .#<host>
   ```

7. 重启后主机名与 flake 属性名一致，之后可省略：

   ```sh
   sudo nixos-rebuild switch --flake .
   ```

未装系统时也可以直接安装：`nixos-install --flake .#<host>`。

### 新 macOS 主机

1. 安装 Nix 多用户模式：

   ```sh
   sh <(curl -L https://nixos.org/nix/install)
   ```

   确认 `/etc/nix/nix.conf` 包含：

   ```text
   experimental-features = nix-command flakes
   ```

2. 安装 Homebrew。`homebrew` 模块只在 `/opt/homebrew/bin/brew` 存在时执行，缺失时会跳过整个 brew bundle：

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. 克隆仓库：

   ```sh
   git clone https://github.com/HoronLee/nix-config.git ~/projects/nix-config
   ```

4. 新主机需要改两处：

   - `hosts/aarch64-darwin/<host>/default.nix`：`networking.hostName`、`system.primaryUser`、`users.users.<name>`。
   - `flake.nix`：`darwinConfigurations.<host>` 的 `hostModule`、`username`。

   `home/profiles/darwin.nix` 通常不用改。

5. `git add` 新文件。flake 只读取 Git 跟踪的文件。

6. 首次安装，此时还没有 `darwin-rebuild` 命令：

   ```sh
   sudo nix run nix-darwin -- switch --flake ~/projects/nix-config#mbp-m2pro
   ```

   之后统一用：

   ```sh
   sudo darwin-rebuild switch --flake ~/projects/nix-config#mbp-m2pro
   ```

7. activation 前会执行 `brew bundle`；`cleanup = "none"` 保留未声明的 Homebrew 包，不会自动卸载。需要清理时手动检查 `brew leaves` 和 `brew list --cask`。

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
flake.nix                  # 输入、host 输出；含 CachyOS 内核输入
lib/
  mkNixosHost.nix          # NixOS + 内嵌 HM，提供 CachyOS overlay
  mkDarwinHost.nix         # nix-darwin + 内嵌 HM
  scanPaths.nix            # 叶子目录自动导入
hosts/<system>/<host>/     # 机器级系统配置
modules/
  common/apps.nix          # 有平台差异的应用开关
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
  darwin/                  # Darwin 专属 CLI、Karabiner、Rime
  profiles/                # 按角色组合 home 模块
```

## 分层规则

- `home/` 是用户层，优先用来装软件和管 dotfiles；`modules/` 是系统层，只放需要 root 或系统集成的配置。
- `hosts/`：硬件、bootloader、hostname、`system.stateVersion`。不放用户 dotfiles。
- `modules/nixos/system/`：所有 NixOS 主机共享的系统基础。
- `modules/nixos/desktop/`：桌面服务、Firefox、Niri、输入法。`greeter.nix` 单独导入，服务器默认不启动图形登录。
- `modules/nixos/apps.nix`：需要 NixOS 系统集成的应用，例如 Clash Verge 的 service；`modules/darwin/apps.nix` 负责 macOS cask。
- `home/core.nix`：CLI、TUI、Neovim、字体和主题，不含 GUI。服务器使用这一层。
- `home/gui.nix`：`core.nix` 加上跨平台 GUI，桌面和 macOS 使用。
- `home/linux/default.nix`：Linux 专属 CLI/TUI；`home/linux/gui/`：Linux GUI 应用。
- `home/profiles/`：把上面的层组合成某类主机。

## 内核

默认使用 NixOS 自带内核。

`flake.nix` 引入了 `nix-cachyos-kernel`，`lib/mkNixosHost.nix` 只注入对应的 overlay，使 `pkgs.cachyosKernels` 可用；它不会自动切换任何主机的内核。

需要 CachyOS 的 host 在自己的模块中声明：

```nix
{ pkgs, ... }:
{
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
```

当前只有 `nixos-vm` 使用 CachyOS latest：

```nix
boot.kernelPackages =
  pkgs.cachyosKernels.linuxPackages-cachyos-latest;
```

其他 host 不写 `boot.kernelPackages`，继续使用 NixOS 默认内核。

也可以自由选择 NixOS 自带内核：

```nix
boot.kernelPackages = pkgs.linuxPackages_latest;
boot.kernelPackages = pkgs.linuxPackages_zen;
```

注意事项：

- CachyOS 内核当前只支持 `x86_64-linux`。
- `nix-cachyos-kernel` 使用 `release` 分支和 pinned overlay。
- 更新 CachyOS 版本使用：

  ```sh
  nix flake update nix-cachyos-kernel
  ```

验证当前内核：

```sh
nix eval --raw \
  .#nixosConfigurations.nixos-vm.config.boot.kernelPackages.kernel.name
```

运行中的系统：

```sh
uname -r
```

## 桌面与服务器

| Profile | 导入内容 | 用途 |
| --- | --- | --- |
| `linux-server.nix` | `core.nix` + `linux` | 无 GUI 的服务器 |
| `linux-desktop-niri.nix` | `gui.nix` + `linux` + `linux/gui` + Niri/Noctalia + Rime | Linux 桌面 |
| `darwin.nix` | `gui.nix` | macOS |

`linux-server` 仍包含 btop、yazi、OMP 等 TUI 工具，只是不安装 GUI 应用。SSH agent 由 `home/common/ssh.nix` 在 Linux 和 macOS 上统一启用。

## 新增软件

按 Home Manager → 系统模块 → Homebrew 的顺序选择落点。完整的确认流程、查证命令和文件职责矩阵在 [`.agents/skills/nix-add-software/SKILL.md`](.agents/skills/nix-add-software/SKILL.md)。

让 agent 加载该 skill 并给出软件名、GitHub 仓库或官网链接。它会先确认平台、用途和文件位置，确认后才修改仓库。

需要手动处理时，最少查这两项：

```sh
nix eval --json nixpkgs#<pkg>.meta.platforms
brew info --cask <cask>
```

细节规则见 [`home/README.md`](home/README.md#gui-应用放置规则) 和 [`modules/README.md`](modules/README.md#应用开关)。

## 跨平台应用开关

`clash-verge`、`ghostty` 和 `obs` 用 `my.apps` 控制：

```nix
my.apps = {
  clash-verge.enable = true;
  ghostty.enable = true;
  obs.enable = true;
};
```

选项定义在 `modules/common/apps.nix`。Linux 和 macOS 的实现分别放在对应平台模块里；统一开关只负责“这台桌面主机装不装这个应用”。像 VS Code、Telegram、Obsidian 这类两个平台都用同一个 nix 包的应用，直接放在 `home/common/gui/packages.nix`，不再经过 `my.apps`。

## 服务器 Mihomo / ClashTui

服务器通过 `modules/nixos/server/mihomo` 启用 `mihomo.service`。ClashTui 负责订阅和配置，进程、TUN 权限和开机启动由 NixOS 管理。

```sh
sudo clashtui
```

- `2 Files`：添加订阅 URL，选中后写入 `/etc/mihomo/config.yaml`。
- `7 CoreSrvCtl`：启动或重启 `mihomo`。
- 面板：SSH 转发 `9090` 后打开 `http://127.0.0.1:9090/ui`。
- secret 在 `/var/lib/clashtui/mihomo/core_override_config.yaml`，初始为 `CHANGE_ME`。
- 订阅链接需要返回 Clash YAML；base64 订阅先转换。
- 用 `systemctl status mihomo` 查看服务状态。

## 状态版本

- NixOS 的 `system.stateVersion` 使用首次安装的 release。`nixos-vm` 和 `dell-r430` 是 `26.05`，升级 nixpkgs 后不要跟着改。
- nix-darwin 的 `system.stateVersion` 是整数，当前为 `7`。
- Home Manager 的 `home.stateVersion` 在 `home/core.nix`，当前为 `26.05`。

## 硬件配置

`hardware-configuration.nix` 按主机提交到仓库，包含文件系统 UUID、subvol 和内核模块，不含密钥。换磁盘或重装后重新生成并提交。

## 日常命令

仓库根目录的 `justfile` 封装常用操作：

```sh
just              # 列出当前平台可用的任务
just fmt          # 格式化所有 Nix 文件
just eval         # 求值 nixos-vm 和 mbp-m2pro
just build-darwin # 构建，默认 mbp-m2pro
just build-nixos  # 构建，默认 nixos-vm
just switch-darwin
just switch-nixos
just check
just update       # 仅明确升级依赖时
```

`build-*` 和 `switch-*` 的 `host` 是可选位置参数，省略时取 `hostname -s`，所以主机名要与 flake 属性名一致：

```sh
just switch-darwin other-mac
just switch-nixos other-host
```

`[macos]` 和 `[linux]` 属性让 `just --list` 只显示当前平台能跑的任务。`build-*` 只构建不切换；`switch-*` 会提权并应用。

没有 just 时使用原始命令：

```sh
nixfmt $(git ls-files '*.nix')

nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel --no-link

nix eval --raw \
  .#darwinConfigurations.mbp-m2pro.config.system.build.toplevel.drvPath
```

注册新 host 前先 `git add` 它的 `hardware-configuration.nix`：host 模块首行就 `import ./hardware-configuration.nix`，文件未跟踪时整个 flake 求值失败。

## 更多文档

- [hosts/README.md](hosts/README.md)：新增系统主机
- [modules/README.md](modules/README.md)：系统模块分层
- [home/README.md](home/README.md)：用户层、profile 与应用放置规则
- [home/common/README.md](home/common/README.md)：跨平台用户模块
- [home/linux/README.md](home/linux/README.md)：Linux 桌面、WM、WS、IM
