# Modules

系统层模块按平台和职责分组。

```text
modules/
├── common/apps.nix          # 跨平台应用选项
├── nixos/
│   ├── system/              # base、nix、user、ssh
│   ├── desktop/             # services、firefox、niri、greeter、input-method
│   ├── apps.nix             # NixOS 侧应用安装
│   └── server.nix           # 服务器基础模块
└── darwin/apps.nix          # macOS cask 安装
```

## NixOS

- `system/default.nix` 聚合 `base.nix`、`nix.nix`、`user.nix`、`ssh.nix`，所有 NixOS 主机都应导入。
- `desktop/default.nix` 聚合桌面服务、Firefox、Niri 和输入法。`greeter.nix` 不放进聚合，服务器不会因为导入桌面模块而启动图形登录。
- `apps.nix` 实现 `my.apps.*` 的 NixOS 安装，例如 `programs.clash-verge`。
- `server.nix` 放服务器通用项：固件、`smartd`。

## 跨平台应用

选项在 `modules/common/apps.nix`，NixOS 实现在 `modules/nixos/apps.nix`，macOS 实现在 `modules/darwin/apps.nix`。

```nix
my.apps = {
  clash-verge.enable = true;
  ghostty.enable = true;
};
```

这套开关只决定桌面主机上装不装某个跨平台应用。GUI 与无 GUI 的划分由 `home/core.nix` 和 `home/gui.nix` 负责。

## 新增模块

- 系统服务、用户、启动相关：放 `modules/nixos/system/` 或 `modules/nixos/desktop/`。
- 跨平台应用：在 `modules/common/apps.nix` 加选项，再在两个平台模块里实现。
- 只在服务器使用的服务：放 `modules/nixos/server.nix`，或新建服务器子模块并由 host 显式导入。
