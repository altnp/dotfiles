return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {
      keymaps = {
        insert = false,
        insert_line = false,
        normal = 's',
        normal_cur = false,
        normal_line = 'S',
        normal_cur_line = false,
        visual = 's',
        delete = 'ds',
        change = 'cs',
        change_line = false,
      },
    }
  end,
}
