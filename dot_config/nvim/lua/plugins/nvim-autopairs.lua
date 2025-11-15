return {
  'windwp/nvim-autopairs',
  event = 'VeryLazy',
  cond = not vim.g.vscode,
  opts = {
    map_c_w = true,
  },
  config = function(_, opts)
    require('nvim-autopairs').setup(opts)
  end,
}
