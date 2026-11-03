# Repository Guidelines

## Project Overview

这是 HoronLee 的个人 Nix 配置仓库，用 Nix Flakes 管理 NixOS、nix-darwin 和内嵌 Home Manager。当前输出：

- `nixosConfigurations.nixos-vm`：`x86_64-linux`，UEFI + systemd-boot，Niri + Noctalia，Fcitx5-Rime。
- `darwinConfigurations.mbp-m2pro`：`aarch64-darwin`，Homebrew cask。
- `dell-r430`：host 模块已存在，`hardware-configuration.nix` 尚未生成，暂未注册到 flake。

## Architecture & Data Flow

- 系统流：`flake.nix` → `lib/mkNixosHost.nix` 或 `lib/mkDarwinHost.nix` → `hosts/<system>/<host>/default.nix` → `modules/nixos/*` 或 `modules/darwin/*`。
- 用户流：构造器的 `homeModule` → `home/profiles/*.nix` → `home/core.nix` 或 `home/gui.nix` → `home/common/*`、`home/linux/*`。
- Home Manager 复用系统 nixpkgs，通过 `nixos-rebuild` / `darwin-rebuild` 部署；没有独立 `homeConfigurations`。
- `lib/scanPaths.nix` 通过 `mylib` 传入 HM，只用于叶子目录；组合文件保持显式 imports。
- 主机决定硬件、引导、hostname、系统模块；profile 决定用户层是 core、gui 还是 Linux 桌面组合。

## Key Directories

- `hosts/<system>/<host>/`：主机装配入口和生成的硬件配置。`default.nix` 管 hostname、bootloader、`system.stateVersion` 和系统模块 imports。
- `modules/nixos/system/`：`default.nix` 聚合 `base.nix`、`nix.nix`、`user.nix`、`ssh.nix`。
- `modules/nixos/desktop/`：`default.nix` 聚合 `services.nix`、`firefox.nix`、`niri.nix`、`input-method.nix`；`greeter.nix` 单独导入。
- `modules/nixos/apps.nix`：`my.apps` 的 NixOS 安装实现；`modules/darwin/apps.nix`：macOS cask 实现；`modules/common/apps.nix`：选项声明。
- `modules/nixos/server.nix`：服务器通用项，包含固件、`smartd` 和 `server/mihomo`。
- `home/core.nix`：无 GUI 的用户层，含 CLI、TUI、Neovim、OMP、字体、主题。
- `home/gui.nix`：`core.nix` 加 `home/common/gui`，供桌面和 macOS 使用。
- `home/common/`：`cli/`、`tui/`、`terminals/`、`gui/`、`editor/`、`agents/`、`packages.nix`、`shell.nix`、`ssh.nix`、`fonts.nix`、`theme.nix`。
- `home/linux/`：`default.nix` 是 Linux core；`gui/` 是 Linux GUI；`wm/niri/`、`ws/noctalia/`、`desktops/`、`im/rime/` 是桌面、Shell、输入法配置。
- `home/profiles/`：`linux-server.nix`、`linux-desktop-niri.nix`、`darwin.nix`。

## GUI 与服务器

- `linux-server` 只导入 `core.nix` 和 `linux`，不导入 `common/gui`、`linux/gui`、桌面组合或 Rime。
- `linux-desktop-niri` 导入 `gui.nix`、`linux`、`linux/gui`、`desktops/niri-noctalia.nix` 和 `im/rime`。
- `darwin` 导入 `gui.nix`。
- `my.apps` 只决定桌面主机上可选跨平台应用是否安装，例如 `clash-verge`、`ghostty` 和 `obs`；它不负责 GUI/无 GUI 的划分。
- 服务器需要代理时用 `services.mihomo`，配置文件放在 Nix store 之外；不要为了代理把 Clash Verge GUI 加进 server profile。

## Development Commands

在真实仓库 `~/projects/nix-config` 中执行：

```sh
git add path/to/new-module.nix  # 新增文件必须先进入 Git，flake 才能读取。
nix eval .#nixosConfigurations.nixos-vm.config.system.build.toplevel.drvPath
nixos-rebuild build --flake .#nixos-vm --no-link
nix eval --raw .#darwinConfigurations.mbp-m2pro.config.system.build.toplevel.drvPath

# 用户明确要求应用时：
sudo nixos-rebuild switch --flake .#nixos-vm
sudo darwin-rebuild switch --flake .#mbp-m2pro
```

格式化使用 `nixfmt`，不要假设存在 `nix fmt` 或 `devShells`。`nix flake update` 只在明确升级依赖时执行。

## Code Conventions & Common Patterns

- 两空格缩进，`name = value;`；组合文件使用显式 `imports`。
- 叶子目录的 `default.nix` 可以用 `mylib.scanPaths ./.`：只导入普通 `.nix` 文件，排除自身，不递归子目录。不要在组合层使用扫描器。
- 模块按类型和优先级合并，不依赖导入顺序覆盖；不用 `mkForce` 掩盖归属冲突。
- `system.stateVersion` 使用首次安装的 release，不随 nixpkgs 升级修改；NixOS 主机当前为 `26.05`，darwin 为 `7`，`home.stateVersion` 在 `home/core.nix`。
- `hardware-configuration.nix` 按主机提交；它包含磁盘 UUID、subvol 和内核模块，不包含密钥。换机器时重新生成，禁止复用 VM 的文件。
- bootloader 与固件、磁盘布局相关，放 host 模块，不放进硬件文件。
- 私钥、订阅地址、controller secret 不进入 Git 或 Nix store；需要时用 sops-nix/agenix，或放在 `/etc` 下并限制权限。
- 有 NixOS 模块的应用用模块安装；没有模块的 GUI 才放 `home/*/gui` 或 `home.packages`。`programs.*` 已安装的软件不重复加入 `home.packages`。
- 保留任务之外的用户修改及已注释配置，不顺手启用或删除。

## Important Files

- `flake.nix` / `flake.lock`：nixpkgs `nixos-unstable`、HM `master`、Catppuccin `main`、OMP、`sugar/magpie`。
- `lib/mkNixosHost.nix` / `lib/mkDarwinHost.nix`：组合系统与内嵌 HM，并传入 `mylib`；NixOS 侧还传 `magpieApp`。
- `hosts/x86_64-linux/nixos-vm/hardware-configuration.nix`：VM 的磁盘、挂载和 swap。
- `modules/nixos/system/user.nix`：账户与公钥；改用户名需同步 flake 的 `username`。`home/common/cli/git.nix` 管 Git 身份。
- `modules/nixos/system/ssh.nix`：sshd 策略；不得擅自改变认证方式。
- `home/common/ssh.nix`：客户端配置与 agent；私钥只放 `~/.ssh/`。
- `home/linux/im/rime/default.nix`：固定万象语法模型 URL 与 hash；只部署静态补丁和模型，用户词库、缓存、凭据不入仓库。
- `home/common/agents/`：OMP、Codex、Claude 等 agent 工具；`home/linux/gui/magpie.nix`：Linux 专用 Magpie 安装。
- `home/linux/wm/niri/`：用户 KDL；`modules/nixos/desktop/niri.nix`：系统 session、portal、keyring。两者职责不同，不能互相替代。
- `home/linux/ws/noctalia/`：Noctalia 用户 TOML 与壁纸；`modules/nixos/desktop/greeter.nix`：Noctalia Greeter 登录管理器。

## Runtime/Tooling Preferences

- Nix 声明系统级与用户级软件环境；Home Manager 管用户级软件包和 dotfiles，系统级配置由 NixOS/nix-darwin 模块负责。
- `mise` 只用于 nixpkgs 难以打包的 npm 工具和项目版本切换；其余工具优先用 Nix，重复项由使用者主动避免。
- 普通用户 `horonlee` 默认 Fish，root 保留 Bash。日常编辑和 Git/Lazygit 不用 sudo；应用系统配置才提权。
- 默认不提交、推送或生成 `before-*` 备份；私钥、密码、令牌不写入仓库或日志。
- `/etc/nixos` 是用户仓库的链接。移除链接只用 `sudo unlink /etc/nixos`，禁止递归删除。

## Testing & QA

- 无测试框架、覆盖率目标、CI 或仓库脚本。`nix flake check` 可检查输出求值，但不能代替整机构建。
- 配置改动至少完成 `build` 或对应平台的 `nix eval`；用户自行验证功能。默认不启动 GUI、不做交互验收、不运行 `switch/boot`，明确要求应用时除外。
- 文档改动只核对路径、命令和事实，不为此添加测试设施。
- 维护笔记写到宿主机 `~/nixos.md`。Nix 回滚不恢复文档、数据库等动态数据。

## 参考资料

- <https://github.com/ryan4yin/nix-config>
- <https://tangled.org/pluie.me/flake>
- <https://codeberg.org/ity/tablet>
