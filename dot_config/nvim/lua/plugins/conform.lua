return {
  'stevearc/conform.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  keys = {
    { '<leader>fm', mode = 'n', desc = 'Format File' },
  },
  config = function()
    require('conform').setup {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        css = { 'prettier' },
        terraform = { 'terraform_fmt' },
        go = { 'gofumpt', 'goimports' },
        -- cs = { 'csharpier' }, -- dotnet format for imports?
        py = { 'isort', 'black' },
      },
    }

    vim.keymap.set('n', '<leader>fm', function()
      require('conform').format { lsp_fallback = true }
    end, { desc = 'Format File' })

    -- Autoformat
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Autoformat', { clear = true }),
      pattern = {
        '*.lua',
        '*.yml',
        '*.yaml',
        '*.xml',
        '*.json',
        '*.html',
        '*.css',
        '*.tf',
        '*.ps1',
        '*.go',
        '*.js',
        '*.ts',
        '*.jsx',
        '*.tsx',
        '*.cs',
        '*.py',
        '*.sh',
        '*.tf',
      },
      callback = function(args)
        if not vim.b.skip_autoformat then
          require('conform').format {
            bufnr = args.buf,
            timeout_ms = 500,
            lsp_fallback = true,
            quiet = true,
          }
        else
          vim.notify('Autoformat is disabled', 'WARN')
        end
      end,
    })
    vim.api.nvim_create_user_command('ToggleAutoFormat', function()
      vim.b.skip_autoformat = not vim.b.skip_autoformat
    end, {})
  end,
}
