local snacks = require("snacks")

local M = {}

function M.close_explorer()
  for _, explorer in ipairs(snacks.picker.get({ source = "explorer" })) do
    explorer:close()
  end
end

function M.close_left_terminal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].snacks_terminal and vim.w[win].snacks_win and vim.w[win].snacks_win.position == "left" then
      vim.api.nvim_win_close(win, true)
    end
  end
end

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

function M.toggle_left()
  M.close_explorer()
  snacks.terminal.toggle(nil, { count = 101, cwd = M.current_buf_dir(), win = { position = "left" } })
end

function M.toggle_float()
  snacks.terminal.toggle(nil, { count = 102, cwd = vim.loop.cwd(), win = { position = "float" } })
end

function M.toggle_right()
  snacks.terminal.toggle(nil, { count = 103, cwd = vim.loop.cwd(), win = { position = "right" } })
end

return M
