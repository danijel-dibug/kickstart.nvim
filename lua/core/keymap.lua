-- Keymap helpers.

local M = {}

--- Wrap a callable so that it can be used as a keymap right hand side.
--- Some modules are tables that are called through a `__call` metamethod
--- (`Snacks.explorer`, `Snacks.zen`, `Snacks.terminal`, ...), and
--- `vim.keymap.set()` only accepts a string or a function.
---@param fn function|table
---@return fun(...): any
function M.call(fn)
  return function(...)
    return fn(...)
  end
end

return M
