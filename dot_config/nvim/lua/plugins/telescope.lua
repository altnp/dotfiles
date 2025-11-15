local grep_word = function()
  local word = vim.fn.expand '<cword>'
  require('telescope.builtin').grep_string { search = word }
end

local find_files_all = function()
  require('telescope.builtin').find_files {
    no_ignore = true,
    hidden = true,
    follow = true,
  }
end

local find_nvconfig_files = function()
  require('telescope.builtin').find_files {
    no_ignore = true,
    hidden = true,
    follow = true,
    cwd = vim.fn.stdpath 'config',
  }
end

local keymaps = function()
  require('telescope.builtin').keymaps {
    modes = { 'n', 'i', 'c', 'x', 't' },
  }
end

return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  cond = not vim.g.vscode,
  cmd = 'Telescope',
  keys = {
    { '<leader>ft', '<cmd>Telescope<CR>', mode = 'n', desc = 'Telescope' },
    { '<leader>ff', '<cmd>Telescope find_files<CR>', mode = 'n', desc = 'Telescope find files' },
    { '<leader>fa', find_files_all, mode = 'n', desc = 'Telescope find all files' },
    { '<leader>fw', grep_word, mode = 'n', desc = 'Telescope grep files' },
    { '<leader>fg', '<cmd>Telescope live_grep<CR>', mode = 'n', desc = 'Telescope grep files' },
    { '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', mode = 'n', desc = 'Telescope search current buffer' },
    { '<leader>fb', '<cmd>Telescope buffers<CR>', mode = 'n', desc = 'Telescope find buffers' },
    { '<leader>fh', '<cmd>Telescope highlights<CR>', mode = 'n', desc = 'Telescope highlights' },
    { '<leader>fn', '<cmd>Telescope notify<CR>', mode = 'n', desc = 'Telescope Notification' },
    { '<leader>f,', find_nvconfig_files, mode = 'n', desc = 'Telescope Keymaps' },
    { '<leader>fk', keymaps, mode = 'n', desc = 'Telescope Keymaps' },
    -- { '<leader>e', '<cmd>Telescope file_browser path=%p:h select_buffer=true<CR>', mode = 'n', desc = 'Telescope Notification' },
    { 'g?', '<cmd>Telescope help_tags<CR>', mode = 'n', desc = 'Telescop find help pages' },
  },
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
    'benfowler/telescope-luasnip.nvim',
  },
  config = function(_, opts)
    local transform_mod = require('telescope.actions.mt').transform_mod
    local telescope_utils = require 'telescope.utils'

    opts = vim.tbl_deep_extend('force', opts, {
      defaults = {
        path_display = function(_, path)
          local tail = telescope_utils.path_tail(path)
          return string.format('%s (%s)', tail, path)
        end,
        default_mappings = {},
        mappings = {
          n = {
            ['q'] = require('telescope.actions').close,
            ['<Esc>'] = require('telescope.actions').close,
            ['j'] = require('telescope.actions').move_selection_next,
            ['J'] = function(prompt_bufnr)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local max_line = #current_picker.finder.results

              if current_picker:get_selection_row() <= max_line - 1 then
                local lines = require('math').min(max_line - current_picker:get_selection_row() - 1, 5)
                for _ = 1, lines do
                  actions.move_selection_next(prompt_bufnr)
                end
              end
            end,
            ['k'] = require('telescope.actions').move_selection_previous,
            ['K'] = function(prompt_bufnr)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'
              local current_picker = action_state.get_current_picker(prompt_bufnr)

              if current_picker:get_selection_row() > 0 then
                local lines = require('math').min(current_picker:get_selection_row(), 5)
                for _ = 1, lines do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end
            end,
            ['gg'] = require('telescope.actions').move_to_top,
            ['G'] = require('telescope.actions').move_to_bottom,
            ['<CR>'] = require('telescope.actions').select_default,
            ['|'] = require('telescope.actions').select_vertical,
            ['\\'] = require('telescope.actions').select_horizontal,
            ['<leader>q'] = require('telescope.actions').send_selected_to_qflist + transform_mod({
              a = function(_)
                vim.cmd [[Trouble qflist toggle]]
              end,
            }).a,
            ['<leader>Q'] = require('telescope.actions').send_to_qflist + transform_mod({
              a = function(_)
                vim.cmd [[Trouble qflist toggle]]
              end,
            }).a,
            ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
            ['g?'] = require('telescope.actions').which_key,
          },
          i = {
            ['<C-j>'] = require('telescope.actions').move_selection_next,
            ['<C-S-j>'] = function(prompt_bufnr)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'
              local current_picker = action_state.get_current_picker(prompt_bufnr)

              if current_picker:get_selection_row() > 0 then
                for _ = 1, 5 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end
            end,
            ['<C-k>'] = require('telescope.actions').move_selection_previous,
            ['<C-S-k>'] = function(prompt_bufnr)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'
              local current_picker = action_state.get_current_picker(prompt_bufnr)

              if current_picker:get_selection_row() > 0 then
                for _ = 1, 5 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end
            end,
            ['<CR>'] = require('telescope.actions').select_default,
            ['<C-|>'] = require('telescope.actions').select_vertical,
            ['<C-\\>'] = require('telescope.actions').select_horizontal,
            ['<Esc>'] = require('telescope.actions').close,
            ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
          },
        },
      },
      pickers = {
        buffers = {
          previewer = false,
          layout_config = {
            width = { 0.87, max = 120 },
          },
          initial_mode = 'normal',
          mappings = {
            n = {
              ['<leader>d'] = require('telescope.actions').delete_buffer,
              ['<C-b>'] = require('telescope.actions').delete_buffer,
            },
          },
        },
      },
      extensions = {
        'notify',
        file_browser = {
          path_display = function(_, path)
            return telescope_utils.path_tail(path)
          end,
          hidden = { file_browser = true, folder_browser = true },
          grouped = true,
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown { layout_config = { width = 0.5 } },
        },
        luasnip = {},
      },
    })
    require('telescope').setup(opts)

    require('telescope').load_extension 'fzf'
    require('telescope').load_extension 'ui-select'
    require('telescope').load_extension 'luasnip'
    require('telescope').load_extension 'file_browser'
  end,
}
