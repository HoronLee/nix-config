# Horon's NixOS 配置

## 在全新 NixOS 上使用

当前仅提供 `horon-vm`：**x86_64、UEFI/systemd-boot**，使用 nixos-unstable、niri + Noctalia、greetd + tuigreet，以及 Fcitx5-Rime 万象标准全拼。版本由 `flake.lock` 固定。可从无桌面的 NixOS 安装起步，物理机和 macOS 的独立配置尚未提供。虚拟机需使用 Virtio 显卡并启用 3D/OpenGL。

### 1. 克隆到普通用户目录

在已联网、能使用 sudo 的普通用户终端执行；HTTPS 克隆不需要 GitHub SSH 密钥：

```sh
nix-shell -p git
mkdir -p ~/projects
git clone https://github.com/HoronLee/nix-config.git ~/projects/nix-config
cd ~/projects/nix-config
```

### 2. 替换本机硬件配置并核对个人信息

使用本次 NixOS 安装生成的文件，**不要沿用仓库中的 VM 磁盘 UUID**：

```sh
cp /etc/nixos/hardware-configuration.nix \
  hosts/x86_64-linux/horon-vm/hardware-configuration.nix
```

应用前核对：

- `flake.nix` 的 `username` 与 `modules/nixos/user.nix` 的账户名：默认 `horonlee`，应与本次安装的普通用户一致。
- `modules/nixos/user.nix` 的 SSH 授权公钥：替换成自己的公钥，或移除不需要的公钥；私钥不要放进仓库。
- `home/common/git.nix` 的 Git 姓名和邮箱。
- `hosts/x86_64-linux/horon-vm/default.nix` 的引导设置应匹配本机；实际 hostname 默认是 `nixos`，配置入口仍叫 `horon-vm`。

当前两处 `stateVersion` 为 `26.05`，不要因切换 unstable 或套用配置随意修改已有系统的 `system.stateVersion` 或 `home.stateVersion`。若家目录已有同名应用配置，遇到 HM 文件冲突时先保留并整理原文件，不强制覆盖。

### 3. 应用配置

```sh
git add hosts/x86_64-linux/horon-vm/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#horon-vm \
  --option experimental-features 'nix-command flakes'
```

本配置会移除 Plasma/SDDM，换为文字登录界面；应用可能结束当前桌面会话，请先保存工作，建议从 SSH 或 TTY 操作，再重启进入新会话。默认登录 Shell 为 Fish；用户密码沿用已有账户，SSH 禁止 root 直接登录。

以后修改配置后，在仓库内执行：

```sh
sudo nixos-rebuild switch --flake .#horon-vm
```

新增模块需先 `git add`，提交 `flake.lock`，不要每次套用时运行 `nix flake update`。日常编辑和 Git 操作不用 sudo。

配置仓库可以一直放在用户目录，不需要移动到 `/etc/nixos` 或建立链接。

## 桌面与输入法配置

- `modules/nixos/desktop.nix`：保留音频、打印与 Firefox；`niri.nix` 管 niri、greetd/tuigreet，portal 与 GNOME Keyring 复用 NixOS niri 模块。
- `home/linux/niri/config.kdl`：主入口仅 include `cfg/` 中的 input、layout、autostart、rules、keybinds、misc；HM 部署整棵配置树并固定到 store，不使用可写的仓库外链接。窗口操作沿用基线，仅调整明确选择的键位与输入习惯。
- `home/linux/niri/cfg/rules.kdl`：通用窗口规则设置 `draw-border-with-background false`，只绘制焦点环和边框外圈，避免底色遮挡应用的透明背景；不强制应用透明，也无需逐个枚举终端。应用特例放在通用规则之后。
- `home/common/terminals/`：仅安装 Ghostty 和 Kitty，已移除 Alacritty 声明，`Super+T` 使用 Kitty。`ghostty.nix` 管字体、透明度、目录继承、标签/分窗快捷键及 90 ms 光标拖尾动画。不声明 Noctalia 终端模板、不初始化主题文件。
- 当前 `horon-vm` 的 virgl 最高提供 OpenGL 4.2，低于 Ghostty 1.3.1 所需的 4.3；退出发生在 shader 编译之前，因此保留 shader 和动画设置。Ghostty 保持安装供后续使用，不加入软件渲染或版本伪装设置。
- `home/linux/niri/default.nix`：Linux 的 Kitty 隐藏窗口装饰，其他应用与 macOS 不受影响；应用后需重新打开 Kitty。`home/linux/packages.nix` 安装 Edge 和 Nautilus，供快捷键直接调用，Firefox 暂保留。
- `home/linux/noctalia/config.toml`：启用内置 Polkit agent、指定壁纸和中央中文时钟。锁屏跟随桌面壁纸，保留默认模糊与遮罩。未开启闲置自动锁屏/熄屏，保留 Noctalia 默认睡前锁屏。
- `assets/wallpapers/nixos-1.png`：由 HM 链接到 `~/Pictures/Wallpapers/nixos-1.png`，不依赖原机器的图片目录。
- `modules/nixos/input-method.nix`：Fcitx5 Wayland frontend、keyboard-us + Rime、`Ctrl+Space` 切换。只安装万象中文方案，不包含日韩引擎。
- `home/linux/rime/*.custom.yaml`：标准全拼、en/eng 与 in/ing 模糊音、每页 6 候选。用户词库、学习数据和编译缓存保持应用可写，不入仓库。
- 万象模型由 `home/linux/rime/default.nix` 的 URL + SHA-256 固定，不提交大文件。上游 LTS 同名资产可能被覆盖；新下载校验失败时需审查模型更新，不能去掉 hash。首次输入可能需要等待 Rime 编译词典。

### 常用快捷键

| 按键 | 动作 |
|---|---|
| `Super+T` | Kitty |
| `Alt+Space` | Noctalia 启动器（原 `Super+D` 已注释） |
| `Super+V` | 剪贴板历史 |
| `Super+Shift+V` | 切换窗口浮动 |
| `Super+Ctrl+V` | 切换平铺/浮动焦点 |
| `Super+Alt+L` | 锁屏 |
| `Super+Shift+,` | Noctalia 设置 |
| `Super+Tab` | 当前与最近工作区切换 |
| `Super+S` | 控制中心 |
| `Super+Shift+Q` | 会话菜单 |
| `Super+Shift+Enter` | 壁纸选择器 |
| `Super+B` | Microsoft Edge |
| `Super+E` | Nautilus 文件管理器 |
| `Super+Shift+/` | 快捷键帮助 |
| `Super+Q` | 关闭窗口 |
| `Ctrl+Alt+Delete` | 退出 niri（原 `Super+Shift+E` 已注释） |
| `Print` | niri 内置截图 |

`Super+V` 设置了 `allow-inhibiting=false`，远程桌面等应用请求接管快捷键时仍可打开本地剪贴板；如需把该组合传给远端，再取消该属性。媒体键、截图和其他基线键位保持不变；`Alt+Tab` 继续使用 niri 内置最近窗口切换器。

`cfg/input.kdl` 启用鼠标焦点跟随及重复选择工作区时返回上一工作区。时钟格式为 `{:%Y年%-m月%-d日 %p %I:%M %A}`，星期与上午/下午取决于 `LC_TIME`，当前为中文；小时保留两位前导零。

### 修改与验证

```sh
niri validate --config home/linux/niri/config.kdl
noctalia config validate home/linux/noctalia/config.toml
nixos-rebuild build --flake .#horon-vm --no-link
```

修改仓库源文件后应用配置。Noctalia GUI 修改会热加载到 `~/.local/state/noctalia/settings.toml`，优先于声明层；使用 `noctalia config export` 导出到临时文件，审查敏感信息和机器专属值后整理回 TOML，再应用并处理重复覆盖值。HM 不会自动从 GUI 回写仓库。

新会话需人工验证登录、中文候选框、Wayland/X11 剪贴板、屏幕共享、声音、壁纸与锁屏解锁。构建/配置校验通过不代表这些交互已经验证。暂不安装 mark-shot 或额外剪贴板守护进程。
