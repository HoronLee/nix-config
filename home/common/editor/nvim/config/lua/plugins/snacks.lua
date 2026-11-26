return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- snacks.image 内置终端表仅含 kitty/ghostty/wezterm；
    -- Rex 支持 Kitty Graphics 与 Unicode placeholders (U=1)。
    -- 插在列表开头，保留后续 tmux/zellij/ssh 规则的覆盖优先级。
    table.insert(require("snacks.image.terminal").envs(), 1, {
      name = "rex",
      terminal = "rex",
      env = { TERM_PROGRAM = "^rex$" },
      supported = true,
      placeholders = true,
    })

    opts.image = {}

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
