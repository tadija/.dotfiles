local del = vim.keymap.del
local map = vim.keymap.set

local M = {}

-- quick log
_G.dump = function(...)
  print(vim.inspect(...))
end

-- normalized path to current buffer
function M.current_buf_dir()
  -- get buffer
  local win = vim.fn.win_getid(vim.fn.winnr("#"))
  local buf = (win ~= 0) and vim.api.nvim_win_get_buf(win) or nil
  -- mark buffer
  if not buf or vim.bo[buf].buftype ~= "" then
    buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" then
      buf = -1
    end
  end
  -- set dir
  local dir
  if buf == -1 then
    dir = vim.loop.cwd()
  else
    -- get current file path
    local name = vim.api.nvim_buf_get_name(buf)
    dir = vim.fn.fnamemodify(name, ":p:h")
  end
  -- normalize path
  dir = vim.fn.fnamemodify(dir, ":p")
  return dir
end

function M.remove_lazy_keymaps()
  -- Lazy, LazyChangelog
  del("n", "<leader>l")
  del("n", "<leader>L")
end

-- move built-in mappings from <leader>x to <leader>d (not in use)
function M.move_diagnostics()
  local diagnostics_keys = { "xl", "xL", "xq", "xQ", "xt", "xT", "xx", "xX" }
  for _, lhs in ipairs(diagnostics_keys) do
    local old_lhs = "<leader>" .. lhs
    local mapping = vim.fn.maparg(old_lhs, "n", false, true)
    if mapping and not vim.tbl_isempty(mapping) then
      local rhs = mapping.callback or mapping.rhs
      if rhs and rhs ~= "" then
        local opts = {
          desc = mapping.desc,
          remap = mapping.noremap == 0 or nil,
          silent = mapping.silent == 1 or nil,
          expr = mapping.expr == 1 or nil,
          nowait = mapping.nowait == 1 or nil,
          script = mapping.script == 1 or nil,
        }
        if mapping.buffer and mapping.buffer > 0 then
          opts.buffer = mapping.buffer
        end

        local new_lhs = lhs:gsub("^x", "d")
        del("n", old_lhs)
        map("n", "<leader>" .. new_lhs, rhs, opts)
        -- dump("remap from: " .. old_lhs .." | to: " .. new_lhs)
      end
    end
  end
end

return M

