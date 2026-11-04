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

7. activation 前会执行 `brew bundle cleanup`（`cleanup = "check"`）。手动 `brew install` 但未声明的包会让 switch 中止并列出清单；先写进 `modules/darwin/apps.nix`，或运行 `brew bundle cleanup --force`。

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

## 桌面与服务器

| Profile | 导入内容 | 用途 |
| --- | --- | --- |
| `linux-server.nix` | `core.nix` + `linux` | 无 GUI 的服务器 |
| `linux-desktop-niri.nix` | `gui.nix` + `linux` + `linux/gui` + Niri/Noctalia + Rime | Linux 桌面 |
| `darwin.nix` | `gui.nix` | macOS |

`linux-server` 仍包含 btop、yazi、OMP 等 TUI 工具，只是不安装 GUI 应用。SSH agent 由 `home/common/ssh.nix` 在 Linux 和 macOS 上统一启用。

## 新增软件

按 Home Manager → 系统模块 → Homebrew 的顺序选择落点。Home Manager 管用户级软件和 dotfiles，不需要 root，随用户 profile 一起切换；系统模块只处理必须有系统权限或系统集成的东西；Homebrew 是 macOS 上 nixpkgs 不可用时的最后选择。

### 1. 判断需要哪一层

| 需求 | 层 | 位置 |
| --- | --- | --- |
| 用户级 CLI 或 GUI，nixpkgs 有包 | Home Manager | `home/` |
| 需要 systemd/launchd 服务、系统扩展、privileged helper、系统级路径 | 系统模块 | `modules/` |
| macOS 无 nix 包、版本明显落后，或必须用 pkg/helper 安装 | Homebrew | `modules/darwin/apps.nix` |

同一个应用只要能在 Home Manager 里装好，就不要放进 `modules/`。`modules/` 里的包以 root 安装、对所有用户可见，回滚粒度也更粗。

### 2. 查 nixpkgs 与 Homebrew

```sh
nix eval --json nixpkgs#<pkg>.meta.platforms
nix eval --raw nixpkgs#<pkg>.version
brew info <formula>
brew info --cask <cask>
```

关注 platforms 是否包含 `aarch64-darwin` 和 `x86_64-linux`，以及 brew 侧是否有 `auto_updates`、是否安装 pkg 或 helper。用 `nix` MCP 可以查同样的信息。

### 3. Home Manager 内部的位置

| 情况 | 文件 |
| --- | --- |
| 跨平台 CLI、构建工具、语言运行时 | `home/common/packages.nix` |
| 跨平台 GUI，两个平台都有 nix 包 | `home/common/gui/packages.nix` |
| 跨平台 GUI，需要选项、override 或额外配置 | `home/common/<category>/<app>.nix` |
| Linux 专属 CLI | `home/linux/packages.nix` |
| Linux 专属 GUI | `home/linux/gui/packages.nix` |
| Darwin 专属 CLI | `home/darwin/packages.nix` |
| Darwin 专属 GUI，nix 包有 Darwin 版 | `home/common/gui/packages.nix`；需要配置时放 `home/darwin/<category>/` |

`home/common/` 是用户层跨平台配置，`modules/common/` 是系统层共享设置（`nix.nix`、`my.apps` 选项），两者不互相替代。

### 4. 系统模块的位置

| 情况 | 文件 |
| --- | --- |
| 需要 `programs.<name>`、NixOS service 或系统级依赖 | `modules/nixos/apps.nix` |
| 通用 NixOS 系统或桌面配置 | `modules/nixos/system/`、`modules/nixos/desktop/` |
| 只在服务器启用的服务 | `modules/nixos/server.nix` 或子模块 |
| macOS cask / brew formula | `modules/darwin/apps.nix`；第三方 tap 同时写 `homebrew.taps` |
| 两个平台都要，但实现不同 | `my.apps` 选项在 `modules/common/apps.nix`，再分别在 `modules/nixos/apps.nix` 和 `modules/darwin/apps.nix` 实现 |

`modules/common/apps.nix` 只定义选项，不安装软件；`modules/darwin/apps.nix` 只把选项映射到 cask。Nix 包不要放进这两个文件。

### 5. 检查清单

- 第三方 tap 必须同时写进 `homebrew.taps`，否则 `cleanup = "check"` 会在 activation 前中止 switch。
- 不要手动 `brew install` 长期使用的包；未声明的包会让下次 switch 中止。
- 新增 `.nix` 文件后 `git add`，flake 只读取 Git 跟踪的文件。
- 改完跑 `nixfmt` 和对应平台的求值命令。

完整规则见 [`home/README.md`](home/README.md#gui-应用放置规则) 和 [`modules/README.md`](modules/README.md#应用开关)。

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
- [home/README.md](home/README.md)：用户层、profile 与应用放置规则
- [home/common/README.md](home/common/README.md)：跨平台用户模块
- [home/linux/README.md](home/linux/README.md)：Linux 桌面、WM、WS、IM
