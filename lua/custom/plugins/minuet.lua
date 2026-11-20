return {
  'milanglacier/minuet-ai.nvim',
  event = 'InsertEnter',
  config = function()
    require('minuet').setup {
      -- FIM provider for llama.cpp / ollama
      provider = 'openai_fim_compatible',

      -- Small context to start - increase once you gauge your inference speed
      context_window = 16000,
      context_ratio = 0.5,

      -- 1 completion saves resources on local inference
      n_completions = 1,

      -- Tuned for local model responsiveness
      -- throttle = 400,
      -- debounce = 150,
      request_timeout = 3,

      notify = 'warn',

      -- Virtual text for manual + auto completions
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

      -- Enable auto-complete through blink.cmp
      -- blink = { enable_auto_complete = true },

      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM', -- arbitrary non-null placeholder for local
          name = 'Llama.cpp',
          end_point = 'http://100.96.244.90:8081/v1/completions',
          stream = true,
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
          -- Qwen2.5-Coder FIM template
          -- template = {
          --   prompt = function(context_before_cursor, context_after_cursor, _)
          --     return '<|fim_prefix|>' .. context_before_cursor .. '<|fim_suffix|>' .. context_after_cursor .. '<|fim_middle|>'
          --   end,
          --   suffix = false,
          -- },
          template = {
            prompt = function(pref, suf)
              return '<|file_sep|>' .. vim.fn.expand '%:t' .. '\n<|fim_prefix|>' .. pref .. '<|fim_suffix|>' .. suf .. '<|fim_middle|>'
            end,
          },
        },
      },
    }
  end,
}
