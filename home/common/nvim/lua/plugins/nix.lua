-- Nix 工具由 Home Manager 提供，其他语言继续使用 Mason。
local flake = "(builtins.getFlake " .. vim.json.encode(vim.fn.expand("~/projects/nix-config")) .. ")"
local nixd = {
  nixpkgs = {
    expr = "import " .. flake .. ".inputs.nixpkgs { system = builtins.currentSystem; }",
  },
  formatting = { command = { "nixfmt" } },
}

-- 当前仅有 horon-vm 输出；Darwin 主机接入后再添加其模块选项集合。
if vim.fn.has("linux") == 1 then
  local options = flake .. ".nixosConfigurations.horon-vm.options"
  nixd.options = {
    nixos = { expr = options },
    home_manager = { expr = options .. ".home-manager.users.type.getSubOptions []" },
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nix" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = { enabled = false },
        nixd = { mason = false, settings = { nixd = nixd } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { nix = { "nixfmt" } },
    },
  },
}
