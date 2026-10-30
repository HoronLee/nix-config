-- 在 nvim 中打开 nvim 直接调用现有 nvim 实例
return {
  "willothy/flatten.nvim",
  config = true,
  -- or pass configuration with
  -- opts = {  }
  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
}
