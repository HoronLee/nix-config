# Home

用户层配置。`core` 和 `gui` 是两个部署入口，`profiles/` 把它们和平台层组合成某类主机。

## 入口

| 文件 | 内容 | 用途 |
| --- | --- | --- |
| `core.nix` | CLI、TUI、Neovim、OMP、字体、主题 | 无 GUI 的服务器 |
| `gui.nix` | `core.nix` + `common/gui` | 桌面和 macOS |
| `linux/default.nix` | Linux CLI 包、Yazi | Linux core |
| `linux/gui/` | Nautilus、Edge、Magpie | Linux GUI |
| `profiles/` | 按主机角色组合 | flake 的 `homeModule` |

## Profiles

| Profile | 导入 | 适用 |
| --- | --- | --- |
| `linux-server.nix` | `core.nix` + `linux` + `ssh-agent` | 无 GUI 服务器 |
| `linux-desktop-niri.nix` | `gui.nix` + `linux` + `linux/gui` + Niri/Noctalia + Rime + SSH agent | Linux 桌面 |
| `darwin.nix` | `gui.nix` | macOS |

`linux-server` 仍然安装 btop、yazi、OMP 等 TUI 工具，只是不导入任何 GUI 模块。

## 放哪里

- 非交互 CLI 工具：`common/cli/`
- 交互式 TUI：`common/tui/`
- 跨平台 GUI：`common/gui/`
- Linux 专属 GUI：`linux/gui/`
- 窗口管理器：`linux/wm/`
- 桌面 Shell：`linux/ws/`
- 输入法：`linux/im/`
- 桌面组合：`linux/desktops/`

可选跨平台应用（Clash Verge、Ghostty、OBS、Obsidian）用 `my.apps` 开关，选项在 `modules/common/apps.nix`。

## scanPaths

叶子目录的 `default.nix` 使用 `mylib.scanPaths ./.` 自动导入同目录的 `.nix` 文件：

- 排除 `default.nix` 自身。
- 不递归子目录。
- 组合文件（`core.nix`、`gui.nix`、`profiles/`）保持显式 imports，便于看出层级。

`mylib` 由 `lib/mkNixosHost.nix` 和 `lib/mkDarwinHost.nix` 通过 `home-manager.extraSpecialArgs` 传入。
