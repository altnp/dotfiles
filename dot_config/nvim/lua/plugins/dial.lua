return {
  'monaqa/dial.nvim',
  event = 'VeryLazy',
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
      },
    }

    local map = vim.keymap.set
    map('n', '<C-a>', function()
      return require('dial.map').manipulate('increment', 'normal')
    end, { desc = 'Increment' })
    map('n', '<C-x>', function()
      return require('dial.map').manipulate('decrement', 'normal')
    end, { desc = 'Decrement' })
    map('n', 'g<C-a>', function()
      return require('dial.map').manipulate('increment', 'gnormal')
    end, { desc = 'Increment' })
    map('n', 'g<C-x>', function()
      return require('dial.map').manipulate('decrement', 'gnormal')
    end, { desc = 'Decrement' })

    map('x', '<C-a>', function()
      return require('dial.map').manipulate('increment', 'visual')
    end, { desc = 'Increment' })
    map('x', '<C-x>', function()
      return require('dial.map').manipulate('decrement', 'visual')
    end, { desc = 'Decrement' })
    map('x', 'g<C-a>', function()
      return require('dial.map').manipulate('increment', 'gvisual')
    end, { desc = 'Increment' })
    map('x', 'g<C-x>', function()
      return require('dial.map').manipulate('decrement', 'gvisual')
    end, { desc = 'Decrement' })
  end,
}
