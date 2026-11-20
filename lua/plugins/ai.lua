-- AI completion against a local llama.cpp server (fill-in-the-middle).
--
-- The provider talks OpenAI's /v1/completions, so any local server that speaks
-- it works. Change `end_point` below to point somewhere else.
--
--   <A-y>      show AI completions in the completion menu (see completion.lua)
--   <A-A>      accept ghost text        <A-a> accept to end of line
--   <A-z>      accept n lines           <A-]> / <A-[> next/previous suggestion
--   <A-e>      dismiss
local Pack = require 'core.pack'

Pack.add { Pack.gh 'milanglacier/minuet-ai.nvim' }

require('minuet').setup {
  provider = 'openai_fim_compatible',

  -- Sized for local inference: a bigger window means slower responses.
  context_window = 16000,
  context_ratio = 0.5,
  n_completions = 1,
  request_timeout = 3, -- seconds; blink.cmp's provider timeout_ms mirrors this
  notify = 'warn',

  virtualtext = {
    auto_trigger_ft = {
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
    },
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
      end_point = 'http://100.96.244.90:8081/v1/completions',
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
