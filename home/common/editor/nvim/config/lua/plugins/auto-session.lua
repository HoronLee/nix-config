return {
  {
    "rmagatti/auto-session",
    lazy = false,

    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
      { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
      -- { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      session_lens = {
        -- picker = "snacks",
        -- picker = "select",
        -- picker = "snacks",
        picker = "fzf",
      },
    },
  },
  -- 禁用folke/snacks.nvim内置的persistence插件，使用auto-session
  {
    "folke/persistence.nvim",
    enabled = false,
  },
}
