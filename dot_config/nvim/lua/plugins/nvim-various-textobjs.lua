return {
  'chrisgrieser/nvim-various-textobjs',
  event = 'VeryLazy',
  opts = {
    keymaps = {
      useDefaults = false,
    },
  },
  keys = {
    { 'ii', '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>', mode = { 'o', 'x' } },
    { 'ai', '<cmd>lua require("various-textobjs").indentation("outter", "inner")<CR>', mode = { 'o', 'x' } },
    { 'is', '<cmd>lua require("various-textobjs").subword("inner")<CR>', mode = { 'o', 'x' } },
    { 'as', '<cmd>lua require("various-textobjs").subword("outter")<CR>', mode = { 'o', 'x' } },
    { 'iq', '<cmd>lua require("various-textobjs").anyQuote("inner")<CR>', mode = { 'o', 'x' } },
    { 'aq', '<cmd>lua require("various-textobjs").anyQuote("outter")<CR>', mode = { 'o', 'x' } },
    { 'n', '<cmd>lua require("various-textobjs").nearEoL()<CR>', mode = { 'o', 'x' } },
  },
}
