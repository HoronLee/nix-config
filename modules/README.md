# Modules

系统层模块，按平台和职责分组。

```text
modules/
├── common/apps.nix          # 有平台差异的应用开关
├── nixos/
│   ├── system/              # base、nix、user、ssh
│   ├── desktop/             # services、firefox、niri、greeter、input-method
│   ├── apps.nix             # NixOS 侧应用安装
│   ├── docker.nix           # Docker Engine、Compose、Buildx
│   ├── server.nix           # 服务器通用项
│   └── server/mihomo/       # Mihomo 服务
└── darwin/apps.nix          # macOS cask 与差异实现
```

## NixOS

- `system/default.nix` 聚合 `base.nix`、`nix.nix`、`user.nix`、`ssh.nix`。
- `desktop/default.nix` 聚合桌面服务、Firefox、Niri 和输入法；`greeter.nix` 单独导入，服务器不会启动图形登录。
- `apps.nix` 实现需要 NixOS 集成的应用，例如 `programs.clash-verge`。
- `server.nix` 放服务器通用项：固件、`smartd`，并导入 `server/mihomo`。

## 应用开关

`my.apps` 只用于 Linux 和 macOS 实现不同、且需要统一开关的应用。选项在 `modules/common/apps.nix`，Linux 实现在 `modules/nixos/apps.nix`，macOS 实现在 `modules/darwin/apps.nix`。

```nix
my.apps = {
  clash-verge.enable = true;
  ghostty.enable = true;
  obs.enable = true;
};
```

两个平台使用同一个 nix 包时，直接放 `home/common/gui/packages.nix`，不增加开关。完整规则见 [`home/README.md`](../home/README.md#gui-应用放置规则)。

## 新增模块

- 系统服务、用户、启动：`modules/nixos/system/` 或 `modules/nixos/desktop/`。
- 需要平台差异的应用：在 `modules/common/apps.nix` 加选项，再在两侧实现。
- 只在服务器使用的服务：`modules/nixos/server.nix` 或新建子模块，由 host 显式导入。
