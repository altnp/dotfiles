if not vim.g.vscode then
  vim.notify('VSCode mappings can not be loaded within terminal', 'warning')
  return
end

local vscode = require 'vscode'

local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend('force', { silent = true }, opts or {}))
end

-- Windows & buffers
map('n', '<leader>n', function()
  vscode.call 'workbench.action.files.newUntitledFile'
end, { desc = 'New File' })

-- Navigation
map('n', ']g', function()
  vscode.call 'editor.action.dirtydiff.next'
end)
map('n', '[g', function()
  vscode.call 'editor.action.dirtydiff.next'
end)
map('n', '[d', function()
  vscode.call 'editor.action.marker.prev'
end)
map('n', ']d', function()
  vscode.call 'editor.action.marker.next'
end)

-- Editor
map({ 'n' }, '<leader>gl', function()
  vscode.call 'workbench.action.editor.changeLanguageMode'
end)

-- Comments
map({ 'n', 'x' }, '<leader>/', function()
  vscode.action 'editor.action.commentLine'
end, { desc = 'Toggle line comment', remap = true })
map({ 'x' }, 'gbc', function()
  vscode.action 'editor.action.blockComment'
end, { desc = 'Toggle block comment' })

-- LSP-style navigation
map('n', 'gd', function()
  vscode.call 'editor.action.revealDefinition'
end)
map('n', 'gD', function()
  vscode.call 'editor.action.revealDeclaration'
end)
map('n', 'gi', function()
  vscode.call 'editor.action.goToImplementation'
end)
map('n', 'gr', function()
  vscode.call 'editor.action.goToReferences'
end)
map('n', 'gt', function()
  vscode.call 'editor.action.goToTypeDefinition'
end)
map('n', 'gpd', function()
  vscode.call 'editor.action.peekDefinition'
end)
map('n', 'gpD', function()
  vscode.call 'editor.action.peekDeclaration'
end)
map('n', 'gpi', function()
  vscode.call 'editor.action.peekImplementation'
end)
map('n', 'gpt', function()
  vscode.call 'editor.action.peekTypeDefinition'
end)

-- Views
map('n', '<leader>e', function()
  vscode.call 'workbench.files.action.focusFilesExplorer'
end)

-- Git
map('n', '<leader>gb', function()
  vscode.call('toggle', {
    args = {
      id = 'gitBlame',
      value = {
        { ['git.blame.editorDecoration.enabled'] = true },
        { ['git.blame.editorDecoration.enabled'] = false },
      },
    },
  })
end)
map('n', '<leader>gs', function()
  vscode.call 'git.stageSelectedRanges'
end)
map('n', '<leader>gxx', function()
  vscode.call 'git.revertSelectedRanges'
end)

-- Refactor
map('n', '<leader>ru', function()
  vscode.call 'editor.action.organizeImports'
end, { desc = 'Organize Import' })
map('n', '<leader>rr', function()
  vscode.call 'editor.action.rename'
end, { desc = 'Rename' })
map('n', '<leader>rn', function()
  vscode.call 'csharpstretch.fixNamespace'
end, { desc = 'Rename' })
map('n', '<leader>rf', function()
  vscode.call 'editor.renameFileSmart'
end, { desc = 'Rename' })
map('n', '<leader>rF', function()
  vscode.call 'editor.renameFile'
end, { desc = 'Rename' })

-- Debugging
map('n', '<leader>bb', function()
  vscode.call 'editor.debug.action.toggleBreakpoint'
end)
map('n', '<leader>B', function()
  vscode.call 'editor.debug.action.conditionalBreakpoint'
end)
map('n', '<leader>bl', function()
  vscode.call 'editor.debug.action.addLogPoint'
end)
map('n', '<leader>bx', function()
  vscode.call 'workbench.debug.viewlet.action.removeAllBreakpoints'
end)
map('n', '<leader>dw', function()
  vscode.call 'editor.debug.action.selectionToWatch'
end)

-- Formatting
map('n', '<leader>fm', function()
  vscode.action 'editor.action.formatDocument'
end, { desc = 'Format document' })
map('n', '<leader>fM', function()
  vscode.action 'editor.action.formatDocument.multiple'
end, { desc = 'Format document' })
map('x', '<leader>fm', function()
  vscode.action 'editor.action.formatSelection'
end, { desc = 'Format selection' })
map('x', '<leader>fM', function()
  vscode.action 'editor.action.formatDocument.multiple'
end, { desc = 'Format selection' })

-- Folding
map('n', 'z<CR>', function()
  vscode.call 'editor.toggleFold'
end)
map('n', 'zo', function()
  vscode.call 'editor.unfoldAll'
end)
map('n', 'zm', function()
  vscode.call 'editor.foldAll'
end)

-- Testing
map('n', '<leader>tr', function()
  vscode.action 'testing.runAtCursor'
end)
map('n', '<leader>tR', function()
  vscode.action 'testing.runAll'
end)
map('n', '<leader>td', function()
  vscode.action 'testing.debugAtCursor'
end)
map('n', '<leader>tD', function()
  vscode.action 'testing.debugAll'
end)

-- Quick Pallets
map('n', '<leader>ff', function()
  vscode.action 'workbench.action.quickOpen'
end, { desc = 'Find files' })
map('n', '<leader>fs', function()
  vscode.action 'workbench.action.gotoSymbol'
end, { desc = 'Find symbol' })
map('n', '<leader>fg', function()
  vscode.action 'workbench.action.quickTextSearch'
end, { desc = 'Find in files' })
map('n', '<leader>:', function()
  vscode.action 'workbench.action.showCommands'
end)

-- Emmet
map({ 'n', 'x' }, '<leader>%', function()
  vscode.call 'editor.emmet.action.matchTag'
end, { desc = 'Move to matching tag', remap = true })
map({ 'n', 'x' }, '<leader>s', function()
  vscode.call 'editor.emmet.action.wrapWithAbbreviation'
end, { desc = 'Emmet wrap', remap = true })

-- Agents
map({ 'n', 'x' }, '<leader>c', function()
  vscode.action 'inlineChat.start'
end)

-- Notebooks
map({ 'n' }, 'DD', function()
  vscode.action 'notebook.cell.delete'
end)
map({ 'n' }, '<leader>nr', function()
  vscode.action 'notebook.execute'
end)
map({ 'n' }, '<leader>nx', function()
  vscode.action 'jupyter.restartkernel'
end)

-- Misc
map('n', 'g<Esc>', function()
  vim.cmd.nohlsearch()
  vscode.action 'closeQuickDiff'
  vscode.action 'closeFindWidget'
  vscode.action 'closeMarkersNavigation'
end, { desc = 'Clear highlights and search UI' })

map({ 'n' }, '<leader>gr', function()
  vim.notify 'Refreshing editor'
  vscode.call 'typescript.restartTsServer'
  vscode.call 'eslint.restart'
  vscode.call 'eslint.revalidate'
  vim.defer_fn(function()
    vscode.call 'vscode-neovim.restart'
  end, 100)
end)
map({ 'n' }, '<leader>gR', function()
  vscode.call 'workbench.action.reloadWindow'
end)

-- NoOp
vim.api.nvim_del_keymap('x', 'mi')
vim.api.nvim_del_keymap('x', 'mI')
vim.api.nvim_del_keymap('x', 'ma')
vim.api.nvim_del_keymap('x', 'mA')
