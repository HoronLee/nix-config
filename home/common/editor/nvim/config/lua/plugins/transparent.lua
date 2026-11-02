-- 透明化
return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    -- Neovide 使用自身的窗口合成；清空高亮会使浮窗和选中项失去背景层次。
    cond = function()
      return not vim.g.neovide
    end,
    config = function()
      require("transparent").setup({
        exclude_groups = {
          -- 保留主 UI 的层次和可读性
          "StatusLine",
          "StatusLineNC",
          "CursorLine",

          -- 若以后主题为这些组设置背景，也不要被透明插件抹掉
          "LineNr",
          "CursorLineNr",
          "SignColumn",

          -- 仅当你保留 clear_prefix(\"Avante\") 时才有意义
          "AvanteTitle",
          "AvanteReversedTitle",
          "AvanteSubtitle",
          "AvanteReversedSubtitle",
          "AvanteThirdTitle",
          "AvanteReversedThirdTitle",
          -- 保留 Snacks Explorer 当前选择项的背景
          "SnacksPickerListCursorLine",
        },
      })
      require("transparent").clear_prefix("BufferLine")
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("Snacks")
      -- 故意不清 lualine：保留底部 NORMAL / 分支 / 路径的背景层次
      -- require("transparent").clear_prefix("lualine")
      require("transparent").clear_prefix("Avante")
    end,
  },
}
