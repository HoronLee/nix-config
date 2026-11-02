return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("catppuccin").load()
      end,
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  -- {
  --   "sainnhe/everforest",
  --   lazy = true,
  --   priority = 1000,
  --   config = function()
  --     -- 配置 Everforest 主题
  --     vim.g.everforest_enable_italic = true
  --     vim.cmd.colorscheme("everforest") -- 设置 Everforest 作为默认主题
  --   end,
  -- },
  -- {
  --   "morhetz/gruvbox",
  --   lazy = true, -- 延迟加载 Grubox，可以根据需要手动加载
  --   config = function()
  --     vim.cmd.colorscheme("gruvbox") -- 设置 Gruvbox 作为主题
  --   end,
  -- },
}
