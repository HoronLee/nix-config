# Horon's NixOS 配置

仓库面向 NixOS 与未来的 nix-darwin，Home Manager 内嵌到对应系统配置，不提供其他 Linux 发行版的独立 HM 输出。当前提供 `nixos-vm`；实体机 `dell-t7810` 与 Mac `mbp-m2pro` 尚未提供配置。

## 在全新 NixOS 上使用

当前仅提供 NixOS VM 入口 `nixos-vm`：**x86_64、UEFI/systemd-boot**，使用 nixos-unstable、niri + Noctalia、greetd + tuigreet，以及 Fcitx5-Rime 万象标准全拼。版本由 `flake.lock` 固定。可从无桌面的 NixOS VM 安装起步，虚拟机需使用 Virtio 显卡并启用 3D/OpenGL。以后部署实体机时新增独立主机入口、复用共享模块，不把 VM 的硬件配置直接用于实体机。

### 1. 克隆到普通用户目录

在已联网、能使用 sudo 的普通用户终端执行；HTTPS 克隆不需要 GitHub SSH 密钥：

```sh
nix-shell -p git
mkdir -p ~/projects
git clone https://github.com/HoronLee/nix-config.git ~/projects/nix-config
cd ~/projects/nix-config
```

### 2. 替换目标主机硬件配置并核对个人信息

使用本次 NixOS 安装生成的文件，**不要沿用仓库中的 VM 磁盘 UUID**：

```sh
cp /etc/nixos/hardware-configuration.nix \
  hosts/x86_64-linux/nixos-vm/hardware-configuration.nix
```

应用前核对：

- `flake.nix` 的 `username` 与 `modules/nixos/user.nix` 的账户名：默认 `horonlee`，应与本次安装的普通用户一致。
- `modules/nixos/user.nix` 的 SSH 授权公钥：替换成自己的公钥，或移除不需要的公钥；私钥不要放进仓库。
- `home/common/git.nix` 的 Git 姓名和邮箱。
- `hosts/x86_64-linux/nixos-vm/default.nix` 的引导设置应匹配目标主机；配置声明的 hostname 与 flake 输出名统一为 `nixos-vm`。

当前两处 `stateVersion` 为 `26.05`，不要因切换 unstable 或套用配置随意修改已有系统的 `system.stateVersion` 或 `home.stateVersion`。若家目录已有同名应用配置，遇到 HM 文件冲突时先保留并整理原文件，不强制覆盖。

### 3. 应用配置

```sh
git add hosts/x86_64-linux/nixos-vm/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#nixos-vm \
  --option experimental-features 'nix-command flakes'
```

本配置会移除 Plasma/SDDM，换为文字登录界面；应用可能结束当前桌面会话，请先保存工作，建议从 SSH 或 TTY 操作，再重启进入新会话。默认登录 Shell 为 Fish；用户密码沿用已有账户，SSH 禁止 root 直接登录。

首次部署或重命名前，运行中的 hostname 可能仍是 `nixos`，必须使用上面的 `#nixos-vm` 显式选择目标。应用成功且 `hostname` 显示 `nixos-vm` 后，可在仓库内省略输出名：

```sh
sudo nixos-rebuild switch --flake .
```

`nixos-rebuild` 会按当前 hostname 选择同名 `nixosConfigurations`。若 `/etc/nixos/flake.nix` 已指向这个仓库（当前 VM 的 `/etc/nixos` 是仓库链接），还可直接运行 `sudo nixos-rebuild switch`；其他机器不要假设已存在该链接。普通 `nix build` 不使用这套主机名选择规则，仍需指定下面给出的完整输出属性。

重命名后用 `hostnamectl status` 区分 Static hostname 与 Transient hostname。`networking.hostName` 写入静态配置后，运行时名称仍可能保留旧值；重新登录 SSH 不会更新它。完整切换成功后可重启，或执行 `sudo hostnamectl --transient hostname nixos-vm` 仅更新当前运行时名称；静态配置继续由 NixOS 管理，不用 hostnamectl 改写只读的 `/etc/hostname`。

新增模块需先 `git add`，提交 `flake.lock`，不要每次套用时运行 `nix flake update`。日常编辑和 Git 操作不用 sudo。

配置仓库可以一直放在用户目录，不需要移动到 `/etc/nixos` 或建立链接。

## 目录与主机组织

```text
flake.nix                         # 系统输出与依赖
lib/mkNixosHost.nix                # NixOS 与内嵌 HM 的组合
hosts/x86_64-linux/nixos-vm/        # VM 系统入口、硬件与引导
modules/nixos/                    # 可复用的系统模块
home/
├── default.nix                   # 只导入通用用户配置
├── hosts/nixos-vm.nix             # 选择平台、桌面、Rime 和 SSH agent
├── desktops/
│   ├── niri-noctalia.nix          # Niri 与 Noctalia 的组合集成
│   └── niri-noctalia.kdl          # 组合专用的启动项和快捷键
├── common/                       # 共享用户配置，包含 CLI 和 GUI
│   ├── packages.nix              # 通用工具、开发工具与环境变量
│   ├── shell.nix                 # Fish、Bash、Starship
│   ├── neovim.nix                # Neovim 包与配置部署
│   ├── nvim/                     # 可写的原生 Lua 配置
│   └── terminals/                # Kitty、Ghostty
└── linux/                        # Linux 专用依赖及原生配置
    ├── default.nix               # 平台工具、Yazi 依赖、fontconfig
    ├── packages.nix              # Linux 桌面应用、诊断与硬件工具
    ├── niri/                     # KDL 与部署声明
    ├── noctalia/                 # TOML、壁纸部署
    └── rime/                     # Fcitx5-Rime 静态配置与模型部署
```

根 `hosts/` 组合系统配置，`home/hosts/` 组合用户配置。Linux 平台入口不自动选择桌面；VM 用户入口显式导入 Niri/Noctalia、Rime 和 SSH agent。`home/desktops/` 按组合方案组织，与共享内容、平台内容和主机入口平级；不使用目录扫描或自动匹配。

合成器与桌面 Shell 分别声明，组合模块负责两者的集成。Niri 用户模块只提供通用 KDL；`niri-noctalia.nix` 用 HM 的 `lib.mkAfter` 在主配置末尾追加 `include "./desktop-niri-noctalia.kdl"`，并部署组合专用片段。Niri 原生 include 合并不同文件的快捷键，后出现的同名快捷键会覆盖前者；当前两部分没有重复按键。以后添加其他组合时复用通用模块、单独声明启动项和专用快捷键，系统主机入口还需显式选择对应合成器的 NixOS 集成。

Yazi 本体由 `home/common/yazi.nix` 启用；`home/linux/yazi.nix` 只增加 `wl-clipboard`、`xclip`。未来 Darwin 入口可复用前者而不导入后者。common 表示共享职责，尚未逐项验证其全部软件在 ARM macOS 上的可用性。

只构建、不激活的检查入口：

```sh
nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.nixos-vm.config.home-manager.users.horonlee.home.activationPackage --no-link
```

## Nix 管理与存储维护

`modules/nixos/nix.nix` 集中管理 Nix 守护进程设置与 GC，主机模块显式导入；网络、区域与基础软件仍由 `base.nix` 管理。

- 自动 GC 每周执行，使用 `--delete-older-than 14d` 清理过期历史代次，再回收无引用的 store 对象。当前代次保留；已删除的历史代次无法回滚。定时器沿用 NixOS 的持久化默认值，错过任务后补执行。
- 启用 `nix-command`、`flakes`、`auto-allocate-uids`、`configurable-impure-env`。自动 UID 分配同时设置 `auto-allocate-uids = true`，NixOS 据此停用预创建的构建用户池。
- `configurable-impure-env` 允许按需配置固定输出构建的环境变量，未声明 `impure-env`，不添加代理、令牌或额外受信任用户。
- 启用 `auto-optimise-store`，新增 store 对象时将内容相同的文件合并为硬链接，不删除系统代次；现有 store 可按需手动运行 `sudo nix-store --optimise` 完整去重。
- 构建期间可用空间低于 5 GiB 时触发 GC，尝试回收到 10 GiB。只回收无引用对象，不删除受保护的历史代次；可回收对象不足时无法保证达到目标空间。
- `hosts/x86_64-linux/nixos-vm/default.nix` 将 systemd-boot 启动菜单限制为最近 10 个系统代次，控制启动分区文件数量；不单独删除 store 中的系统闭包。
- 二进制缓存保留清华镜像及 NixOS 默认官方缓存。

## 开发环境与 Neovim

- `home/common/packages.nix`：统一列出通用 CLI、语言、包管理器、语言服务与格式化、构建工具，并声明开发环境变量和用户 PATH。默认使用包集中最新正式系列，版本由 `flake.lock` 固定。
- `home/linux/packages.nix`：Linux 桌面应用、调试和硬件工具。Nautilus、Edge 由这里统一安装，不依赖某个合成器或桌面 Shell 组合。
- `home/common/nvim/`：原生 LazyVim 配置。Home Manager 将 `~/.config/nvim` 链接到 `~/projects/nix-config/home/common/nvim`，目录必须保持存在；Lua、Extras 和锁文件保持可写，通过 Git 同步。Nix generation 回滚不恢复这些可写文件。
- `programs.neovim.sideloadInitLua` 将 Home Manager 生成的初始化代码交给包装器加载，保留原生 `init.lua`。
- Nix LSP 使用 `nixd`，关闭 `nil_ls`，格式化使用 `nixfmt`；包补全读取本仓库锁定的 Nixpkgs，模块选项固定读取实际存在的 `nixos-vm` NixOS 与内嵌 Home Manager 定义，不按编辑器运行平台猜测。Darwin 接入后再添加对应主机选项集合。
- `tombi` 提供 TOML 格式化、lint 和 LSP；当前 Neovim TOML 语言服务仍保留 Mason 的 Taplo，未同时启用 Tombi LSP。
- 其他语言工具继续由 Mason 安装。安装成功后仍需验证实际启动；当前 Mason 下载的 StyLua 在 VM 中被 NixOS `stub-ld` 拦截，尚未适配。不关闭 TLS 校验，不以安装状态代替运行验证。

格式化不要求先 rebuild，可直接使用已构建工具；配置完成后统一构建，再执行 `sudo nixos-rebuild switch --flake .#nixos-vm`。格式化命令：

```sh
nixfmt $(git ls-files '*.nix')
tombi format $(git ls-files '*.toml')
tombi format --check $(git ls-files '*.toml')
```

## 桌面与输入法配置

- `modules/nixos/desktop.nix`：保留音频、打印与 Firefox；`niri.nix` 管 niri、greetd/tuigreet，portal 与 GNOME Keyring 复用 NixOS niri 模块。
- `home/linux/niri/config.kdl`：通用入口 include `cfg/` 中的 input、layout、rules、keybinds、misc，不启动或调用 Noctalia。HM 读取原生 KDL 作为可合并文本，最终配置与片段仍固定到 store，不使用可写的仓库外链接。
- `home/desktops/niri-noctalia.kdl`：部署为 `~/.config/niri/desktop-niri-noctalia.kdl`，启动 Noctalia，定义启动器、控制中心、锁屏、媒体、音量、亮度等专用快捷键，以及 Edge、Nautilus 在该组合中的启动键；这两个应用由 Linux 包清单统一安装。仅选择通用 Niri 模块时不会部署此文件。`~/.config/niri/noctalia.kdl` 保留给 Noctalia 自动生成配色，不由 HM 覆盖、备份替换或链接到 store。
- `home/linux/niri/cfg/rules.kdl`：通用窗口规则设置 `draw-border-with-background false`，只绘制焦点环和边框外圈，避免底色遮挡应用的透明背景；不强制应用透明，也无需逐个枚举终端。应用特例放在通用规则之后。
- `home/common/terminals/`：仅安装 Ghostty 和 Kitty，已移除 Alacritty 声明，`Super+T` 使用 Kitty。`ghostty.nix` 管字体、透明度、目录继承、标签/分窗快捷键及 90 ms 光标拖尾动画；模板选择由 Noctalia 管理，不在终端模块初始化生成主题。
- `nixos-vm` 使用 virgl 虚拟显卡。Ghostty 1.3.1 要求 OpenGL 4.3 或更新版本，虚拟显卡提供的 OpenGL 4.2 不满足要求；此限制与自定义 shader 无关。默认终端使用 Kitty，Ghostty 保留安装和动画设置，不配置软件渲染或版本覆盖。
- `home/linux/niri/default.nix`：Linux 的 Kitty 隐藏窗口装饰，其他应用与 macOS 不受影响；应用后需重新打开 Kitty。`home/linux/packages.nix` 安装 Edge 和 Nautilus，供不同 Linux 桌面共用，Firefox 暂保留。
- `home/linux/noctalia/config.toml`：声明 Polkit、Shell 字体、Dock、自动定位、日夜色温、自动亮暗与壁纸配色、模板名单和壁纸。白天色温为 6700 K，夜间沿用 4000 K；屏幕使用时间与遥测均启用。不显式声明 lockscreen_widgets.enabled，沿用当前版本的默认 false；该选项控制额外锁屏小组件，锁屏与登录框仍可使用。登录框使用程序默认布局，不保存 `Virtual-1` 专属坐标；未开启闲置自动锁屏/熄屏。
- `home/linux/noctalia/bar.toml`：左侧为启动器、壁纸、工作区和任务栏，中央为时钟，右侧包含媒体、托盘、剪贴板、通知、蓝牙、音量、控制中心、资源监控组和会话。CPU、内存、网络上下行共用不折叠的胶囊。
- 内置模板为 btop、Ghostty、Kitty、niri；社区模板为 Telegram、Zed、Fastfetch、Zellij、Fcitx5、FZF、Herdr、Lazygit。仅声明选择，不安装应用、不提交模板缓存或生成的主题；应用读取主题及只读配置兼容性按应用分别处理。
- `assets/wallpapers/nixos-1.png`：由 HM 链接到 `~/Pictures/Wallpapers/nixos-1.png`，图片由仓库提供。
- `modules/nixos/input-method.nix`：Fcitx5 Wayland frontend、keyboard-us + Rime、`Ctrl+Space` 切换。只安装万象中文方案，不包含日韩引擎。
- `home/linux/rime/*.custom.yaml`：标准全拼、en/eng 与 in/ing 模糊音、每页 6 候选。用户词库、学习数据和编译缓存保持应用可写，不入仓库。
- 万象模型由 `home/linux/rime/default.nix` 的 URL + SHA-256 固定，不提交大文件。上游 LTS 同名资产可能被覆盖；新下载校验失败时需审查模型更新，不能去掉 hash。首次输入可能需要等待 Rime 编译词典。
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

`Super+V` 设置了 `allow-inhibiting=false`，远程桌面等应用请求接管快捷键时仍可打开本地剪贴板；如需把该组合传给远端，再取消该属性。媒体键、截图和其他基线键位保持不变；`Alt+Tab` 继续使用 niri 内置最近窗口切换器。

`cfg/input.kdl` 启用鼠标焦点跟随及重复选择工作区时返回上一工作区。时钟格式为 `{:%Y年%-m月%-d日 %p %I:%M %A}`，星期与上午/下午取决于 `LC_TIME`，当前为中文；小时保留两位前导零。

### 修改与验证

在 Bash 中验证包含组合片段的生成配置；只校验 `home/linux/niri/config.kdl` 会遗漏组合专用行为：

```bash
home_generation="$(nix build .#nixosConfigurations.nixos-vm.config.home-manager.users.horonlee.home.activationPackage --no-link --print-out-paths)"
niri validate --config "$home_generation/home-files/.config/niri/config.kdl"
"$home_generation/home-path/bin/noctalia" config validate "$home_generation/home-files/.config/noctalia"
nixos-rebuild build --flake .#nixos-vm --no-link
```

修改仓库源文件后应用配置。Noctalia GUI 修改会热加载到 `~/.local/state/noctalia/settings.toml`，优先于声明层；使用 `noctalia config export` 导出到临时文件，审查敏感信息和机器专属值后整理回 TOML，再应用并处理重复覆盖值。HM 不会自动从 GUI 回写仓库。

新会话需人工验证登录、中文候选框、Wayland/X11 剪贴板、屏幕共享、声音、壁纸与锁屏解锁。构建/配置校验通过不代表这些交互已经验证。暂不安装 mark-shot 或额外剪贴板守护进程。
