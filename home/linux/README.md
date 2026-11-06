# Linux Home

Linux 专属用户配置，分为 core 和 gui 两层。

```text
linux/
├── default.nix        # Linux core：CLI 包，默认关闭 fontconfig
├── packages.nix       # Linux CLI/诊断/硬件工具
├── tui/yazi.nix       # Yazi 图形剪贴板支持，仅由 gui/ 导入
├── gui/               # Linux GUI 应用、fontconfig、图形剪贴板支持
├── wm/niri/           # Niri 用户配置
├── ws/noctalia/       # Noctalia 用户配置
├── desktops/          # WM + WS 组合
└── im/rime/           # Fcitx5-Rime 静态配置
```

## Niri 的两层

- `modules/nixos/desktop/niri.nix`：系统集成，安装 niri、注册 session、systemd user unit、portal、gnome-keyring。
- `home/linux/wm/niri/`：用户配置，包含 `config.kdl`、`cfg/*.kdl` 和 `xwayland-satellite`。

只启用系统模块会得到默认配置；只启用用户模块不会注册 session。

## 桌面组合

`desktops/niri-noctalia.nix` 只做组合：

- 导入 `../wm/niri` 和 `../ws/noctalia`。
- 追加启动项和桌面快捷键。

新增组合时新建 `desktops/<wm>-<ws>.nix`，再让 profile 指向它。不同主机使用不同 WM 时优先拆 profile，不在同一 profile 里写条件分支。

## GUI

- `gui/packages.nix`：无条件安装的 Linux GUI 包。
- `gui/magpie.nix`：特殊参数和平台判断。
- `gui/obs.nix`：受 `my.apps.obs` 控制。
- `gui/default.nix`：启用 fontconfig，导入 `tui/yazi.nix` 的 Wayland/X11 剪贴板工具；服务器不导入这些设置。

跨平台 GUI 放到 `home/common/gui/`；完整规则见 [`home/README.md`](../README.md#gui-应用放置规则)。

## 服务器

`home/profiles/linux-server.nix` 导入 `core.nix` 和 `linux`，不导入 `gui/`、`wm/`、`ws/`、`desktops/`、`im/`。SSH agent 由 `home/common/ssh.nix` 提供。
