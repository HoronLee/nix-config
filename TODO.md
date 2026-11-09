# TODO

- [ ] 浅尝 sops-nix

- [ ] 确认以下 Darwin 构建问题已在 `nixos-unstable` 修复，再执行 `just update nixpkgs`。
  - [ ] `cargo-bundle`：缺少 `aws-lc` 和 `pkg-config`。
  - [ ] `codex`：缺少 `aws-lc`。
  - [ ] `viddy`：缺少 `sqlite` 和 `pkg-config`。
  - [ ] 更新后构建上述包、Zed 和完整 Darwin 系统，通过后再 `switch`。

- [ ] nixpkgs 原版 `antigravity-cli` ≥ 1.5.3 且验证通过后，删除 `home/common/agents/agy.nix` 的临时覆盖及注释，恢复直接安装 `pkgs.antigravity-cli`。
  - [ ] 确认 Darwin / Linux 支持未变，移除覆盖后重新求值各主机并构建 Darwin 系统。

- [x] 已向 `yetone/magpie` 报告 wrapper 路径问题：[#1747](https://github.com/yetone/magpie/issues/1747)。
  - [ ] 等 #1747 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。
