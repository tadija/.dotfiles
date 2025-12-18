local snacks = require("snacks")
local del = vim.keymap.del

local M = {}

-- quick log
_G.dump = function(...)
  print(vim.inspect(...))
end

function M.close_explorer()
  -- close snacks explorer
  for _, explorer in ipairs(snacks.picker.get({ source = "explorer" })) do
    explorer:close()
  end
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
  del("n", "<leader>sn")
end

function M.random_colorscheme()
  local ok, themes = pcall(vim.fn.getcompletion, "", "color")
  if not ok or vim.tbl_isempty(themes) then
    return vim.notify("No colorschemes found", vim.log.levels.WARN)
  end
  math.randomseed(os.time())
  local choice = themes[math.random(#themes)]
  vim.cmd.colorscheme(choice)
  vim.notify("Colorscheme -> " .. choice)
end

return M

