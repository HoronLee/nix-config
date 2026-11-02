return {
  "Bekaboo/dropbar.nvim",
  lazy = false, -- 插件内部已有延迟加载
  keys = {
    {
      "<leader>;",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Pick Breadcrumb",
    },
  },
}
