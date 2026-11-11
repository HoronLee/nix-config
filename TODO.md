# TODO

- [ ] 浅尝 sops-nix

- [ ] `darwin-rust-deps`：跟踪 `NixOS/nixpkgs`，对应 `modules/darwin/default.nix` 的 `TODO(darwin-rust-deps)`。修复须进入 `nixos-unstable` 并被 `flake.lock` 锁定，再逐项移除本地覆盖；仅合入 `master` 不足以移除。
  - [ ] `cargo-bundle`：补齐 `aws-lc` 和 `pkg-config`；[修复 PR #584581](https://github.com/NixOS/nixpkgs/pull/584581) 已于 2026-11-07 合入 `master`，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ca/cargo-bundle/package.nix)。Zed 依赖它。
  - [ ] `viddy`：补齐 `sqlite`；`master` 已有声明，复查 [nixos-unstable 打包文件](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/vi/viddy/package.nix)。
  - [ ] 确认渠道包含修复后执行 `just update nixpkgs`，移除对应覆盖及注释，构建 `cargo-bundle`、`viddy` 和完整 Darwin 系统，通过后再 `switch`。

- [ ] `yetone/magpie` [#1747](https://github.com/yetone/magpie/issues/1747) 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。
