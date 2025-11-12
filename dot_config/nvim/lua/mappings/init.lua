require 'mappings.all'

if vim.g.vscode then
  require 'mappings.vscode'
else
  require 'mappings.terminal'
end
