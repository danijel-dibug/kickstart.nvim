-- Debugging with nvim-dap. Adapters come from Mason via mason-nvim-dap.
--
--   F5  continue   F1 step in   F2 step over   F3 step out   F7 debug UI
--   <leader>b  toggle breakpoint   <leader>B  conditional breakpoint
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'mfussenegger/nvim-dap',
  Pack.gh 'rcarriga/nvim-dap-ui',
  Pack.gh 'nvim-neotest/nvim-nio', -- required by nvim-dap-ui
  Pack.gh 'jay-babu/mason-nvim-dap.nvim',
  Pack.gh 'leoluz/nvim-dap-go',
}

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'delve', -- Go
    'python', -- debugpy
    'js', -- node
    'javadbg',
    'javatest',
  },
}

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Breakpoint signs, readable without a Nerd Font too.
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and {
      Breakpoint = '',
      BreakpointCondition = '',
      BreakpointRejected = '',
      LogPoint = '',
      Stopped = '',
    }
  or {
    Breakpoint = '●',
    BreakpointCondition = '⊜',
    BreakpointRejected = '⊘',
    LogPoint = '◆',
    Stopped = '⭔',
  }
for type, icon in pairs(breakpoint_icons) do
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define('Dap' .. type, { text = icon, texthl = hl, numhl = hl })
end

-- Open the UI when a session starts, close it when the debuggee is gone.
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Java: attach to an already running JVM, e.g.
--   ./gradlew bootRun --jvmargs='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005'
dap.adapters.java = {
  type = 'server',
  host = '127.0.0.1',
  port = 5005,
}
dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = 'Attach to JVM on 5005',
    hostName = '127.0.0.1',
    port = 5005,
  },
}

require('dap-go').setup {
  delve = {
    -- On Windows delve must run attached or it crashes.
    detached = vim.fn.has 'win32' == 0,
  },
}

local map = vim.keymap.set
map('n', '<F5>', function()
  dap.continue()
end, { desc = 'Debug: start/continue' })
map('n', '<F1>', function()
  dap.step_into()
end, { desc = 'Debug: step into' })
map('n', '<F2>', function()
  dap.step_over()
end, { desc = 'Debug: step over' })
map('n', '<F3>', function()
  dap.step_out()
end, { desc = 'Debug: step out' })
map('n', '<F7>', function()
  dapui.toggle()
end, { desc = 'Debug: toggle UI' })
map('n', '<leader>b', function()
  dap.toggle_breakpoint()
end, { desc = '[B]reakpoint: toggle' })
map('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = '[B]reakpoint: conditional' })
