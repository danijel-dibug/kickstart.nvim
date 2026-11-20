-- snacks.nvim: the quality-of-life layer. It provides the fuzzy picker, the
-- file explorer, notifications, the terminal, zen mode, scratch buffers, indent
-- guides and the statuscolumn, so several single-purpose plugins are not needed.
--
--   replaces: telescope.nvim, neo-tree.nvim, indent-blankline.nvim, nvim-notify
--   not enabled: dashboard (plain startup screen is fine), animate, scope
local Pack = require 'core.pack'

Pack.add { Pack.gh 'folke/snacks.nvim' }

---@module 'snacks'
require('snacks').setup {
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  git = { enabled = true },
  gitbrowse = { enabled = true },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  lazygit = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = {
    enabled = true,
    -- Sources use snacks' adaptive layout: a wide window with a preview when
    -- there is room, a vertical one when there is not.
  },
  quickfile = { enabled = true },
  rename = { enabled = true },
  scratch = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  util = { enabled = true },
  words = { enabled = true },
  zen = { enabled = true },
}

-- Take over the built-in prompt/list UI, so LSP rename prompts, code action
-- lists and :confirm dialogs use the same picker instead of the cmdline list.
Snacks.input.enable() -- sets vim.ui.input to Snacks.input.input
vim.ui.select = Snacks.picker.select

local map = vim.keymap.set
local call = require('core.keymap').call

-- Search / pickers ------------------------------------------------------------
-- The <leader>s namespace is kept from the previous telescope setup.

map('n', '<leader><leader>', Snacks.picker.buffers, { desc = 'Buffers' })
map('n', '<leader>sf', Snacks.picker.files, { desc = '[S]earch [F]iles' })
map('n', '<leader>sg', Snacks.picker.grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sw', Snacks.picker.grep_word, { desc = '[S]earch current [W]ord' })
map('n', '<leader>s/', Snacks.picker.grep_buffers, { desc = 'Search in open buffers' })
map('n', '<leader>sd', Snacks.picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', Snacks.picker.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', Snacks.picker.recent, { desc = 'Recent files' })
map('n', '<leader>ss', Snacks.picker.pickers, { desc = '[S]elect a picker' })
map('n', '<leader>sh', Snacks.picker.help, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', Snacks.picker.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sc', Snacks.picker.colorschemes, { desc = '[S]earch [C]olorschemes' })
map('n', '<leader>sm', Snacks.picker.marks, { desc = '[S]earch [M]arks' })
map('n', '<leader>sj', Snacks.picker.jumps, { desc = '[S]earch jump [L]ist' })
map('n', '<leader>sy', Snacks.picker.registers, { desc = '[S]earch Cop[y] registers' })
map('n', '<leader>sp', Snacks.picker.projects, { desc = '[S]earch [P]rojects' })
map('n', '<leader>st', function()
  Snacks.picker.todo_comments()
end, { desc = '[S]earch [T]ODO comments' })
map('n', '<leader>so', Snacks.picker.treesitter, { desc = 'Document [O]utline (symbols)' })
map('n', '<leader>/', Snacks.picker.lines, { desc = 'Search in current buffer' })

-- Neovim's own config files.
map('n', '<leader>sn', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Search Neovim config files' })

-- Explorer --------------------------------------------------------------------

map('n', '<leader>e', call(Snacks.explorer), { desc = 'Toggle file [E]xplorer' })
map('n', '\\', call(Snacks.explorer), { desc = 'Toggle file explorer' })

-- Windows, buffers, files -----------------------------------------------------

map('n', '<leader>bd', call(Snacks.bufdelete), { desc = '[B]uffer [D]elete' })
map('n', '<leader>cR', Snacks.rename.rename_file, { desc = '[R]ename file on disk' })

-- Terminal, zen mode, scratch, notifications ---------------------------------

map('n', '<c-/>', call(Snacks.terminal), { desc = 'Toggle terminal' })
map('t', '<c-/>', call(Snacks.terminal), { desc = 'Toggle terminal' })
map('n', '<c-_>', call(Snacks.terminal), { desc = 'which_key_ignore' })

map('n', '<leader>z', call(Snacks.zen), { desc = 'Toggle [Z]en mode' })
map('n', '<leader>Z', Snacks.zen.zoom, { desc = 'Toggle zoom of current window' })

map('n', '<leader>.', call(Snacks.scratch), { desc = 'Toggle scratch buffer' })
map('n', '<leader>S', Snacks.scratch.select, { desc = 'Select scratch buffer' })

map('n', '<leader>n', Snacks.notifier.show_history, { desc = 'Notification history' })
map('n', '<leader>un', Snacks.notifier.hide, { desc = 'Dismiss all notifications' })

-- Jump between reference-like words (TODO, FIXME, ...) in comments.
map({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next reference' })
map({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Previous reference' })
