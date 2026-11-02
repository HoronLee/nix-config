# TODO

- [ ] SSH 密钥：GitHub 上只有 CachyOS 本机的公钥，VM 里没有对应私钥，`git push` 报 `Permission denied (publickey)`。已临时把私钥 scp 进 VM 并推送成功；后续改用 Bitwarden（SSH Agent）统一管理密钥，不再把私钥复制到各台机器。

- [ ] 浅尝 sops-nix

- [x] 已向 `yetone/magpie` 报告 wrapper 路径问题：[#1747](https://github.com/yetone/magpie/issues/1747)。
  - [ ] 等 #1747 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。
