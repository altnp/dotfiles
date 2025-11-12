return {
  'rhysd/clever-f.vim',
  event = 'VeryLazy',
  config = function()
    vim.g.clever_f_smart_case = 1

    vim.api.nvim_set_hl(0, 'CleverF', { bold = true })
    vim.g.clever_f_mark_char_color = 'CleverF'
    vim.g.clever_f_across_no_line = 1
  end,
}
