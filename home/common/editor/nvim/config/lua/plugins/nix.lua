-- Nix 工具由 Home Manager 提供，其他语言继续使用 Mason。
local flake = "(builtins.getFlake " .. vim.json.encode(vim.fn.expand("~/projects/nix-config")) .. ")"
local nixd = {
  nixpkgs = {
    expr = "import " .. flake .. ".inputs.nixpkgs { system = builtins.currentSystem; }",
  },
  formatting = { command = { "nixfmt" } },
}

local options = flake .. ".nixosConfigurations.nixos-vm.options"
nixd.options = {
  nixos = { expr = options },
  home_manager = { expr = options .. ".home-manager.users.type.getSubOptions []" },
}

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
