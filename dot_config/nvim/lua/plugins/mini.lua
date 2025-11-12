return {
  {
    'echasnovski/mini.move',
    -- cond = not vim.g.vscode,
    keys = {
      { '<M-k>', mode = 'n', desc = 'Move line up' },
      { '<M-j>', mode = 'n', desc = 'Move line down' },
      { '<M-k>', mode = 'x', desc = 'Move selection up' },
      { '<M-j>', mode = 'x', desc = 'Move selection down' },
    },
    opts = {
      mappings = {
        up = '<M-k>',
        down = '<M-j>',
        left = '',
        right = '',
        line_down = '<M-j>',
        line_up = '<M-k>',
        line_left = '',
        line_right = '',
      },
    },
  },
  {
    'echasnovski/mini.splitjoin',
    keys = {
      { '<leader>j', mode = 'n', desc = 'Split / Join' },
      { '<leader>j', mode = 'x', desc = 'Split / Join' },
    },
    opts = {
      mappings = {
        toggle = '<leader>j',
      },
    },
  },
}
