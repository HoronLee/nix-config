-- zellij pane切换插件
-- 需要https://github.com/fresh2dev/zellij-autolock作为前置
return {
  "https://github.com/fresh2dev/zellij.vim",
  -- Pin version to avoid breaking changes.
  -- tag = '0.3.*',
  lazy = false,
  -- 不在 zellij 内（$ZELLIJ 未设置）时，插件完全不加载：不定义命令、不设映射
  cond = function()
    return vim.env.ZELLIJ ~= nil
  end,
  init = function()
    -- Options:
    -- vim.g.zelli_navigator_move_focus_or_tab = 1
    -- vim.g.zellij_navigator_no_default_mappings = 1
  end,
}
