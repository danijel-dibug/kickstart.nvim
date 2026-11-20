-- Git.
--
--   gitsigns  signs in the gutter and hunk level operations (<leader>h...)
--   diffview  review a diff, a file's history or the whole repo (<leader>gd/gh)
--   lazygit   the full TUI client for everything else (<leader>gg)
--   fugitive  :Git and friends on the command line
--
-- Requires the `lazygit` executable for <leader>gg/gf/gl.
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'lewis6991/gitsigns.nvim',
  Pack.gh 'nvim-lua/plenary.nvim', -- required by diffview
  Pack.gh 'sindrets/diffview.nvim',
  Pack.gh 'tpope/vim-fugitive',
}

-- gitsigns --------------------------------------------------------------------

local gitsigns = require 'gitsigns'

gitsigns.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    -- Same argument order as vim.keymap.set(), plus a shorthand for desc.
    local function map(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation. In a diff window these fall through to the diff motion.
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, 'Next git [c]hange')
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, 'Previous git [c]hange')

    -- Hunk actions
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, 'Git hunk [s]tage (selection)')
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, 'Git hunk [r]eset (selection)')
    map('n', '<leader>hs', gitsigns.stage_hunk, 'Git hunk [s]tage')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'Git hunk [r]eset')
    map('n', '<leader>hS', gitsigns.stage_buffer, 'Git [S]tage buffer')
    map('n', '<leader>hu', gitsigns.undo_stage_hunk, 'Git [u]ndo stage hunk')
    map('n', '<leader>hR', gitsigns.reset_buffer, 'Git [R]eset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, 'Git hunk [p]review')
    map('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, 'Git [b]lame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'Git [d]iff against index')
    map('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, 'Git [D]iff against last commit')
    map('n', '<leader>hq', gitsigns.setqflist, 'Git hunk [q]uickfix list (this file)')
    map('n', '<leader>hQ', function()
      gitsigns.setqflist 'all'
    end, 'Git hunk [Q]uickfix list (whole repo)')

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle line [b]lame')
    map('n', '<leader>tw', gitsigns.toggle_word_diff, '[T]oggle word [w] diff')

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, '[i]nside git [h]unk')
  end,
}

-- diffview --------------------------------------------------------------------

require('diffview').setup {
  view = {
    merge_tool = { layout = 'diff3', disable_diagnostics = true },
    file_history = { layout = 'diff2' },
  },
}

local map = vim.keymap.set
local call = require('core.keymap').call

map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Git [D]iff view (working tree)' })
map('n', '<leader>gD', '<cmd>DiffviewOpen HEAD~1..<CR>', { desc = 'Git diff view against [D] recent commits' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Git file [H]istory' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = 'Git repository [H]istory' })

-- lazygit and the picker backed git views -------------------------------------

if vim.fn.executable 'lazygit' == 1 then
  map('n', '<leader>gg', call(Snacks.lazygit), { desc = '[G]it [g] lazygit' })
  map('n', '<leader>gl', Snacks.lazygit.log, { desc = '[G]it [l]og (lazygit)' })
  map('n', '<leader>gf', Snacks.lazygit.log_file, { desc = '[G]it current file log (lazygit)' })
end

map('n', '<leader>gs', Snacks.picker.git_status, { desc = 'Git [S]tatus' })
map('n', '<leader>gc', Snacks.picker.git_log, { desc = '[G]it [C]ommits' })
map('n', '<leader>gb', Snacks.picker.git_branches, { desc = 'Git [B]ranches' })
map('n', '<leader>gz', Snacks.picker.git_stash, { desc = 'Git [Z] stash' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', call(Snacks.gitbrowse), { desc = '[G]it [B]rowse in the browser' })
map('n', '<leader>gp', function()
  gitsigns.preview_hunk_inline()
end, { desc = '[G]it [P]review hunk inline' })
