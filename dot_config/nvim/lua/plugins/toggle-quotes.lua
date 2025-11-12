return {
  'paul-louyot/toggle-quotes.nvim',
  event = { 'BufReadPost', 'InsertEnter' },
  keys = {
    {
      '"',
      function()
        require('toggle-quotes').toggle_quotes()
      end,
      mode = { 'n', 'v' },
      desc = 'Toggle quotes on line',
    },
  },
}
