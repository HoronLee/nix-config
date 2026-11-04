---
name: nix-add-software
description: 向 nix-config 仓库添加或调整软件。当用户说装/添加/安装/引入某个软件到 NixOS、macOS 或 nix-config，给出软件名、GitHub 仓库、官网 URL，或问某个软件该放哪个文件时使用。用户没说平台或放置位置时必须先询问，确认前不要改文件。
---

# 向 nix-config 添加软件

目标：把一个软件放到正确的层和文件，改完后能通过求值，并告诉用户下次 switch 会发生什么。

## 交互规则

用户只给软件名或 URL 时，先识别软件身份，再按下面的顺序确认。**任何一项用户没明确说，就停下来问，不要猜。**确认完之前不要调用 `edit`/`write` 修改仓库。

确认清单，按顺序：

1. **平台**：只在 NixOS、只在 macOS，还是两个平台都要。
2. **用途**：CLI、GUI，还是需要系统服务、系统扩展、privileged helper。
3. **层**：Home Manager 还是系统模块；两个平台都要时，是否用 `my.apps` 统一开关。
4. **文件**：具体写进哪个文件的哪个列表。

每次准备修改前，用一句话展示"软件 → 平台 → 层 → 文件"的决定，等用户确认。用户说"你决定"时，给出选项和推荐，仍然要一次确认再动手。

用户已经在本轮对话里明确说过的信息不要重复问。仓库本身能回答的（现有声明、目录结构、已装版本）不要问用户。

## 步骤

### 1. 识别软件并查证

从名称或 URL 得到候选：上游项目名、nixpkgs attr、Homebrew formula/cask 名。三者经常不同，逐个核对。

查 nixpkgs：

```sh
nix eval --json nixpkgs#<attr>.meta.platforms
nix eval --raw nixpkgs#<attr>.version
nix eval --raw nixpkgs#<attr>.meta.description
```

用 `nix` MCP 的 `nix` 工具搜索 attr 名。`nix eval` 报 attribute missing 时，说明 attr 名或包不存在，换关键词再搜。

查 Homebrew（macOS 候选）：

```sh
brew info <formula>
brew info --cask <cask>
```

记录版本、`auto_updates`、是否通过 pkg 安装、是否依赖 helper 或系统扩展。

同时检查仓库里是否已经声明过该软件：

```sh
rg -n '<software>' home modules
```

已经存在时不要重复添加，告诉用户当前位置，问是否要调整。

### 2. 确定层和文件

按 Home Manager → 系统模块 → Homebrew 的顺序选。能由用户级 `home.packages` 装好的，不放 `modules/`；`modules/` 里的包以 root 安装。

| 情况 | 层 | 文件 |
| --- | --- | --- |
| 跨平台 CLI、构建工具、语言运行时 | Home Manager | `home/common/packages.nix` |
| 跨平台 GUI，两个平台都有 nix 包 | Home Manager | `home/common/gui/packages.nix` |
| 跨平台 GUI，需要选项、override 或额外配置 | Home Manager | `home/common/<category>/<app>.nix` |
| Linux 专属 CLI | Home Manager | `home/linux/packages.nix` |
| Linux 专属 GUI | Home Manager | `home/linux/gui/packages.nix` |
| Darwin 专属 CLI | Home Manager | `home/darwin/packages.nix` |
| Darwin 专属 GUI，nix 包有 Darwin 版 | Home Manager | `home/common/gui/packages.nix`；需要配置时 `home/darwin/<category>/` |
| 需要 `programs.<name>`、NixOS service 或系统级依赖 | 系统模块 | `modules/nixos/apps.nix` |
| 通用 NixOS 系统或桌面配置 | 系统模块 | `modules/nixos/system/`、`modules/nixos/desktop/` |
| 只在服务器启用的服务 | 系统模块 | `modules/nixos/server.nix` 或子模块 |
| macOS cask / brew formula | Homebrew | `modules/darwin/apps.nix`；第三方 tap 同时写 `homebrew.taps` |
| 两个平台都要，但实现不同，且始终安装 | 两侧 | `home/linux/gui/packages.nix` + `modules/darwin/apps.nix` |
| 两个平台都要，但实现不同，且需要统一开关 | 两侧 | `my.apps` 选项在 `modules/common/apps.nix`，分别在 `modules/nixos/apps.nix` 和 `modules/darwin/apps.nix` 实现 |

nixpkgs 只有 Linux 包、用户又要 macOS 时，macOS 侧只能走 cask 或 `my.apps`。nixpkgs 只有 Darwin 包时，Linux 侧要另找实现或告诉用户不可用。

`modules/common/apps.nix` 只定义 `my.apps` 选项，不装包。`modules/darwin/apps.nix` 只映射 cask。Nix 包不放进这两个文件。

### 3. 修改文件

在动手前再确认一次："将修改 `<文件>` 的 `<列表>`，加入 `<条目>`，可以吗？"

- 按仓库现有分组和注释风格插入，两空格缩进，用 `nixfmt` 格式化。
- 需要新文件时先创建，再 `git add`；flake 只读取 Git 跟踪的文件。
- 需要 `my.apps` 开关时，同时在 `modules/common/apps.nix` 加选项，并在两侧实现。
- 第三方 tap 必须同时写进 `homebrew.taps`，否则 `cleanup = "check"` 会中止 switch。
- 不改无关配置，不删用户已有声明，不顺手启用注释掉的模块。

### 4. 验证

至少做求值；用户要求应用时才 switch。

```sh
nixfmt <changed files>

# macOS
nix eval --raw .#darwinConfigurations.mbp-m2pro.config.system.build.toplevel.drvPath

# NixOS
nix eval --raw .#nixosConfigurations.nixos-vm.config.system.build.toplevel.drvPath
```

需要确认包真的进入 profile 时，查 `home.packages`：

```sh
nix eval --json .#darwinConfigurations.mbp-m2pro.config.home-manager.users.horonlee.home.packages \
  --apply 'ps: map (p: p.name) ps' | rg '<name>'
```

### 5. 报告

用简短表格说明：软件、平台、层、文件、查到的版本和 platforms、验证结果。列出仍需用户决定的问题（如果有）。

默认不提交 Git，除非用户要求。

## 常见情况

**只给了官网 URL**：先读页面确认项目名和安装方式，再查 nixpkgs 与 brew。识别不了就问用户准确名称。

**nixpkgs attr 名不同**：用 `nix` MCP 搜索描述或项目名，把候选列给用户确认。

**nixpkgs 版本明显落后**：macOS 可以改用 cask；NixOS 继续用 nixpkgs，除非用户接受覆盖版本。

**需要 unfree**：`modules/common/nix.nix` 已开启 `allowUnfree`，直接声明即可。

**用户想手动 brew install**：提醒 `cleanup = "check"` 会在下次 switch 中止，长期使用的包必须写进 nix-config。

**两个平台都要但只有一个平台有包**：先说明缺口，再给方案：macOS 用 cask、Linux 用 nixpkgs 或反过来；需要统一开关时用 `my.apps`。

**用户没回答某个确认项**：不要继续后面的步骤，重复问那一项；确认文件位置之前不写文件。
