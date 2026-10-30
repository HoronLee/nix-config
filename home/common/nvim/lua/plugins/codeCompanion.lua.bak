return {
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    config = true,
    keys = {
      { "<leader>a", ":CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "yuegle" },
        inline = { adapter = "yuegle" },
        agent = { adapter = "yuegle" },
      },
      adapters = {
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            name = "deepseek",
            env = {
              api_key = function()
                return os.getenv("DEEPSEEK_API_KEY")
              end,
            },
            schema = {
              model = {
                default = "deepseek-chat",
              },
            },
          })
        end,

        siliconflow = function()
          return require("codecompanion.adapters").extend("deepseek", {
            name = "siliconflow_r1",
            url = "https://api.siliconflow.cn/v1/chat/completions",
            env = {
              api_key = function()
                return os.getenv("DEEPSEEK_API_KEY_S")
              end,
            },
            schema = {
              model = {
                default = "deepseek-ai/DeepSeek-R1",
                choices = {
                  ["deepseek-ai/DeepSeek-R1"] = { opts = { can_reason = true } },
                  "deepseek-ai/DeepSeek-V3",
                },
              },
            },
          })
        end,

        yuegle = function()
          return require("codecompanion.adapters").extend("openai", {
            name = "yuegle",
            -- OpenAI 兼容的 API 端点通常是 /v1/chat/completions
            url = "https://api.yuegle.com/v1/chat/completions",
            env = {
              api_key = function()
                -- 建议将 API 密钥存储在环境变量中，而不是硬编码
                return os.getenv("YUEGLE_API_KEY")
              end,
            },
            schema = {
              model = {
                -- 设置一个默认模型
                default = "gpt-4o-2024-11-20",
                -- 提供所有可选的模型列表
                choices = {
                  "gpt-4o-2024-11-20",
                  "gpt-4.1",
                  "gpt-5-chat",
                },
              },
            },
          })
        end,
      },
      opts = {
        language = "Chinese",
        log_level = "warn",
      },
    },
  },
}
