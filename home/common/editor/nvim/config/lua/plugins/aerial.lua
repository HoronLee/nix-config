return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "proto" } },
  },
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts)
      opts.backends = {
        ["_"] = { "lsp", "treesitter", "markdown", "man" },
        proto = { "treesitter", "lsp" },
      }
    end,
  },
}
