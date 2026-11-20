-- Mason: installer for language servers, formatters and linters.
--
--   :Mason                  browse / install / update packages
--   :MasonInstall <name>    install from the command line
--
-- The names below are Mason *package* names, which are not always the same as
-- the LSP server names used in lua/plugins/lsp/servers.lua (for example the
-- `lua_ls` server is packaged as `lua-language-server`).
--
-- Missing entries are installed in the background on startup; nothing blocks.
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'mason-org/mason.nvim',
  Pack.gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}

require('mason-tool-installer').setup {
  ensure_installed = {
    -- Language servers
    'lua-language-server',
    'gopls',
    'pyright',
    'rust-analyzer',
    'typescript-language-server',
    'jdtls',
    'java-test',
    'kotlin-lsp',
    'html-lsp',
    'tailwindcss-language-server',
    'emmet-language-server',
    'eslint-lsp',
    'biome',
    'templ',
    'zls',

    -- Tools
    'tree-sitter-cli', -- nvim-treesitter compiles parsers with it

    -- Formatters
    'stylua',
    'prettierd',
    'black',
    'google-java-format',
    'ktlint',
    'eslint_d',
  },
}
