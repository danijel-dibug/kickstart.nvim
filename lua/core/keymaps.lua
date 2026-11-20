-- Global keymaps only. Anything belonging to a plugin lives with that plugin
-- in lua/plugins/, so a plugin can be removed without hunting for its keys.
--
-- Prefix map (see also lua/plugins/ui.lua for the which-key groups):
--   <leader>s  search        <leader>g  git          <leader>h  git hunk
--   <leader>t  toggle        <leader>d  diagnostic   <leader>b  breakpoint
--   <leader>e  explorer      <leader>f  format       <leader>w  write
--   <leader>z  zen           <leader>.  scratch      gr*        LSP

local map = vim.keymap.set

-- Editing --------------------------------------------------------------------

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>w', '<cmd>write<CR>', { desc = 'Save buffer' })
map('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Close window' })
map('n', '<leader>cd', '<cmd>cd %:h<CR>', { desc = 'Change directory to current file' })

map('i', 'jk', '<Esc>', { desc = 'Leave insert mode' })

-- Move the selected block/lines up and down, keeping it selected.
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep the selection after (un)indenting, so it can be repeated with `.`.
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Pasting over a selection should not clobber the delete register.
map('v', 'p', '"_dP', { desc = 'Paste over selection without yanking' })

-- Windows --------------------------------------------------------------------

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus window left' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus window above' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus window right' })

map('n', '<A-h>', '<C-w>H', { desc = 'Move window left' })
map('n', '<A-j>', '<C-w>J', { desc = 'Move window down' })
map('n', '<A-k>', '<C-w>K', { desc = 'Move window up' })
map('n', '<A-l>', '<C-w>L', { desc = 'Move window right' })

map('n', '<leader>-', '<C-w>s', { desc = 'Split window below' })
map('n', '<leader>|', '<C-w>v', { desc = 'Split window right' })

-- Terminal -------------------------------------------------------------------

-- Easier than <C-\><C-n>. Not all terminals deliver it; the default always works.
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Leave terminal mode' })
