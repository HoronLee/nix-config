# TODO

- [ ] 浅尝 sops-nix

- [ ] `yetone/magpie` [#1747](https://github.com/yetone/magpie/issues/1747) 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。
