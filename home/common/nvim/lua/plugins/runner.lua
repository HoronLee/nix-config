-- 快速运行代码
return {
  "CRAG666/code_runner.nvim",
  keys = {
    { "<leader>rr", ":RunCode<CR>", desc = "Run Code" },
    -- { "<leader>rf", ":RunFile<CR>", desc = "Run File" },
    -- { "<leader>rft", ":RunFile tab<CR>", desc = "Run File in Tab" },
    -- { "<leader>rp", ":RunProject<CR>", desc = "Run Project" },
    -- { "<leader>rc", ":RunClose<CR>", desc = "Close Runner" },
  },
  config = function()
    require("code_runner").setup({
      filetype = {
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        python = "uv run python -u",
        typescript = "deno run",
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "$dir/$fileNameWithoutExt",
        },
        c = function(...)
          local c_base = {
            "cd $dir &&",
            "gcc $fileName -o",
            "/tmp/$fileNameWithoutExt",
          }
          local c_exec = {
            "&& /tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          }
          vim.ui.input({ prompt = "Add more args:" }, function(input)
            c_base[4] = input
            vim.print(vim.tbl_extend("force", c_base, c_exec))
            require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
          end)
        end,
        go = function()
          local go_base = {
            "cd $dir &&",
            "go run $fileName",
          }
          vim.ui.input({ prompt = "Add more args:" }, function(input)
            if input and input ~= "" then
              table.insert(go_base, input)
            end
            require("code_runner.commands").run_from_fn(go_base)
          end)
        end,
        go_test = {
          "cd $dir &&",
          "go test -v ./...",
        },
        go_build = {
          "cd $dir &&",
          "go build -o /tmp/$fileNameWithoutExt $fileName &&",
          "/tmp/$fileNameWithoutExt &&",
          "rm /tmp/$fileNameWithoutExt",
        },

        node = function()
          local node_base = {
            "cd $dir &&",
            "node $fileName",
          }
          vim.ui.input({ prompt = "Add more args:" }, function(input)
            if input and input ~= "" then
              table.insert(node_base, input)
            end
            require("code_runner.commands").run_from_fn(node_base)
          end)
        end,
        node_debug = {
          "cd $dir &&",
          "node --inspect-brk $fileName",
        },
        node_env = function()
          local node_env_base = {
            "cd $dir &&",
          }
          vim.ui.input({ prompt = "Set NODE_ENV (e.g., development, production):" }, function(env)
            if env and env ~= "" then
              table.insert(node_env_base, "NODE_ENV=" .. env .. " node $fileName")
            else
              table.insert(node_env_base, "node $fileName")
            end
            require("code_runner.commands").run_from_fn(node_env_base)
          end)
        end,
        ts_node = {
          "cd $dir &&",
          "ts-node $fileName",
        },
      },
    })
  end,
}
