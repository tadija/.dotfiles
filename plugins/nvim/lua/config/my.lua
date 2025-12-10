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
  -- Lazy, LazyChangelog, Keywordprg
  del("n", "<leader>l")
  del("n", "<leader>L")
  del("n", "<leader>K")
end

function M.remove_noice_keymaps()
  del("n", "<leader>snl")
  del("n", "<leader>snh")
  del("n", "<leader>sna")
  del("n", "<leader>snd")
  del("n", "<leader>snt")
end

function M.toggle_noice_console()
  -- health check
  local ok, noice = pcall(require, "noice")
  if not ok then
    vim.notify("noice is not available", vim.log.levels.WARN)
    return
  end

  -- if a noice split view (history/all/messages) is already visible, hide it
  local views = require("noice.view")._views or {}
  for _, view in ipairs(views) do
    local v = view.view
    if v and v._visible and v._opts and v._opts.type == "split" then
      v:hide()
      return
    end
  end

  -- otherwise, open history
  noice.cmd("history")
end

return M

