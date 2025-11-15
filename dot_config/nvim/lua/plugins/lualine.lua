return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cond = not vim.g.vscode,
  lazy = false,
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}
