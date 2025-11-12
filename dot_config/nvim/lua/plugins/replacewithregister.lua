return {
  'vim-scripts/ReplaceWithRegister',
  keys = {
    { '<leader>r', mode = 'n', desc = 'Replace with register' },
    { '<leader>r', mode = 'x', desc = 'Replace with register' },
  },
  config = function()
    vim.keymap.set('n', '<leader>r', '<Plug>ReplaceWithRegisterOperator', { silent = true, desc = 'Replace with register' })
    vim.keymap.set('x', '<leader>r', '<Plug>ReplaceWithRegisterVisual', { silent = true, desc = 'Replace with register' })
  end,
}
