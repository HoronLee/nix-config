return {
  "ChmaraX/herdr-nvim",
  lazy = false,
  -- 仅在 Herdr 中加载；普通终端保留安装，但不注册命令和快捷键。
  cond = function()
    return vim.env.HERDR_ENV == "1"
  end,
  opts = {
    prefix = "<leader>h",
    keymaps = true,
    clear_after_send = true,
  },
}
