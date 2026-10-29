# Horon's NixOS 配置

## 在全新 NixOS 上使用

当前仅提供 `horon-vm`：**x86_64、UEFI/systemd-boot**，应用后使用 nixos-unstable 和 Plasma 6，具体版本由 `flake.lock` 固定。物理机和 macOS 的独立配置尚未提供。

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

完成后注销并重新登录。默认登录 Shell 为 Fish；用户密码沿用已有账户，SSH 禁止 root 直接登录。

以后修改配置后，在仓库内执行：

```sh
sudo nixos-rebuild switch --flake .#horon-vm
```

新增模块需先 `git add`，提交 `flake.lock`，不要每次套用时运行 `nix flake update`。日常编辑和 Git 操作不用 sudo。

配置仓库可以一直放在用户目录，不需要移动到 `/etc/nixos` 或建立链接。
