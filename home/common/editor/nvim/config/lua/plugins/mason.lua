-- 工具由 Nix 提供；仅保留 nixpkgs 缺失的 codelldb 与 cmakelint，并关闭 LSP 自动安装。
return {
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "cmakelint",
      },
    },
  },
}
