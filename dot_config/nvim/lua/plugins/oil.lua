return {
  'stevearc/oil.nvim',
  cond = not vim.g.vscode,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  opts = {
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-l>'] = false,
    },
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    { '<leader>e', '<cmd>Oil<CR>', desc = 'Open Oil' },
  },
  config = function(_, opts)
    require('oil').setup(opts)
  end,
}
