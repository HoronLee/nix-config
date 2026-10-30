if not vim.g.neovide then
  return
end

-- 浮窗与补全菜单保持轻微透明；0 为不透明，100 为完全透明。
vim.o.guifont = "Maple Mono NF CN:h12"
vim.o.winblend = 85
vim.o.pumblend = 85
vim.g.neovide_opacity = 1.0
vim.g.neovide_normal_opacity = 1

vim.g.neovide_window_blurred = true
vim.g.neovide_show_border = true
vim.g.neovide_theme = "auto"
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_remember_window_size = true
vim.g.neovide_profiler = false
