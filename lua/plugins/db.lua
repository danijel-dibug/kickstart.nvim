-- Database access. `:DBUIAddConnection` writes connections to
-- ~/.local/share/db_ui/connections.json, outside this repository.
--
-- Completion for SQL buffers is wired up in lua/plugins/completion.lua
-- (`per_filetype.sql = { 'dadbod', 'buffer' }`).
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'tpope/vim-dadbod',
  Pack.gh 'kristijanhusak/vim-dadbod-completion',
  Pack.gh 'kristijanhusak/vim-dadbod-ui',
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_winwidth = 32

vim.keymap.set('n', '<leader>db', '<cmd>DBUI<CR>', { desc = 'Database [UI]' })
vim.keymap.set('n', '<leader>dq', '<cmd>DBUIToggle<CR>', { desc = 'Toggle database sidebar' })
