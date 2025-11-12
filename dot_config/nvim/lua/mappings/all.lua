local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend('force', { silent = true }, opts or {}))
end

-- Smart enter insert
-- NOTE: Feedkeys breaks macros so we have to do this goofy global function
vim.api.nvim_set_keymap('n', 'i', "v:lua.SmartInsert('i')", { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', 'a', "v:lua.SmartInsert('a')", { expr = true, noremap = true })

function _G.SmartInsert(key)
  if vim.fn.getline '.' == '' or vim.fn.getline('.'):match '^%s*$' then
    return '"_cc'
  else
    return key
  end
end

-- Movement
map({ 'n', 'x' }, 'j', 'gj', { desc = 'Move down', remap = true })
map({ 'n', 'x' }, 'k', 'gk', { desc = 'Move up', remap = true })
map({ 'n', 'x', 'o' }, 'H', '^', { desc = 'Move to start of line' })
map({ 'n', 'x', 'o' }, 'L', '$', { desc = 'Move to end of line' })
map({ 'n', 'x' }, 'J', '10gj', { desc = 'Move down 10 lines', remap = true })
map({ 'n', 'x' }, 'K', '10gk', { desc = 'Move up 10 lines', remap = true })

-- Windows
map('n', '|', '<C-w>v', { desc = 'Split window vertical', remap = true })
map('n', '\\', '<C-w>s', { desc = 'Split window horizontal', remap = true })

-- Editor
vim.keymap.set('n', '<leader><S-j>', 'J', { desc = 'Join Line' })

-- Undo
map('n', 'U', '<C-r>', { desc = 'Redo' })
map('n', 'u', 'u', { desc = 'Undo' })

-- Save
map({ 'n' }, '<C-s>', '<cmd>w<CR>')
map({ 'i' }, '<C-s>', '<cmd>w<CR><esc>')

-- Formatting
map('n', '<leader>=', '`[v`]=', { desc = 'Format last paste' })
map('x', '<Tab>', '>gv', { desc = 'Shift selection right', remap = true })
map('x', '<S-Tab>', '<gv', { desc = 'Shift selection left', remap = true })

-- Copy/Paste
map('x', 'p', '"_dP', { desc = 'Paste without overwrite' })

-- Visual Mode
map({ 'n' }, 'vv', 'v<S-l>h', { desc = 'Visual end of line', remap = true })
map({ 'n' }, '<leader>v', '<S-h>v<S-l>h', { desc = 'Visual current line', remap = true })

-- NoOp
map('n', 'Q', '<nop>', { desc = '' })
map({ 'n', 'x' }, '<C-q>', '<nop>', { desc = '' })
map({ 'x' }, '<C-i>', '<nop>', { desc = '' })
map({ 'x' }, '<C-o>', '<nop>', { desc = '' })
