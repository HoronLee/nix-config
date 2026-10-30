return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    -- Only one of these is needed.
    "dlyongemallo/diffview-plus.nvim", -- optional
    -- For a custom log pager
    "m00qek/baleia.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
  },
}
