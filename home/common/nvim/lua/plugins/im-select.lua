return {
  "HoronLee/im-select.nvim",
  main = "im_select",
  lazy = false,
  -- MacOS 暂时使用鼠须管的 vim_mode: true 替代使用
  cond = vim.fn.has("macunix") == 0,
  opts = {},
}
