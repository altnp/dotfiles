if vim.g.vscode then
  vim.notify('Terminal mappings can not be loaded within vscode', 'warning')
  return
end

local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend('force', { silent = true }, opts or {}))
end

--  Windows & Buffers
map('n', '<S-M-h>', '<C-w>h', { desc = 'Focus next split left', remap = true })
map('n', '<S-M-j>', '<C-w>j', { desc = 'Focus split below', remap = true })
map('n', '<S-M-k>', '<C-w>k', { desc = 'Focus split above', remap = true })
map('n', '<S-M-l>', '<C-w>l', { desc = 'Focus next split right', remap = true })
map({ 'n' }, '<M-i>', '<C-o>', { desc = 'Back' })
map({ 'n' }, '<M-o>', '<C-i>', { desc = 'Forward' })

-- Escape
map({ 'i', 'c' }, 'jj', '<Esc>', { desc = 'Exit mode' })

-- Comments
map({ 'n', 'x' }, '<leader>/', 'gcc', { desc = 'Toggle line comment', remap = true })

-- Misc
map({ 'n' }, '<leader>.', ':luafile %<CR>', { desc = 'Exec current luafile' })

-- Misc
map('n', 'g<ESC>', ':nohl<CR>', { desc = 'Clear search' })

-- TODO:
-- Format
-- Block Comments
-- ...
