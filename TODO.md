# TODO

- [ ] 浅尝 sops-nix

- [ ] `darwin-rust-deps`：跟踪 `NixOS/nixpkgs`，对应 `modules/darwin/default.nix` 的 `TODO(darwin-rust-deps)`。修复须进入 `nixos-unstable` 并被 `flake.lock` 锁定，再逐项移除本地覆盖；仅合入 `master` 不足以移除。
  - [x] 当前临时修补已完成 Darwin 系统构建和 `switch`（2026-11-10）。
  - [ ] `cargo-bundle`：补齐 `aws-lc` 和 `pkg-config`；[修复 PR #584581](https://github.com/NixOS/nixpkgs/pull/584581) 已于 2026-11-07 合入 `master`，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ca/cargo-bundle/package.nix)。
  - [ ] `codex`：补齐 `aws-lc`、`oniguruma`、`sqlite` 和 `zstd`；`master` 已有声明，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/codex/package.nix)。
  - [ ] `omp`：补齐 `oniguruma` 和 `zstd`；`master` 已有声明，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/om/omp/package.nix)。
  - [ ] `viddy`：补齐 `sqlite`；`master` 已有声明，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/vi/viddy/package.nix)。
  - [ ] 确认渠道包含修复后执行 `just update nixpkgs`，移除对应覆盖及注释，构建上述原版包、Zed 和完整 Darwin 系统，通过后再 `switch`。

- [ ] 修复 OMP 在 Darwin `fixupPhase` 中的 `patchelf: command not found`：调用来自 nixpkgs 的 `pkgs/build-support/setup-hooks/audit-tmpdir.sh`，对应 ELF 的临时路径审计未正常执行。修正打包依赖或多余 ELF 文件后确认审计通过，不通过全局安装或关闭审计规避。

- [x] 已向 `yetone/magpie` 报告 wrapper 路径问题：[#1747](https://github.com/yetone/magpie/issues/1747)。
  - [ ] 等 #1747 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。
