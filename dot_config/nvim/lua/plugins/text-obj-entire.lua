return {
  'kana/vim-textobj-entire',
  keys = {
    { '<leader>a', 'v<Plug>(textobj-entire-a)', mode = 'n', desc = 'Select Entire' },
  },
  event = 'VeryLazy',
  dependencies = {
    'kana/vim-textobj-user',
  },
}
