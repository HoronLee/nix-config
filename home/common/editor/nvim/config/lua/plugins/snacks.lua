return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- ```mermaid 由 mmdc 渲染；实际二进制来自 mise 的 mermaid-rs-renderer（rename_exe = "mmdc"）。
    -- mmdr 不吃 mmdc 的 -b/-s，用它自己的参数集。
    opts.image = {
      -- 浮窗渲染，不依赖终端 U=1 unicode placeholder。
      -- max_width/max_height 同时限制图像格子数和浮窗宽度（默认 80x40 太小，图会被压糊）。
      doc = {
        inline = false,
        max_width = vim.o.columns,
        max_height = vim.o.lines,
      },
      convert = {
        mermaid = function()
          local theme = vim.o.background == "light" and "neutral" or "dark"
          return { "-i", "{src}", "-o", "{file}", "-e", "png", "-t", theme }
        end,
      },
    }
    opts.dashboard.preset.header = [[
██╗  ██╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██║  ██║██╔═══██╗██╔══██╗██╔═══██╗████╗  ██║██║   ██║██║████╗ ████║
███████║██║   ██║██████╔╝██║   ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
██╔══██║██║   ██║██╔══██╗██║   ██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║  ██║╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
    opts.dashboard.sections = opts.dashboard.sections
      or {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      }

    table.insert(opts.dashboard.sections, math.max(1, #opts.dashboard.sections), {
      icon = " ",
      title = "Recent Projects",
      section = "projects",
      indent = 2,
      padding = 1,
      limit = 6,
    })
  end,
}
