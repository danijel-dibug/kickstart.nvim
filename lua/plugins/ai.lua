-- AI completion against a local llama.cpp server (fill-in-the-middle).
--
-- The provider talks OpenAI's /v1/completions, so any local server that speaks
-- it works. Change `end_point` below to point somewhere else.
--
--   <A-y>      show AI completions in the completion menu (see completion.lua)
--   <A-A>      accept ghost text        <A-a> accept to end of line
--   <A-z>      accept n lines           <A-]> / <A-[> next/previous suggestion
--   <A-e>      dismiss
--
-- The inference machine is not always up, and every idle trigger against a dead
-- endpoint pops an error window. So ghost text is switched on only after a
-- background reachability check passes. <A-y> always stays available, and
-- `:checkhealth myconfig` tells you whether the server answers.
-- Set g:minuet_always_auto_trigger = true to skip the check.
local Pack = require 'core.pack'

Pack.add { Pack.gh 'milanglacier/minuet-ai.nvim' }

local end_point = 'http://100.96.244.90:8081/v1/completions'

local ghost_text_filetypes = {
  'lua',
  'python',
  'javascript',
  'typescript',
  'typescriptreact',
  'javascriptreact',
  'go',
  'rust',
  'kotlin',
  'java',
  'css',
  'html',
  'json',
  'yaml',
  'toml',
  'zig',
  'templ',
  'c',
  'cpp',
}

require('minuet').setup {
  provider = 'openai_fim_compatible',

  -- Sized for local inference: a bigger window means slower responses.
  context_window = 16000,
  context_ratio = 0.5,
  n_completions = 1,
  request_timeout = 3, -- seconds; blink.cmp's provider timeout_ms mirrors this
  notify = 'error', -- lowest level minuet offers

  virtualtext = {
    -- Set by the check at the bottom of this file.
    auto_trigger_ft = {},
    keymap = {
      accept = '<A-A>',
      accept_line = '<A-a>',
      accept_n_lines = '<A-z>',
      next = '<A-]>',
      prev = '<A-[>',
      dismiss = '<A-e>',
    },
  },

  provider_options = {
    openai_fim_compatible = {
      api_key = 'TERM', -- unused by the local server, but must be non-empty
      name = 'Llama.cpp',
      end_point = end_point,
      stream = true,
      optional = { max_tokens = 256, top_p = 0.9 },
      -- Qwen2.5-Coder style FIM template, with the file name as context.
      template = {
        prompt = function(prefix, suffix)
          return '<|file_sep|>' .. vim.fn.expand '%:t' .. '\n<|fim_prefix|>' .. prefix .. '<|fim_suffix|>' .. suffix .. '<|fim_middle|>'
        end,
      },
    },
  },
}

--- Ask minuet itself for the buffers to trigger in: the flag it reads is a
--- buffer variable, so setting it has exactly the effect of its own FileType
--- autocmd would have.
local function enable_ghost_text()
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Enable minuet ghost text for the configured filetypes',
    pattern = ghost_text_filetypes,
    callback = function()
      vim.b.minuet_virtual_text_auto_trigger = true
    end,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(ghost_text_filetypes, vim.b[buf].ft) then
      vim.b[buf].minuet_virtual_text_auto_trigger = true
    end
  end
end

---@param timeout_seconds number
---@param callback fun(reachable: boolean)
local function probe(callback, timeout_seconds)
  vim.system({ 'curl', '-s', '-o', '/dev/null', '-m', tostring(timeout_seconds), '-w', '%{http_code}', end_point }, {}, function(result)
    local code = (result.stdout or ''):match '%d+' or ''
    -- Any HTTP answer at all means the server is there; '000'/empty means not.
    callback(code ~= '' and code ~= '000')
  end)
end

if vim.g.minuet_always_auto_trigger then
  enable_ghost_text()
else
  probe(function(reachable)
    if reachable then
      enable_ghost_text()
    else
      vim.notify(('AI ghost text off: %s did not answer.\n<A-y> still asks for it manually. :checkhealth myconfig'):format(end_point), vim.log.levels.INFO)
    end
  end, 2)
end
