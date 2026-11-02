# Linux Home

Linux 专属用户配置。平台入口分 core 和 gui 两层。

```text
linux/
├── default.nix        # Linux core：CLI 包、Yazi
├── packages.nix       # Linux CLI/诊断/硬件工具
├── tui/yazi.nix       # Yazi 的 Linux 附加包
├── gui/               # Nautilus、Edge、Magpie
├── wm/niri/           # Niri 用户配置
├── ws/noctalia/       # Noctalia 用户配置
├── desktops/          # WM + WS 组合
├── im/rime/           # Fcitx5-Rime 静态配置
└── ssh-agent.nix
```

## Niri 的两层

- `modules/nixos/desktop/niri.nix` 是系统集成：安装 niri、注册 session、默认 session、systemd user unit、xdg-desktop-portal、gnome-keyring。
- `home/linux/wm/niri/` 是用户配置：`~/.config/niri/config.kdl`、`cfg/*.kdl`，以及 `xwayland-satellite`。

只启用系统模块会得到默认配置；只启用用户模块不会注册 session。两者需要同时存在。

## 桌面组合

`desktops/niri-noctalia.nix` 只做组合：

- 导入 `../wm/niri` 和 `../ws/noctalia`。
- 追加 `desktop-niri-noctalia.kdl`，放启动项和桌面快捷键。

新增 WM/WS 组合时新建 `desktops/<wm>-<ws>.nix`，再让 profile 指向它。不同主机用不同 WM 时，优先拆 profile，不在同一个 profile 里写条件分支。

## 服务器

`home/profiles/linux-server.nix` 只导入 `default.nix`、`packages.nix`、`tui/yazi.nix` 和 `ssh-agent.nix`，不导入 `gui/`、`wm/`、`ws/`、`desktops/`、`im/`。
