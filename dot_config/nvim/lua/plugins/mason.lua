return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
    cond = not vim.g.vscode,
    opt = nil,
    config = function()
      require('mason').setup {
        PATH = 'prepend',
        max_concurrent_installers = 10,
        ui = {
          icons = {
            package_pending = ' ',
            package_installed = '󰄳 ',
            package_uninstalled = ' ',
          },
          keymaps = {
            toggle_server_expand = '<CR>',
            install_server = 'i',
            update_server = 'u',
            check_server_version = 'v',
            update_all_servers = 'U',
            check_outdated_servers = 'c',
            uninstall_server = 'X',
            cancel_installation = '<C-c>',
          },
        },
      }

      vim.api.nvim_create_user_command('Mason', function()
        require 'telescope'
        require('mason.ui').open()
      end, {})
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    cond = not vim.g.vscode,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local ensure_installed = {} --vim.tbl_keys(require 'configs.lspservers' or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'jq',
        'yamlfmt',
        'xmlformatter',
        'netcoredbg',
        'csharpier',
        'terraformls',
        'gofumpt',
        'goimports',
        'delve',
        'prettier',
        'black',
        'isort',
        'eslint',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
        auto_update = true,
      }
    end,
  },
}
