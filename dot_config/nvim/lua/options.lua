local opt = vim.opt
local g = vim.g

vim.opt_local.number = true

opt.clipboard = 'unnamedplus'
opt.termguicolors = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.mouse = 'a'
opt.wrap = false
opt.whichwrap:append '<>[]hl'
opt.virtualedit = 'block'
opt.hlsearch = true
opt.joinspaces = false
-- opt.visualstar = true

-- Providers
g['loaded_node_provider'] = 0
g['loaded_python3_provider'] = 0
g['loaded_perl_provider'] = 0
g['loaded_ruby_provider'] = 0

if vim.g.vscode then
  local vscode = require 'vscode'
  vim.notify = vscode.notify
  opt.undofile = false -- vscode does not support undofile
end
