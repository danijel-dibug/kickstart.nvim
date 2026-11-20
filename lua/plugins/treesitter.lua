-- Treesitter: highlighting, indentation, injections and the context line.
--
-- nvim-treesitter's `main` branch is a thin parser manager now; highlighting
-- and indentation are started with the native |vim.treesitter| API, which is
-- what this module does. See :help nvim-treesitter-intro
local Pack = require 'core.pack'

Pack.add {
  { src = Pack.gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  -- Ships the `textobjects.scm` queries that mini.ai uses for `af`/`if`/`ac`/`ic`.
  Pack.gh 'nvim-treesitter/nvim-treesitter-textobjects',
  Pack.gh 'nvim-treesitter/nvim-treesitter-context',
}

-- Parsers to install up front. Anything else is installed on first use by the
-- FileType autocmd at the bottom of this file.
local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'html',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'kotlin',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'sql',
  'templ',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
  'zig',
}

-- The `main` branch compiles parsers by shelling out to the tree-sitter CLI.
-- Mason provides it as `tree-sitter-cli` and puts it on PATH, so mason.lua is
-- loaded before this module.
local has_cli = vim.fn.executable 'tree-sitter' == 1

if has_cli then
  require('nvim-treesitter').install(parsers)
else
  vim.schedule(function()
    vim.notify('tree-sitter CLI not found, so parsers cannot be compiled. Run :MasonInstall tree-sitter-cli and restart.', vim.log.levels.WARN)
  end)
end

---@param buf integer
---@param language string
local function attach(buf, language)
  -- The buffer may be gone by the time an async parser install finishes.
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if not vim.treesitter.language.add(language) then
    return
  end

  vim.treesitter.start(buf, language)

  -- Use treesitter indentation only where the language has an indent query;
  -- otherwise fall back to Neovim's built-in indentexpr.
  if vim.treesitter.query.get(language, 'indents') then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start treesitter for the buffer, installing the parser if needed',
  callback = function(event)
    local language = vim.treesitter.language.get_lang(event.match)
    if not language then
      return
    end

    local ts = require 'nvim-treesitter'
    if vim.tbl_contains(ts.get_installed 'parsers', language) then
      attach(event.buf, language)
    elseif has_cli and vim.tbl_contains(ts.get_available(), language) then
      ts.install(language):await(function()
        attach(event.buf, language)
      end)
    else
      -- Parser provided by something other than nvim-treesitter.
      attach(event.buf, language)
    end
  end,
})

-- The sticky "you are inside this function/class" line at the top.
require('treesitter-context').setup {
  max_lines = 4,
  trim_scope = 'outer',
  mode = 'topline',
}

vim.keymap.set('n', '<leader>uc', require('treesitter-context').toggle, { desc = '[U]I: toggle treesitter [C]ontext' })
