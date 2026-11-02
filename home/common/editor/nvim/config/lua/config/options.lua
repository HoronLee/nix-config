-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 使用 Snacks Picker，以便启用 Kitty Graphics Protocol 图片预览。
-- FzfLua 的图片预览默认回退到 chafa ASCII，不走 Snacks image。
vim.g.lazyvim_picker = "snacks"

-- 保存窗口和缓冲区的局部选项（包括 filetype），供会话恢复时重建高亮
vim.opt.sessionoptions:append("localoptions")

-- 将个人拼写词典放在配置目录内，便于随 Neovim 配置备份和版本管理。
local spell_dir = vim.fn.stdpath("config") .. "/spell"
vim.fn.mkdir(spell_dir, "p")
vim.opt.spellfile = spell_dir .. "/en.utf-8.add"

-- CJK 字符不参与拼写检查，同时保留当前英语词典设置。
if not vim.tbl_contains(vim.opt.spelllang:get(), "cjk") then
  vim.opt.spelllang:append("cjk")
end

-- GUI 专属设置独立维护；在终端 Neovim 中该模块无副作用。
require("config.neovide")

-- 通过系统类型来选择 nvim 的终端，在linux优先选择 fish ，如果没有则使用 zsh 或者 bash
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
elseif vim.fn.has("unix") == 1 then
  local shell = vim.fn.executable("fish") == 1 and "fish" or vim.fn.executable("zsh") == 1 and "zsh" or "bash"
  LazyVim.terminal.setup(shell)
end

-- 设置自动换行
vim.opt.wrap = true
vim.opt.linebreak = true

-- avante.nvim 推荐选项
-- 视图只能通过全局状态栏完全折叠
vim.opt.laststatus = 3
