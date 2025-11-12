return {
  'gbprod/cutlass.nvim',
  event = 'VeryLazy',
  config = function()
    require('cutlass').setup {
      cut_key = 'm',
      override_del = true,
    }
  end,
}
