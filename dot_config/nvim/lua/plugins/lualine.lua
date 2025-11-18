local colors = {
  blue = '#005f87',
  cyan = '#005f5f',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff0000',
  violet = '#45316e',
  grey = '#303030',
}

local theme = {
  normal = {
    a = { fg = colors.white, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.white, bg = colors.blue } },
  visual = { a = { fg = colors.white, bg = colors.cyan } },
  replace = { a = { fg = colors.white, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.grey },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cond = not vim.g.vscode,
  lazy = false,
  opts = {
    options = {
      theme = theme,
      component_separators = '',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = ' ' }, right_padding = 2 } },
      lualine_b = { 'filename', 'branch' },
      lualine_c = {
        '%=', --[[ add your center components here in place of this comment ]]
      },
      lualine_x = {},
      lualine_y = { 'filetype', 'progress' },
      lualine_z = {
        { 'location', separator = { right = ' ' }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { { 'filename', separator = { left = ' ', right = '' } } },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { 'location', separator = { left = '', right = ' ' } } },
    },
    tabline = {},
    extensions = {},
  },
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}
