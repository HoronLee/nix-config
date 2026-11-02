return {
  "folke/snacks.nvim",
  opts = function(_, opts)
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
