# Common

跨平台 Home Manager 模块，Linux 和 macOS 共用。

```text
common/
├── agents/       # OMP
├── cli/          # eza、fzf、git
├── tui/          # btop、yazi、zellij、herdr
├── terminals/    # Ghostty、Kitty
├── gui/          # 跨平台 GUI 包
├── editor/       # Neovim、Zed
├── fonts.nix
├── packages.nix  # CLI 与开发工具
├── shell.nix     # Fish、Bash、Starship
├── ssh.nix       # SSH 客户端与 agent
└── theme.nix     # Catppuccin
```

## 规则

- `gui/` 只放两个平台都使用同一个 nix 包的应用；Linux 专属放 `home/linux/gui/`。
- `gui/default.nix` 显式导入 `packages.nix`；`packages.nix` 只放无条件安装的 GUI 包。
- `cli/`、`tui/`、`terminals/`、`agents/` 的 `default.nix` 使用 `mylib.scanPaths ./.`。
- 需要系统级集成的应用不在这里安装，例如 Clash Verge 的 service/TUN 由 `modules/nixos/apps.nix` 处理。
- 应用放置的完整规则见 [`home/README.md`](../README.md#gui-应用放置规则)。
