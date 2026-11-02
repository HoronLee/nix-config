-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Ensure diagnostic configuration is set for each attached LSP

-- 确保在LSP 配置完成之前关闭virtual_text
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = false, -- Disable virtual text
    })
  end,
})

-- 解决ArchLinux WSL环境下无法和windows互通剪切板的问题
if vim.fn.executable("win32yank.exe") == 1 then
  vim.opt.clipboard:append({ "unnamedplus" })
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

-- 自定义窗口的高度和宽度
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local winid = vim.api.nvim_get_current_win()
    local pos = vim.fn.win_screenpos(winid)
    -- snacks_terminal 底部窗口，高度设置
    if ft == "snacks_terminal" then
      -- 屏幕底部二分之一
      if pos[1] > vim.o.lines / 2 then
        vim.api.nvim_win_set_height(winid, 15) -- 设置你想要的高度
      end
    end
    -- codecompanion 右侧窗口，宽度设置
    if ft == "codecompanion" then
      if pos[2] > vim.o.columns / 2 then
        vim.api.nvim_win_set_width(winid, 70) -- 设置你想要的宽度
      end
    end
  end,
})

-- macOS下，使用Hammerspoon实现按下Esc时，切换到系统的输入法
-- 以下是Hammerspoon的配置，放在~/.hammerspoon/init.lua中
-- hs.urlevent.bind("toenim", function()
-- 	hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
-- 	print("toenim called, now:", hs.keycodes.currentSourceID())
-- end)
-- vim脚本
-- vim.api.nvim_create_autocmd({ "VimEnter", "VimLeavePre", "InsertLeave", "FocusGained", "TermLeave" }, {
--   callback = function()
--     vim.system({ "open", "-g", "hammerspoon://toenim" })
--   end,
-- })
