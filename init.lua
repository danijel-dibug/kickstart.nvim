-- Personal Neovim configuration.
--
-- Layout:
--   init.lua              bootstrap only, keep it tiny
--   lua/core/             editor setup that needs no plugins
--   lua/plugins/          one file per concern; plugins are declared and
--                         configured where they belong
--   after/ftplugin/       per-filetype local options (native Neovim mechanism)
--
-- Plugins are managed by the built-in `vim.pack` and are listed in
-- lua/core/pack.lua. See README.md for the keybinding cheatsheet.

-- Leader keys must exist before any keymap is defined.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if the terminal uses a Nerd Font.
vim.g.have_nerd_font = true

require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'core.diagnostics'
require 'core.pack' -- vim.pack helpers and build hooks

-- Plugin modules, one per concern, each declaring and configuring its own
-- plugins. Order matters in a few places:
--   colorscheme  before anything draws a colour
--   editing      mini.icons mocks nvim-web-devicons for the modules below
--   completion   before lsp, which reads blink.cmp capabilities
--   mason        before treesitter, which needs Mason's tree-sitter CLI on PATH
require 'plugins.colorscheme'
require 'plugins.editing'
require 'plugins.snacks'
require 'plugins.ui'
require 'plugins.statusline'
require 'plugins.mason'
require 'plugins.treesitter'
require 'plugins.ai'
require 'plugins.db'
require 'plugins.markdown'
require 'plugins.completion'
require 'plugins.lsp'
require 'plugins.format'
require 'plugins.dap'
require 'plugins.git'

-- vim: ts=2 sts=2 sw=2 et
