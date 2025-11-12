local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('TextYankPost', {
  group = augroup('HighlightYank', { clear = true }),
  desc = 'Highlight yanked text',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Yank',
      timeout = 100,
    }
  end,
})

autocmd('FileType', {
  group = augroup('Options', { clear = true }),
  callback = function()
    vim.opt.formatoptions:remove 'o'
    vim.opt.formatoptions:remove 'e'
  end,
})

local number_toggle = augroup('NumberToggle', { clear = true })

autocmd('InsertEnter', {
  group = number_toggle,
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
  end,
})

autocmd('InsertLeave', {
  group = number_toggle,
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
