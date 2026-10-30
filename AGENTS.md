# Repository Guidelines

## Project Overview

这是 HoronLee 的个人 NixOS 配置仓库，以 Nix/Flakes 和 Home Manager 声明系统、软件和用户环境。当前唯一输出为 `horon-vm`（`x86_64-linux`、nixos-unstable、niri + Noctalia、greetd/tuigreet）；物理机、服务器与 Darwin 尚未接入。

## Architecture & Data Flow

- `flake.nix` 注册主机并提供依赖；`lib/mkNixosHost.nix` 接收 `system`、`hostModule`、`username`、`homeModule`，组合 NixOS 和 HM。HM 复用系统 Nixpkgs，通过 `nixos-rebuild` 一起部署，无独立 HM 输出。
- 系统流：`flake.nix` → 构造器 → `hosts/x86_64-linux/horon-vm/default.nix` → 硬件与 `modules/nixos/*.nix`。
- 用户流：构造器 → `home/default.nix` → `home/common/` 和 `home/linux/`。当前入口无条件导入 Linux 模块，接入 Darwin 前需要调整。
- 主机决定硬件、引导、hostname 和模块选择；公共系统设置与用户设置分别维护。输出名 `horon-vm` 与实际 hostname `nixos` 不同，命令显式指定 `#horon-vm`。

## Key Directories

- `hosts/<platform>/<host>/`：主机装配入口和生成的硬件配置，按平台分组；不提前创建空主机。
- `modules/nixos/`：`base.nix` 管 Nix、网络、区域和基础编辑器；`user.nix` 管账户；`ssh.nix` 管 sshd；`desktop.nix` 管音频、打印与 Firefox；`niri.nix` 管桌面会话和登录；`input-method.nix` 管 Fcitx5-Rime。
- `home/common/`：Git/Lazygit、Shell/Starship、SSH 客户端、Yazi、Neovim、终端；Kitty 独立在 `terminals/kitty.nix`。
- `home/linux/`：用户工具、字体发现、Yazi 剪贴板依赖、SSH agent，以及 niri KDL、Noctalia TOML、Rime 用户补丁；`assets/wallpapers/` 保存固定桌面与锁屏背景。

## Development Commands

在真实仓库 `~/projects/nix-config` 中执行：

```sh
git add path/to/new-module.nix  # 替换为新增模块路径，Git flake 才能读取。
nix eval .#nixosConfigurations.horon-vm.config.system.build.toplevel.drvPath
nixos-rebuild build --flake .#horon-vm --no-link
# 用户要求应用时：
sudo nixos-rebuild switch --flake .#horon-vm
```

未提交的已跟踪文件仍可构建，dirty 警告正常。`nix flake update` 仅在明确升级时执行。未定义 `formatter`、`devShells` 或 lint 脚本，不把 `nix fmt`、`nix develop` 当作既有工作流。

## Code Conventions & Common Patterns

- 两空格缩进，`name = value;`，显式 `imports`；目录导入读取 `default.nix`。函数头只接收需要的 `pkgs`、`lib`、`config` 等参数。
- 默认值能省略就省略；启用项、用户选择和必要的非默认值显式声明。`programs.*` 已安装的软件不重复加入 `home.packages`。
- 模块按类型和优先级合并，不能依赖后导入覆盖前导入；不用 `mkForce` 掩盖归属冲突，不新增未使用的扫描器、开关、参数或框架。
- 依赖由主机构造器与模块系统传入，不逐文件手动传递 `pkgs/config`。无业务异步或状态机模式；遇到 Nix 求值错误修复原因，不隐藏错误。
- 公共别名使用 `home.shellAliases`；Starship、Yazi、Kitty 的 Shell 集成优先沿用 HM 默认，不复制函数或每个终端启动一个 agent。
- 系统 Neovim 供 root 基础编辑，HM 管个人编辑器；系统 Fish 管登录 Shell，HM Fish 管用户配置，不将这些视为重复。
- `system.stateVersion` 与 `home.stateVersion` 独立维护，不随软件源升级修改。更换机器重新生成硬件文件，禁止复用 VM 的磁盘 UUID。
- 保留任务之外的用户修改及已注释配置，不顺手启用或删除。GUI 修改不会反向写入 Nix。

## Important Files

- `flake.nix` / `flake.lock`：Nixpkgs `nixos-unstable`、HM `master`，HM `follows` Nixpkgs；具体版本由锁文件固定，需提交锁文件，不为日常配置改动更新。两处 `stateVersion` 保持 `26.05`。
- `hosts/x86_64-linux/horon-vm/hardware-configuration.nix`：QEMU、挂载和 swap 的生成配置；引导器和系统 `stateVersion` 在同目录 `default.nix`。
- `modules/nixos/user.nix`：账户与公钥；修改用户名需同步 flake 中的 `username`。`home/common/git.nix` 单独管理 Git 身份。
- `modules/nixos/ssh.nix`：禁止 root 直登，普通用户暂保留密码认证；不得擅自改变认证策略。
- `home/common/ssh.nix` / `home/linux/ssh-agent.nix`：按需加载密钥与 agent。私钥只放用户 `~/.ssh/`，不经 Nix 路径、`home.file` 或 Git 进入 Nix store。
- `home/linux/rime/default.nix`：固定万象语法模型 URL 与 hash；LTS 同名文件可能被上游覆盖，校验失败需明确更新。只部署静态补丁和模型，用户词库、缓存、凭据不得入 Git/store。
- Noctalia 负责 Polkit 提示、通知、剪贴板历史和锁屏；不叠加 KDE agent 或第二份 Noctalia 启动服务。当前无 idle 定时规则；GUI 覆盖层不自动进入声明。

## Runtime/Tooling Preferences

- Nix 是软件与环境的声明来源，HM 管 dotfiles；不恢复 chezmoi，不用 mise 维护另一份全局工具清单。无项目专用 Node/Bun/Python 运行时要求。
- 普通用户 `horonlee` 默认 Fish，root 保留 Bash。用户拥有仓库，日常编辑和 Git/Lazygit 不用 sudo；应用系统配置才提权。
- 不默认提交、推送或生成 `before-*` 备份；私钥、密码、令牌不写入仓库或日志。
- `/etc/nixos` 是用户仓库的链接。仅移除链接用 `sudo unlink /etc/nixos`；禁止对其执行递归删除，尤其不能带末尾 `/`。

## Testing & QA

- 无测试框架、覆盖率目标、CI 或仓库脚本。`nix flake check` 可检查输出求值，但无自定义 `checks`，不能代替整机构建。
- 配置改动至少完成 `build`；用户自行验证功能，默认不启动 GUI、不做交互验收、不运行 `switch/boot`，明确要求应用时除外。区分构建通过与功能验证。
- 文档改动只核对路径、命令和事实，不为此添加测试设施。HM 接管文件遇到冲突时保留用户内容，不强制覆盖或删除来绕过检查。
- 维护笔记写到宿主机 `~/nixos.md`，不写进 `~/Niri.md`。Nix 回滚不恢复文档、数据库等动态数据。

## 参考资料

- https://github.com/ryan4yin/nix-config
- https://github.com/ryan4yin/nix-config/tree/i3-kickstarter
- https://tangled.org/pluie.me/flake
- https://codeberg.org/ity/tablet

