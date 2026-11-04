# Modules

系统层模块，按平台和职责分组。

```text
modules/
├── common/
│   ├── apps.nix             # 有平台差异的应用开关
│   └── nix.nix              # Linux 与 macOS 共用的 Nix/nixpkgs 设置
├── nixos/
│   ├── system/              # base、nix、user、ssh
│   ├── desktop/             # services、firefox、niri、greeter、input-method
│   ├── apps.nix             # NixOS 侧应用安装
│   ├── docker.nix           # Docker Engine、Compose、Buildx
│   ├── server.nix           # 服务器通用项
│   └── server/mihomo/       # Mihomo 服务
└── darwin/
    ├── default.nix          # Darwin 公共入口：Homebrew 策略
    └── apps.nix             # macOS cask 与差异实现
```

## Common

- `nix.nix` 统一开启 `allowUnfree` 和 `nix-command`、`flakes`。
- `auto-allocate-uids`、`configurable-impure-env` 属于 NixOS 专属设置，留在 `nixos/system/nix.nix`。

## NixOS

- `system/default.nix` 聚合 `common/nix.nix`、`base.nix`、`nix.nix`、`user.nix`、`ssh.nix`。
- `desktop/default.nix` 聚合桌面服务、Firefox、Niri 和输入法；`greeter.nix` 单独导入，服务器不会启动图形登录。
- `apps.nix` 实现需要 NixOS 集成的应用，例如 `programs.clash-verge`。
- `server.nix` 放服务器通用项：固件、`smartd`，并导入 `server/mihomo`。

## Darwin

- `default.nix` 是所有 Darwin 主机共用的入口，导入 `common/nix.nix` 并启用 Homebrew；activation 不自动更新或升级 brew 包。
- `apps.nix` 声明 cask；`homebrew.enable` 只调用已有 `brew`，不会安装 Homebrew 本体。
- `nix-homebrew` 未引入；brew 包更新继续手动执行 `brew upgrade`。
- `system.primaryUser` 由 host 提供，Homebrew 默认使用该用户。

## 应用开关

Home Manager 优先：能在 `home/` 用 `home.packages` 或程序模块装好的应用，不放进 `modules/`。`modules/` 只处理需要系统服务、系统扩展、privileged helper 或系统级路径的软件。

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
- 两个平台都需要的基础设置：`modules/common/`，再由两侧入口导入。
- 需要平台差异的应用：在 `modules/common/apps.nix` 加选项，再在两侧实现。
- 只在服务器使用的服务：`modules/nixos/server.nix` 或新建子模块，由 host 显式导入。
