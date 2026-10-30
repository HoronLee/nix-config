return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- 永远不要将此值设置为 "*"！永远不要！
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- mcphub集成
    system_prompt = function()
      local ok, mcphub = pcall(require, "mcphub")
      if not ok then
        return ""
      end

      local hub = mcphub.get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
      local ok, avante_ext = pcall(require, "mcphub.extensions.avante")
      if not ok then
        return {}
      end
      return {
        avante_ext.mcp_tool(),
      }
    end,
    -- 内建网络搜索工具
    web_search_engine = {
      provider = "tavily",
    },
    provider = "deepseek",
    providers = {
      deepseek = {
        __inherited_from = "openai",
        endpoint = "https://api.deepseek.com/v1",
        api_key_name = "DEEPSEEK_API_KEY",
        model = "deepseek-v4-flash",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 393216,
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- 以下依赖项是可选的，
    "nvim-mini/mini.pick", -- 用于文件选择器提供者 mini.pick
    "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
    "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
    "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
    {
      -- 支持图像粘贴
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- 推荐设置
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- Windows 用户必需
          use_absolute_path = true,
        },
      },
      keys = {
        { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
      },
    },
    {
      -- 如果您有 lazy=true，请确保正确设置
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
