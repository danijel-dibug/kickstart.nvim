-- LSP: how clients are configured and which ones are enabled.
--
-- Neovim configures LSP natively since 0.11: nvim-lspconfig only ships the
-- per-server data (command, filetypes, root markers), `vim.lsp.config()` merges
-- settings and `vim.lsp.enable()` turns on auto-activation per filetype.
-- See :help lsp-config and :help vim.lsp.enable()
--
-- Server definitions live in servers.lua, buffer keymaps in keymaps.lua.
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'neovim/nvim-lspconfig',
  Pack.gh 'j-hui/fidget.nvim', -- progress notifications for LSP startup/indexing
}

require('fidget').setup {}

-- Tell servers which client features we actually have (completion items,
-- snippets through vim.snippet, etc.).
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

---@type table<string, vim.lsp.Config>
local servers = require 'plugins.lsp.servers'

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

require 'plugins.lsp.keymaps'
