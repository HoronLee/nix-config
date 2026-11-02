# Common

跨平台 Home Manager 模块。Linux 和 macOS 共享这里的 CLI、TUI 和跨平台 GUI 配置。

```text
common/
├── agents/       # OMP
├── cli/          # eza、fzf、git/lazygit
├── tui/          # btop、yazi
├── terminals/    # Kitty、Ghostty
├── gui/          # Bitwarden、Zed、终端
├── editor/
│   ├── nvim/     # Neovim 与 LazyVim
│   └── zed/      # Zed 设置
├── fonts.nix
├── packages.nix  # 跨平台 CLI 与开发工具
├── shell.nix     # Fish、Bash、Starship
├── ssh.nix
└── theme.nix     # Catppuccin
```

## 规则

- `cli/`、`tui/`、`terminals/`、`agents/` 的 `default.nix` 使用 `mylib.scanPaths ./.`，新增同目录 `.nix` 文件会自动导入。
- `gui/` 只放跨平台 GUI；Linux 专属 GUI 放 `home/linux/gui/`。
- 需要系统级集成的应用不在这里安装，例如 Clash Verge 的 service/TUN 由 `modules/nixos/apps.nix` 处理。
- `packages.nix` 保持 CLI/开发工具，不放 GUI 应用。
