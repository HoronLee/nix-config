# TODO

- [ ] 浅尝 sops-nix

- [x] 已向 `yetone/magpie` 报告 wrapper 路径问题：[#1747](https://github.com/yetone/magpie/issues/1747)。
  - [ ] 等 #1747 修复并进入 `sugar/magpie` 后，删除本地 `pkgs/magpie/exec-wrapper.patch` 与 `lib/mkNixosHost.nix` 里的 `overrideAttrs`。若上游只增加环境变量支持，先确认打包层已设置 `MAGPIE_EXECUTABLE` 再删。

- [ ] 修复 macOS 上 GitNexus / LadybugDB 对 Homebrew OpenSSL 路径的依赖（2026-11-09 发现，临时绕过已验证）。
  - **现象**：在 Plateau、Servora 仓库执行 `gitnexus analyze --index-only` 均在加载原生库阶段失败，尚未开始正常索引。GitNexus 版本为 `1.6.12`，其依赖 `@ladybugdb/core@0.18.3`；CLI 由 mise 的 `npm-gitnexus` 安装管理。
  - **报错**：`LadybugDB native binary (lbugjs.node) exists but failed to load`，具体为 `Library not loaded: /opt/homebrew/opt/openssl@3/lib/libssl.3.dylib`。
  - **原生库位置**：`/Users/horonlee/.local/share/mise/installs/npm-gitnexus/1.6.12/node_modules/.mise/@ladybugdb+core@0.18.3/node_modules/@ladybugdb/core/lbugjs.node`。
  - **已确认原因**：对上述文件执行 `otool -L`，其 Mach-O 依赖记录直接引用 `/opt/homebrew/opt/openssl@3/lib/libssl.3.dylib` 和 `/opt/homebrew/opt/openssl@3/lib/libcrypto.3.dylib`。本机发现的可用 OpenSSL 在 Nix store，例如 `/nix/store/hnzmpbl2qbi7rjhy3gx3apkhgdhi1lnp-openssl-3.6.5/lib`；库已存在，默认加载路径与预编译原生库的路径要求不一致。
  - **与 nix-config 的关系尚待确认**：现象符合迁移到 Nix 后缺少 Homebrew 路径的情况，但尚未核对迁移历史、Homebrew 清理记录或 nix-config 软件声明；不能断言 Nix switch 删除了 OpenSSL，也没有证据表明 Go 1.27.3 升级造成此问题。
  - **已验证的临时绕过**：仅对单次进程设置 `DYLD_LIBRARY_PATH`，直接用 Node 执行真实 GitNexus JavaScript 入口，避免经过 `/bin/sh` 包装层导致 `DYLD_*` 在 macOS 上被清理。以下命令在两个仓库根目录分别执行成功：

    ```sh
    DYLD_LIBRARY_PATH=/nix/store/hnzmpbl2qbi7rjhy3gx3apkhgdhi1lnp-openssl-3.6.5/lib \
      node /Users/horonlee/.local/share/mise/installs/npm-gitnexus/1.6.12/node_modules/.mise/gitnexus@1.6.12_graphology-types@0.24.8_zod@4.6.5/node_modules/gitnexus/dist/cli/index.js \
      analyze --index-only --workers 4
    ```

  - **绕过结果**：Servora 索引成功（8,125 nodes / 20,806 edges / 287 flows），Plateau 索引成功（27,635 nodes / 63,568 edges / 332 flows）。索引器另有候选数量和流程枚举裁剪警告，那些属于图分析覆盖限制，不能据此认定不存在调用；与动态库加载失败分开处理。
  - **另一项已纠正的调用错误**：`node .../node_modules/.bin/gitnexus` 会报 `SyntaxError`，因为该入口是 `#!/bin/sh` 的 `aube-bin-shim v2`，不是 JavaScript。读取包装脚本后找到上面的真实 `dist/cli/index.js` 路径。此错误来自排查时的调用方式，不能归因于 Nix。
  - **临时方案限制**：上述 Nix store 哈希和 mise 包路径绑定当前安装，更新或垃圾回收后可能失效。没有修改全局环境变量、shell 配置或动态库，没有伪造 `/opt/homebrew` 符号链接，没有安装 Homebrew OpenSSL，也没有重新编译 LadybugDB；普通 `gitnexus` 入口的永久修复仍未完成。
  - **后续处理**：先确认 GitNexus/mise 的现有声明归属及当前 macOS OpenSSL 配置，再选择可重现的 Nix wrapper/原生包重建方案，或在确有必要时声明 Homebrew `openssl@3`。不要直接全局设置 `DYLD_LIBRARY_PATH`，也不要把当前 store 哈希写成长期配置。按 `nix-add-software` 指导，确认平台、管理层和具体文件后再修改配置；未经要求不执行 switch。
  - **完成标准**：新 shell 中无需手写临时环境变量，普通 `gitnexus` 入口能加载 LadybugDB，并能实际完成索引和 impact 查询；相关 Nix 配置求值通过，且安装更新后不依赖易失效的绝对 store 哈希。验证后再勾选此项。
