-- goctl 支持插件
return {
  {
    "BYT0723/goctl.nvim",
    build = ":GoctlUpgrade", -- 相当于 run 选项，指定插件的安装或升级命令
    dependencies = { -- 相当于 requires 选项，指定插件依赖
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "rcarriga/nvim-notify", -- 推荐插件
    lazy = true, -- 设为 lazy 加载
    event = "VeryLazy", -- 触发加载的事件，可以根据需求修改
  },
}
