-- Editor options. This is the single place where global options are set.
-- Per-buffer/per-window options live in after/ftplugin/.
-- See :help option-list

-- ============================================================
-- UI
-- ============================================================

vim.o.number = true
vim.o.relativenumber = true -- absolute number on the current line, relative elsewhere
vim.o.mouse = 'a'
vim.o.showmode = false -- the statusline already shows the mode
vim.o.signcolumn = 'yes' -- keep the gutter width stable, no shifting on diagnostic/sign changes
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.o.laststatus = 3 -- one statusline for all windows instead of one per window
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.fillchars = { eob = ' ' } -- no `~` markers at the end of the buffer

-- ============================================================
-- Files
-- ============================================================

vim.o.undofile = true -- persistent undo history
vim.o.swapfile = false
vim.o.confirm = true -- ask before throwing away unsaved changes (:help 'confirm')
vim.o.autoread = true -- reload files that changed on disk

-- Command-line completion for file names: skip the noise.
vim.opt.wildignore:append { '**/node_modules/**', '**/.git/**', '**/build/**', '**/dist/**', '**/target/**', '**/.venv/**', '**/__pycache__/**' }

-- ============================================================
-- Search
-- ============================================================

vim.o.ignorecase = true -- case insensitive...
vim.o.smartcase = true -- ...unless the pattern contains an uppercase letter or \C
vim.o.inccommand = 'split' -- live preview of :substitute in a split

-- ============================================================
-- Editing
-- ============================================================

vim.o.expandtab = true -- spaces, always; formatters and ftplugins decide the width
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.breakindent = true -- wrapped lines keep the indentation of the first line
vim.o.wrap = true
vim.o.linebreak = true -- wrap on word boundaries, not mid-word
vim.o.updatetime = 250 -- CursorHold / diagnostic latency
vim.o.timeoutlen = 300 -- wait for the rest of a mapped key sequence
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.more = false -- don't pause long :command output
vim.o.foldmethod = 'manual'

-- Spell checking, English + Croatian. `:w` on a bad word offers to add it to
-- spell/en.utf-8.add (zg). See :help spell.
vim.o.spell = true
vim.o.spelllang = 'en,hr'

-- Better diffs for :diff, :diffthis and gitsigns previews.
-- diffview.nvim configures its own window layout on top of this.
vim.opt.diffopt:append { 'algorithm:histogram', 'indent-heuristic' }

-- Clipboard integration is scheduled because probing the provider can slow
-- down startup. See :help clipboard.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- To use treesitter based folding instead of 'manual':
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
