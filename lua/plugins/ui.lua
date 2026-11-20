-- Keymap hints, TODO highlighting and indentation detection.
local Pack = require 'core.pack'

-- Pending keymap popup. Without it a <leader> sequence is a memory test.
Pack.add { Pack.gh 'folke/which-key.nvim' }

require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Documented prefixes, so the popup shows the group name before you type more.
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>g', group = '[G]it' },
    { '<leader>gr', group = 'LSP', mode = { 'n' } },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>d', group = '[D]iagnostic / database' },
    { '<leader>b', group = '[B]uffer / breakpoint' },
    { '<leader>c', group = '[C]ode / file' },
    { '<leader>u', group = '[U]I' },
  },
}

-- Highlight and jump to TODO/FIXME/NOTE/... comments.
-- The list of them is a picker: <leader>st (todo-comments registers the
-- `todo_comments` source with snacks.picker on setup).
Pack.add { Pack.gh 'folke/todo-comments.nvim' }

require('todo-comments').setup {
  signs = false, -- the gutter belongs to gitsigns
}

local map = vim.keymap.set
map('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next TODO comment' })
map('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous TODO comment' })

-- Detect tabstop/shiftwidth in files that mix styles.
Pack.add { Pack.gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}
