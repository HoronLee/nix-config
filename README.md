# Horon's NixOS 配置

仓库通过 Nix Flakes 组合系统配置和内嵌 Home Manager 用户环境。当前输出为 `nixos-vm`；各主机通过独立入口复用共享模块。

## 在全新 NixOS 上使用

`nixos-vm` 使用 **x86_64、UEFI/systemd-boot**、nixos-unstable、Niri + Noctalia、greetd + Noctalia Greeter，以及 Fcitx5-Rime 万象标准全拼。软件来自 Nixpkgs，应用主题使用 Catppuccin，依赖版本统一由 `flake.lock` 固定。虚拟机需使用 Virtio 显卡并启用 3D/OpenGL。部署实体机时，为目标主机创建独立入口并导入该机生成的硬件配置。

### 1. 克隆到普通用户目录

在已联网、能使用 sudo 的普通用户终端通过 HTTPS 克隆：

```sh
nix-shell -p git
mkdir -p ~/projects
git clone https://github.com/HoronLee/nix-config.git ~/projects/nix-config
cd ~/projects/nix-config
```

### 2. 替换目标主机硬件配置并核对个人信息

**磁盘 UUID、挂载和硬件信息必须来自目标主机。**使用本次 NixOS 安装生成的文件：

```sh
cp /etc/nixos/hardware-configuration.nix \
  hosts/x86_64-linux/nixos-vm/hardware-configuration.nix
```

应用前核对：

- `flake.nix` 的 `username` 与 `modules/nixos/user.nix` 的账户名：默认 `horonlee`，应与本次安装的普通用户一致。
- `modules/nixos/user.nix` 的 SSH 授权公钥：设置为自己的公钥；私钥由用户自行保管在仓库之外。
- `home/common/git.nix` 的 Git 姓名和邮箱。
- `hosts/x86_64-linux/nixos-vm/default.nix` 的引导设置应匹配目标主机；配置声明的 hostname 与 flake 输出名统一为 `nixos-vm`。

仓库的 `system.stateVersion` 和 `home.stateVersion` 均为 `26.05`。接入已有系统时沿用该系统原有的值。家目录已有同名应用配置时，先备份并整理文件归属，再应用 HM 配置。

### 3. 应用配置

```sh
git add hosts/x86_64-linux/nixos-vm/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#nixos-vm \
  --option experimental-features 'nix-command flakes'
```

图形登录使用 Noctalia Greeter，进入 Niri 会话。更换登录配置时，先保存工作，从 SSH 或 TTY 执行 `sudo nixos-rebuild boot --flake .#nixos-vm`，成功后重启加载登录器。默认登录 Shell 为 Fish；用户密码沿用已有账户，SSH 使用普通用户登录。

应用配置时使用 `#nixos-vm` 显式选择目标。当 `hostname` 输出为 `nixos-vm` 时，也可在仓库内使用以下简写：

```sh
sudo nixos-rebuild switch --flake .
```

`nixos-rebuild` 会按当前 hostname 选择同名 `nixosConfigurations`。通过 `/etc/nixos` 使用仓库时，先确认 `/etc/nixos/flake.nix` 指向此仓库，再运行 `sudo nixos-rebuild switch`。普通 `nix build` 使用下文给出的完整输出属性。

用 `hostnamectl status` 查看 Static hostname 与 Transient hostname。静态名称由 `networking.hostName` 管理；运行时名称可在应用后通过重启更新，也可执行 `sudo hostnamectl --transient hostname nixos-vm` 更新当前会话。

新增模块需先 `git add`，依赖变更需提交 `flake.lock`。需要升级依赖时执行 `nix flake update`，日常配置编辑使用现有锁定版本。编辑和 Git 操作由普通用户执行，系统部署命令使用 sudo。

仓库推荐放在 `~/projects/nix-config`，应用命令通过 `--flake` 指定路径。

## 目录与主机组织

```text
flake.nix                         # 系统输出与依赖
lib/mkNixosHost.nix                # NixOS 与内嵌 HM 的组合
hosts/x86_64-linux/nixos-vm/        # VM 系统入口、硬件与引导
modules/nixos/                    # 可复用的系统模块
home/
├── default.nix                   # 只导入通用用户配置
├── hosts/nixos-vm.nix             # 选择平台、桌面、Rime 和 SSH agent
├── common/                       # 共享用户配置，包含 CLI 和 GUI
│   ├── agents/                   # OMP 配置与 Magpie 安装
│   ├── packages.nix              # 通用工具、开发工具与环境变量
│   ├── theme.nix                 # 共享 Catppuccin 策略
│   ├── btop.nix                  # btop 配置
│   ├── eza.nix                   # eza 与默认 Shell 集成
│   ├── fzf.nix                   # fzf 与默认快捷键集成
│   ├── shell.nix                 # Fish、Bash、Starship
│   ├── neovim.nix                # Neovim 包与配置部署
│   ├── nvim/                     # 可写的原生 Lua 配置
│   └── terminals/                # Kitty、Ghostty
└── linux/                        # Linux 专用依赖及原生配置
    ├── default.nix               # 平台工具、Yazi 依赖、fontconfig
    ├── packages.nix              # Linux 桌面应用、诊断与硬件工具
    ├── desktops/
    │   ├── niri-noctalia.nix      # Niri 与 Noctalia 的组合集成
    │   └── niri-noctalia.kdl      # 组合专用的启动项和快捷键
    ├── niri/                     # KDL 与部署声明
    ├── noctalia/                 # TOML、壁纸部署
    └── rime/                     # Fcitx5-Rime 静态配置与模型部署
```

根 `hosts/` 组合系统配置，`home/hosts/` 组合用户配置。Linux 平台入口负责平台依赖，VM 用户入口显式导入 Niri/Noctalia、Rime 和 SSH agent。`home/linux/desktops/` 按 Linux 桌面组合组织，由主机入口显式导入；共享应用配置保留在 `home/common/`。

合成器与桌面 Shell 分别声明，组合模块负责两者的集成。Niri 用户模块提供通用 KDL；`niri-noctalia.nix` 用 HM 的 `lib.mkAfter` 在主配置末尾追加 `include "./desktop-niri-noctalia.kdl"`，并部署组合专用片段。Niri 原生 include 合并各文件的快捷键，后出现的同名快捷键优先。添加桌面组合时，复用通用模块、声明对应启动项和快捷键，并在系统主机入口选择合成器的 NixOS 集成。

Yazi 本体由 `home/common/yazi.nix` 启用；`home/linux/yazi.nix` 增加 `wl-clipboard`、`xclip`。common 按共享职责组织；接入 Darwin 时复用共享模块，并逐项验证软件在 ARM macOS 上的支持情况。

构建检查入口：

```sh
nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.nixos-vm.config.home-manager.users.horonlee.home.activationPackage --no-link
```

## Nix 管理与存储维护

`modules/nixos/nix.nix` 集中管理 Nix 守护进程设置与 GC，主机模块显式导入；网络、区域与基础软件由 `base.nix` 管理。

- 自动 GC 每周执行，使用 `--delete-older-than 14d` 清理过期历史代次，再回收无引用的 store 对象。删除历史代次会缩小可回滚范围；当前代次持续受保护。定时器采用持久化设置，错过任务后补执行。
- 启用 `nix-command`、`flakes`、`auto-allocate-uids`、`configurable-impure-env`。自动 UID 分配同时设置 `auto-allocate-uids = true`，NixOS 据此停用预创建的构建用户池。
- 启用 `auto-optimise-store`，新增 store 对象时将内容相同的文件合并为硬链接；现有 store 可按需运行 `sudo nix-store --optimise` 完整去重。
- 构建期间可用空间低于 5 GiB 时触发 GC，目标为回收到 10 GiB，实际回收量取决于可用的无引用对象。系统代次及其他 GC roots 保护其引用的闭包。
- `hosts/x86_64-linux/nixos-vm/default.nix` 将 systemd-boot 启动菜单限制为最近 10 个系统代次；store 闭包由 Nix GC 管理。
- 二进制缓存使用清华镜像及 NixOS 官方缓存。

## 开发环境与 Neovim

- `home/common/packages.nix`：声明共享 CLI、Edge、pciutils、usbutils、语言、包管理器、语言服务与格式化、构建工具，以及开发环境变量和用户 PATH。btop、eza、fzf 使用对应 HM 程序模块，其余软件列在包清单中，版本由 `flake.lock` 固定。
- `home/linux/packages.nix`：Nautilus、iotop、strace、ltrace、sysstat、lm_sensors、ethtool 等 Linux 专用软件。
- `home/common/nvim/`：原生 LazyVim 配置。Home Manager 将 `~/.config/nvim` 链接到 `~/projects/nix-config/home/common/nvim`，目录必须保持存在。Lua、Extras 和锁文件保持可写，其历史版本通过 Git 管理；系统代次通过 Nix 管理。
- `programs.neovim.sideloadInitLua` 将 Home Manager 的初始化代码交给包装器加载，原生 `init.lua` 负责 LazyVim 启动。
- Nix LSP 使用 `nixd`，格式化使用 `nixfmt`；包补全读取本仓库锁定的 Nixpkgs，模块选项读取 `nixos-vm` 的 NixOS 与内嵌 Home Manager 定义。接入其他主机时添加对应选项集合。
- `tombi` 提供 TOML 格式化、lint 和 LSP 能力；Neovim 的 TOML 语言服务使用 Mason 管理的 Taplo。
- 其他语言工具由 Mason 安装，安装后需验证实际启动。Mason 下载的 StyLua 当前会触发 NixOS `stub-ld` 错误，使用前需处理其动态链接器兼容性。工具下载采用 TLS 校验。

格式化可直接使用已构建的工具。配置编辑完成后统一构建，再执行 `sudo nixos-rebuild switch --flake .#nixos-vm` 应用。格式化命令：

```sh
nixfmt $(git ls-files '*.nix')
tombi format $(git ls-files '*.toml')
tombi format --check $(git ls-files '*.toml')
```

## AI Agent 相关

`home/common/agents/` 按工具组织用户配置与安装检查。

### Magpie

- `flake.nix` 引入 `sugar/magpie` flake，把上游源码固定到具体版本并用 nixpkgs 的 `buildGoModule` 构建；`lib/mkNixosHost.nix` 通过 `extraSpecialArgs` 把 `magpie-app` 传给 Home Manager。
- `home/common/agents/magpie.nix` 在 Linux 上安装该包。桌面入口由包内 `makeDesktopItem` 生成，可执行文件为 `magpie-app`。
- 包内包装器设置 `MAGPIE_BUN` 指向 nixpkgs 的 bun，并默认令 `WEBKIT_DISABLE_COMPOSITING_MODE=0`：上游在 Wayland 下会关闭 WebKitGTK 的 GPU 合成，这一项维持开启。如需关闭，导出 `WEBKIT_DISABLE_COMPOSITING_MODE=1`。
- `modules/nixos/nix.nix` 增加 `magpie.cachix.org` 及其公钥，构建产物可直接从缓存获取。`cache.asnk.io` 未提供公钥，Nix 无法验签，因此未启用。
- 客户端由 Nix 固定版本，不参与应用内自更新；升级时执行 `nix flake update magpie` 并重新构建。`~/.config/magpie` 中的设置与账户数据仍由应用自身管理。
- 该 flake 只提供 `x86_64-linux` 与 `aarch64-linux` 包。macOS 不在其支持范围内，仍使用官方安装器手动安装，并保留应用内自更新。
- `modules/nixos/base.nix` 仍启用 `programs.nix-ld`，供其他预编译二进制（如 Mason 下载的工具）使用，与 Magpie 无关。

### OMP

- `home/common/agents/omp.nix` 启用 OMP 并声明用户配置。
- `flake.nix` 引入 OMP 官方 flake，版本由 `flake.lock` 固定，安装与更新通过 Nix 构建和配置激活管理。
- OMP 模块使用 `stdenv.hostPlatform` 配置 Bun 的构建依赖，保留锁定版本与上游下载校验信息。
- 首次构建包含 Rust 原生组件与 Bun 依赖；相同输入可复用已有构建产物。

## 桌面与输入法配置

- `modules/nixos/desktop.nix`：配置音频、打印与 Firefox。
- `modules/nixos/niri.nix`：启用 Niri 系统会话及 NixOS 模块提供的 portal、GNOME Keyring 集成；登录器由 `greeter.nix` 管理。
- `modules/nixos/greeter.nix`：启用 Nixpkgs 的 Noctalia Greeter 模块，使用 greetd 认证、内置外观和用户/会话选择。登录通过账户密码认证，状态目录由 NixOS 模块准备。
- `home/linux/niri/config.kdl`：通用入口 include `cfg/` 中的 input、layout、rules、keybinds、misc。HM 读取原生 KDL 作为可合并文本，最终配置与片段部署到 store。
- `home/linux/desktops/niri-noctalia.kdl`：部署为 `~/.config/niri/desktop-niri-noctalia.kdl`，定义 Noctalia 启动项及启动器、控制中心、锁屏、媒体、音量、亮度等专用快捷键，以及 Edge、Nautilus 的启动键。应用安装分别由 common、Linux 包清单负责。
- `home/linux/desktops/niri-noctalia.nix`：组合 Niri 与 Noctalia，并追加桌面专用 KDL。Noctalia 由 `spawn-at-startup` 启动；Niri 焦点环和边框使用原生 KDL 中的 Catppuccin Mocha 颜色。
- `home/linux/niri/cfg/rules.kdl`：`draw-border-with-background false` 让焦点环和边框只绘制外圈，应用透明度由各应用自身设置控制。应用特例放在通用规则之后。
- `home/common/terminals/`：声明 Kitty 和 Ghostty，`Super+T` 使用 Kitty。`ghostty.nix` 管理字体、透明度、目录继承、标签/分窗快捷键及 90 ms 光标拖尾动画；终端主题由各自的 HM 模块声明。
- `nixos-vm` 使用 virgl 虚拟显卡，提供 OpenGL 4.2；Ghostty 图形界面要求 OpenGL 4.3 或更新版本，因此 VM 使用 Kitty 作为默认终端。Ghostty 的配置和动画设置由共享终端模块管理。
- `home/common/terminals/kitty.nix`：在共享配置中为 Linux 与 macOS 统一隐藏 Kitty 的系统标题栏和窗口装饰；应用配置后重新启动 Kitty。Edge 由共享包清单安装，Nautilus 由 Linux 包清单安装，Firefox 由系统桌面模块安装。
- `home/linux/noctalia/config.toml`：声明 Polkit、Shell 字体、Dock、自动定位、日夜色温、Catppuccin 自动亮暗与壁纸。白天色温为 6700 K，夜间为 4000 K；屏幕使用时间与遥测均启用。额外锁屏小组件采用程序默认的关闭状态，登录框采用默认布局；锁屏由快捷键触发。
- `home/linux/noctalia/bar.toml`：左侧为启动器、壁纸、工作区和任务栏，中央为时钟，右侧包含媒体、托盘、剪贴板、通知、蓝牙、音量、控制中心、资源监控组和会话。CPU、内存、网络上下行共用常驻胶囊。
- `home/common/theme.nix`：通过官方 `catppuccin/nix` HM 模块管理共享默认值与自动端口策略，默认配色为 Mocha，强调色为 Pink。支持原生亮暗主题的应用由各自模块配置 Latte/Mocha。
- Kitty 使用 `autoThemeFiles`，亮色为 Latte、暗色和无偏好为 Mocha；Ghostty 使用原生 `light:catppuccin-latte,dark:catppuccin-mocha`，主题文件来自锁定的 Catppuccin 输入。Noctalia 根据日出日落同步系统颜色偏好，终端通过 Linux Settings portal 响应这一偏好；macOS 接入后需验证真机效果。主题声明修改后，通过构建并应用新代次生效。
- Fish 在 `shell.nix` 中选择含 `[light]`、`[dark]`、`[unknown]` 变体的 Catppuccin 主题；Yazi 在 `yazi.nix` 中选择 Latte/Mocha Flavor；Lazygit 在 `git.nix` 中使用 `colorScheme = auto` 与原生 `lightTheme`、`darkTheme`。这些主题资源来自锁定的 Catppuccin 输入，应用根据终端亮暗选择配色。LazyVim 的 Latte/Mocha 选择由原生 Lua 配置负责。
- `home/common/shell.nix` 统一配置 Fish、Bash、Starship。Starship 保留默认提示符与 ANSI 样式，负责目录、Git、语言环境等提示信息；Fish 的 Catppuccin 主题负责命令输入区域着色。常用 ANSI 颜色由终端调色板呈现。
- btop、eza、fzf 由各自的 HM 程序模块安装，并通过官方主题端口使用固定 Mocha；程序主题中的 RGB 颜色按指定值显示。eza 使用默认 Shell 别名，fzf 使用默认快捷键集成；btop 关闭退出时保存配置，保留 HM 管理的配置文件。
- Noctalia 的应用模板功能关闭。它自己的 `config.toml` 与 `bar.toml` 通过 `mkOutOfStoreSymlink` 指向 `~/projects/nix-config/home/linux/noctalia/`，编辑后可热加载；移动仓库时需同步修改链接声明。其余 Nix 配置变更通过构建并应用新代次生效。
- `assets/wallpapers/nixos-1.png`：由 HM 链接到 `~/Pictures/Wallpapers/nixos-1.png`，图片由仓库提供。
- `modules/nixos/input-method.nix`：配置 Fcitx5 Wayland frontend、keyboard-us + Rime、`Ctrl+Space` 切换及万象中文方案。
- `home/linux/rime/*.custom.yaml`：标准全拼、en/eng 与 in/ing 模糊音、每页 6 候选。用户词库、学习数据和编译缓存存放在应用可写目录中。
- 万象模型由 `home/linux/rime/default.nix` 的 URL + SHA-256 固定，构建时下载。上游 LTS 同名资产可能被替换，校验失败时需核对上游内容并同步更新 hash。首次输入可能需要等待 Rime 编译词典。
- 当前 Rime 用户模块部署到 `fcitx5/rime/`，由 VM 入口单独选择。Mac 的鼠须管＋万象适配待真实机器验证后进行；届时核对方案版本和补丁，再提取可共享静态资源，平台前端、部署目录与运行时数据分别管理。

### 常用快捷键

| 按键                | 动作                                   |
| ------------------- | -------------------------------------- |
| `Super+T`           | Kitty                                  |
| `Alt+Space`         | Noctalia 启动器（原 `Super+D` 已注释） |
| `Super+V`           | 剪贴板历史                             |
| `Super+Shift+V`     | 切换窗口浮动                           |
| `Super+Ctrl+V`      | 切换平铺/浮动焦点                      |
| `Super+Alt+L`       | 锁屏                                   |
| `Super+Shift+,`     | Noctalia 设置                          |
| `Super+Tab`         | 当前与最近工作区切换                   |
| `Super+S`           | 控制中心                               |
| `Super+Shift+Q`     | 会话菜单                               |
| `Super+Shift+Enter` | 壁纸选择器                             |
| `Super+B`           | Microsoft Edge                         |
| `Super+E`           | Nautilus 文件管理器                    |
| `Super+Shift+/`     | 快捷键帮助                             |
| `Super+Q`           | 关闭窗口                               |
| `Ctrl+Alt+Delete`   | 退出 niri（原 `Super+Shift+E` 已注释） |
| `Print`             | niri 内置截图                          |

`Super+V` 设置了 `allow-inhibiting=false`，远程桌面等应用请求接管快捷键时仍可打开本地剪贴板；如需把该组合传给远端，可取消该属性。`Alt+Tab` 使用 Niri 内置最近窗口切换器。

`cfg/input.kdl` 启用鼠标焦点跟随及重复选择工作区时返回上一工作区。时钟格式为 `{:%Y年%-m月%-d日 %p %I:%M %A}`，星期与上午/下午由中文 `LC_TIME` 决定，小时显示两位数字。

### 修改与验证

在 Bash 中构建并校验生成的配置：

```bash
system_generation="$(nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel --no-link --print-out-paths)"
home_generation="$(nix build .#nixosConfigurations.nixos-vm.config.home-manager.users.horonlee.home.activationPackage --no-link --print-out-paths)"
"$system_generation/sw/bin/niri" validate --config "$home_generation/home-files/.config/niri/config.kdl"
"$home_generation/home-path/bin/noctalia" config validate "$home_generation/home-files/.config/noctalia"
```

Noctalia GUI 将设置写入 `~/.local/state/noctalia/settings.toml`，其优先级高于配置目录中的 TOML。可使用 `noctalia config export` 导出合并结果，审查敏感信息和机器专属值后整理回仓库。选择以仓库主题为准时，先备份状态文件，再移除其中 `[theme]` 及其子表的覆盖项，其他 GUI 设置照常使用。首次应用 HM 配置前，还需检查并备份现有的 `~/.config/btop/btop.conf`，再将该路径交给 HM 管理。

构建和配置校验完成后，需在实际会话中验证图形登录、中文候选框、Wayland/X11 剪贴板、屏幕共享、声音、主题亮暗切换、壁纸与锁屏解锁。