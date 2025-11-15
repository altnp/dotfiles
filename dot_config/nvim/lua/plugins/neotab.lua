return {
  'kawre/neotab.nvim',
  event = 'InsertEnter',
  cond = not vim.g.vscode,
  opts = {
    tabkey = '<Tab>',
    act_as_tab = true,
    behavior = 'nested',
    pairs = {
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '<', close = '>' },
    },
    exclude = {},
    smart_punctuators = {
      enabled = false,
    },
  },
}
