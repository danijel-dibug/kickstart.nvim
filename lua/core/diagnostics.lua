-- Diagnostics: how they are displayed and how to move around them.
-- See :help vim.diagnostic.config()

local signs = vim.g.have_nerd_font
    and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    }
  or {}

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  -- Only errors get underlined; warnings stay readable through the virtual text.
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = signs,
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
}

local map = vim.keymap.set

-- `[d` / `]d` jump between diagnostics, `[D` / `]D` jump by the current
-- diagnostic's severity. Those are built in; these mappings add them to the
-- which-key popup and the `<leader>d` group lives here too.
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next diagnostic' })

map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })

-- Diagnostics of the whole buffer as a location list; the picker version is
-- <leader>sd (see lua/plugins/snacks.lua).
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Buffer diagnostics to location list' })
