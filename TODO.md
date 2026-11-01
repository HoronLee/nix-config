# TODO

- [ ] SSH 密钥：GitHub 上只有 CachyOS 本机的公钥，VM 里没有对应私钥，`git push` 报 `Permission denied (publickey)`。已临时把私钥 scp 进 VM 并推送成功；后续改用 Bitwarden（SSH Agent）统一管理密钥，不再把私钥复制到各台机器。
