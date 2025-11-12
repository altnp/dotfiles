return {
  'Mofiqul/vscode.nvim',
  lazy = false,
  priority = 1000,
  cond = not vim.g.vscode,
  config = function()
    local vscode = require 'vscode'
    vscode.setup { transparent = true }
    vscode.load()
  end,
}
