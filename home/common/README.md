# Common
跨平台 Home Manager 模块，Linux 和 macOS 共用。
```text
common/
├── agents/       # OMP、Codex、Claude
├── cli/          # eza、fzf、git、mise
├── tui/          # btop、yazi、zellij、herdr
├── terminals/    # Ghostty、Kitty
├── gui/          # 跨平台 GUI 包
├── editor/       # Neovim、Zed
├── im/rime/      # Fcitx5 与 Squirrel 共用的 Rime 配置
├── fonts.nix
├── packages.nix  # 语言、构建、LSP、CLI 与开发工具
├── shell.nix     # Fish、Bash、Starship
├── ssh.nix       # SSH 客户端与 agent
└── theme.nix     # Catppuccin
```
## 规则
- `gui/` 只放两个平台都使用同一个 nix 包的应用；Linux 专属放 `home/linux/gui/`。
- `gui/default.nix` 显式导入 `packages.nix`；`packages.nix` 只放无条件安装的 GUI 包。
- `cli/`、`tui/`、`terminals/`、`agents/` 的 `default.nix` 使用 `mylib.scanPaths ./.`。
- `packages.nix` 按语言、包管理器、LSP、构建、开发辅助等用途分组；只提供 Darwin 版本的 CLI 放 `home/darwin/packages.nix`。
- `mise` 管理编程语言运行时、包管理器、高频更新的开发 CLI 与 npm 工具；底层构建与通用 CLI 优先用 Nix，重复项由使用者主动避免。
- 需要系统级集成的应用不在这里安装，例如 Clash Verge 的 service/TUN 由 `modules/nixos/apps.nix` 处理。
- 应用放置的完整规则见 [`home/README.md`](../README.md#gui-应用放置规则)。
- Zed 的设置和快捷键通过可写符号链接同步；Catppuccin 配色与图标由 `settings.json` 的 `auto_install_extensions` 安装，应用按系统亮暗选择 Latte/Mocha，关闭 `catppuccin.zed` 集成以避免重复管理。
- Ghostty、Kitty 在 macOS 上均将左右 Option 作为 Alt 使用。
- Fish 的 `kssh` 使用 Kitty SSH 集成，`gssh` 使用 Ghostty SSH 集成。
