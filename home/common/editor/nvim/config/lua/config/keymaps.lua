-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 项目列表：<leader>fp 使用 Snacks picker
vim.keymap.set("n", "<leader>fp", function()
  Snacks.picker.projects()
end, {
  desc = "Projects",
})

-- 已保存会话：<leader>fs 打开 AutoSession 会话搜索
-- vim.keymap.set("n", "<leader>fs", "<cmd>AutoSession search<cr>", {
--   desc = "Find Sessions",
-- })

-- zellij pane 无界导航：覆盖 LazyVim 默认的 <C-w>hjkl 窗口跳转
-- 仅在 zellij 内启用（否则 ZellijNavigate* 命令不存在，会报 "Not an editor command"）
if vim.env.ZELLIJ then
  vim.keymap.set("n", "<C-h>", "<cmd>ZellijNavigateLeft<CR>", { desc = "Navigate left (Zellij)" })
  vim.keymap.set("n", "<C-j>", "<cmd>ZellijNavigateDown<CR>", { desc = "Navigate down (Zellij)" })
  vim.keymap.set("n", "<C-k>", "<cmd>ZellijNavigateUp<CR>", { desc = "Navigate up (Zellij)" })
  vim.keymap.set("n", "<C-l>", "<cmd>ZellijNavigateRight<CR>", { desc = "Navigate right (Zellij)" })
end

-- 使用 zed 类似的按键启用 Hunk Inline
vim.keymap.set("n", "<C-'>", function()
  require("gitsigns").preview_hunk_inline()
end, {
  desc = "Preview Git Hunk Inline",
})
