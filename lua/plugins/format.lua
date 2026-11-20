-- Formatting with conform.nvim: external formatter first, LSP formatting as a
-- fallback. Formatters are installed by Mason (see lua/plugins/mason.lua).
local Pack = require 'core.pack'

Pack.add { Pack.gh 'stevearc/conform.nvim' }

-- ktlint formats on stdin but still exits non-zero when it finds lint problems,
-- which conform would report as a failure. Run it through `sh` and drop the
-- exit code, keeping its stdout.
local ktlint = vim.fn.stdpath 'data' .. '/mason/bin/ktlint'

--- A biome/eslint/prettier chain for the web filetypes: use whatever the project
--- actually has configured, first match wins.
local web = { 'biome', 'eslint_d', 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- No standard style for C/C++; formatting there does more harm than good.
    if vim.bo[bufnr].filetype == 'c' or vim.bo[bufnr].filetype == 'cpp' then
      return nil
    end
    return { timeout_ms = 5000, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = web,
    typescript = web,
    javascriptreact = web,
    typescriptreact = web,
    css = web,
    scss = web,
    html = web,
    json = web,
    jsonc = web,
    yaml = web,
    python = { 'black' },
    java = { 'google-java-format' },
    kotlin = { 'ktlint' },
    kts = { 'ktlint' },
  },
  formatters = {
    biome = {
      -- Only run biome when the project has a biome config file.
      require_cwd = true,
    },
    ktlint = {
      command = 'sh',
      args = { '-c', ktlint .. ' --log-level=none --format --stdin --stdin-path "$1"; exit 0', '_', '$FILENAME' },
      stdin = true,
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
