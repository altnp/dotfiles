return {
  'Mofiqul/vscode.nvim',
  lazy = false,
  priority = 1000,
  cond = not vim.g.vscode,
  config = function()
    local vscode = require 'vscode'
    vscode.setup {
      transparent = true,
      color_overrides = {},

      group_overrides = {
        StatusLine = { bg = 'none' },
      },
    }
    vscode.load()
  end,
}
