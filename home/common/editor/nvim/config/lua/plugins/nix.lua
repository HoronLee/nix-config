-- Nix 工具由 Home Manager 提供，其他语言继续使用 Mason。
-- 配置跟随自身所在仓库：从本文件真实路径向上查找 flake.nix，不依赖 cwd 或固定目录。
local function nix_string(value)
  -- Nix 字符串中 ${ 会触发插值，只做 JSON 转义并不够。
  value = value:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("%${", "\\${")
  return '"' .. value .. '"'
end

local function find_flake_root()
  local source = debug.getinfo(1, "S").source:gsub("^@", "")
  local file = source ~= "" and vim.fn.fnamemodify(source, ":p") or nil
  local real = file and vim.uv.fs_realpath(file)
  local dir = real and vim.fs.dirname(real) or vim.uv.fs_realpath(vim.fn.stdpath("config"))

  while dir do
    if vim.uv.fs_stat(dir .. "/flake.nix") then
      return dir
    end
    -- 到 Git 仓库根目录就停止，避免读取其他仓库的 flake。
    if vim.uv.fs_stat(dir .. "/.git") then
      return nil
    end
    local parent = vim.fs.dirname(dir)
    dir = parent ~= dir and parent or nil
  end
end

local nixd = {
  formatting = { command = { "nixfmt" } },
}

local flake_root = find_flake_root()
local configs = ({
  Darwin = "darwinConfigurations",
  Linux = "nixosConfigurations",
})[vim.uv.os_uname().sysname]
local host = (vim.uv.os_gethostname() or ""):match("^[^.]+")

-- 未找到配置仓库时使用 nixd 默认补全，不指定主机选项。
if flake_root and configs and host then
  local flake = nix_string(flake_root)
  local options = ("(builtins.getFlake %s).%s.%s.options"):format(flake, configs, nix_string(host))

  nixd.nixpkgs = {
    expr = ("import (builtins.getFlake %s).inputs.nixpkgs { system = builtins.currentSystem; }"):format(flake),
  }
  -- 主机不在 flake 中时显式得到空 attrset，而不是退而选择第一个主机。
  nixd.options = {
    [configs == "darwinConfigurations" and "darwin" or "nixos"] = { expr = options .. " or { }" },
    home_manager = {
      expr = ([[
let
  options = %s or { };
  getSubOptions = options.home-manager.users.type.getSubOptions or (_: { });
in
getSubOptions [ ]
]]):format(options),
    },
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
