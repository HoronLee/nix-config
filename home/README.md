# Home
用户层配置。`core.nix` 和 `gui.nix` 是两个入口，`profiles/` 把它们与平台层组合成具体主机。
## 入口
| 文件 | 内容 | 用途 |
| --- | --- | --- |
| `core.nix` | CLI、TUI、Neovim、OMP、字体、主题 | 服务器 |
| `gui.nix` | `core.nix` + `common/gui` | 桌面和 macOS |
| `linux/default.nix` | Linux CLI 包、Yazi | Linux core |
| `linux/gui/` | Linux 专属 GUI | Linux 桌面 |
| `profiles/` | 按主机角色组合 | flake 的 `homeModule` |
## Profiles
| Profile | 导入 | 适用 |
| --- | --- | --- |
| `linux-server.nix` | `core.nix` + `linux` | 无 GUI 服务器 |
| `linux-desktop-niri.nix` | `gui.nix` + `linux` + `linux/gui` + Niri/Noctalia + Rime | Linux 桌面 |
| `darwin.nix` | `gui.nix` + `darwin/packages.nix` + Karabiner + Rime | macOS |
SSH agent 由 `common/ssh.nix` 统一启用，Linux 使用 systemd，macOS 使用 launchd。
## GUI 应用放置规则
优先使用 nixpkgs。只有 nixpkgs 没有 Darwin 支持、版本明显落后，或应用依赖 macOS 系统扩展/后台 helper 时，才使用 Homebrew cask。
| 情况 | 位置 |
| --- | --- |
| 两个平台都有同一个 nix 包 | `common/gui/packages.nix` |
| 只支持当前平台且始终安装的 nix 包 | 该平台 `gui/packages.nix` |
| nixpkg 只支持 Linux，macOS 需要 cask | `my.apps` + `modules/nixos/apps.nix` + `modules/darwin/apps.nix` |
| 只支持 macOS、无可用 nix 包且始终安装 | `modules/darwin/apps.nix` 的 cask |
| 两个平台实现不同，且需要统一开关 | `my.apps` + 两侧实现 |
| 需要选项、override、补丁、额外配置 | 单独 `<app>.nix` |
`modules/common/apps.nix` 只定义 `my.apps` 选项，不负责安装；`modules/darwin/apps.nix` 只把选项映射到 cask；Nix 包不要放在这两个文件里。
`my.apps` 只用于有平台差异或需要统一开关的应用，不用于所有跨平台包。当前使用它的只有 `clash-verge`、`ghostty`、`obs`。
## 放哪里
- 非交互 CLI：`common/cli/`
- 交互式 TUI：`common/tui/`
- 跨平台 GUI：`common/gui/`
- Linux 专属 GUI：`linux/gui/`
- Darwin 专属 CLI：`darwin/packages.nix`
- 窗口管理器：`linux/wm/`
- 桌面 Shell：`linux/ws/`
- 输入法：`linux/im/` 与 `darwin/im/`
- 桌面组合：`linux/desktops/`
`common/packages.nix` 放跨平台语言工具、构建工具和常用 CLI，并按用途分组；只提供 Darwin 版本的 CLI 放 `darwin/packages.nix`。
## 自动导入
`mylib.scanPaths ./.` 只读取当前目录的普通 `.nix` 文件，排除 `default.nix`，不递归子目录。
- `cli/`、`tui/`、`terminals/`、`agents/` 使用自动导入。
- `gui/` 使用显式 imports，便于看清文件职责。
- 被当作目录导入的目录需要 `default.nix`；直接导入具体 `.nix` 文件的目录不需要。
`mylib` 由 `lib/mkNixosHost.nix` 和 `lib/mkDarwinHost.nix` 通过 `home-manager.extraSpecialArgs` 传入。
