-- Completion, signature help and inline (ghost text) suggestions.
--
-- Snippets use Neovim's native `vim.snippet` engine, which is blink.cmp's
-- default: no snippet plugin is needed. Put your own snippets in
-- `~/.config/nvim/snippets/<filetype>/*.snippet.json` and blink will pick them
-- up. LSP servers already send snippets through this. See :help blink-cmp-config-snippets
--
-- minuet is deliberately not in `sources.default`: normal typing must not hammer
-- the local model (slow, plus an error popup whenever that server is off). Ask
-- for it with <A-y>; minuet's own ghost text handles the automatic case, and it
-- switches itself on only when the server answers -- lua/plugins/ai.lua.
local Pack = require 'core.pack'

Pack.add {
  { src = Pack.gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  Pack.gh 'folke/lazydev.nvim', -- Lua LSP setup for editing Neovim config itself
}

require('lazydev').setup {
  library = {
    -- Load luvit type definitions when `vim.uv` shows up.
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

---@module 'blink.cmp'
require('blink.cmp').setup {
  keymap = {
    -- <Tab>/<S-Tab> select and move through snippets, <C-Space> completes/docs,
    -- <C-N>/<C-P> navigate, <C-E> hides, <C-K> signature help.
    preset = 'default',

    -- AI completion on demand (minuet, see lua/plugins/ai.lua).
    ['<A-y>'] = {
      function(cmp)
        cmp.show { providers = { 'minuet' } }
      end,
    },
  },

  appearance = { nerd_font_variant = 'mono' },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    -- Inline ghost text for LSP completions (AI ghost text is minuet's own).
    ghost_text = { enabled = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    per_filetype = {
      -- SQL completions from the connections vim-dadbod knows about.
      -- Providers themselves are wired up in lua/plugins/db.lua.
      sql = { 'dadbod', 'buffer' },
      mysql = { 'dadbod', 'buffer' },
      plsql = { 'dadbod', 'buffer' },
    },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      -- Offered only by <A-y>, never during ordinary typing.
      minuet = {
        name = 'minuet',
        module = 'minuet.blink',
        async = true,
        -- Keep in sync with minuet's `request_timeout` (seconds there).
        timeout_ms = 3000,
        score_offset = 50,
      },
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
    },
  },

  -- The Rust fuzzy matcher is much faster on long candidate lists; it downloads
  -- a prebuilt binary on first use and falls back to the Lua one if that fails.
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  signature = { enabled = true },
}
