-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- helper: run only when buffer is safe to modify
local function on_safe_write(fn)
  return function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].buftype ~= "" then
      return
    end
    if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
      return
    end
    if vim.api.nvim_buf_get_name(bufnr) == "" then
      return
    end
    fn(bufnr)
  end
end

-- helper: fix EOL/EOF on WSL
local function normalize_lines(lines)
  if #lines == 0 then
    return lines, false
  end

  local changed = false

  for i, line in ipairs(lines) do
    local clean = line:gsub("\r", "")
    if clean ~= line then
      lines[i] = clean
      changed = true
    end
  end

  if lines[#lines] ~= "" then
    lines[#lines + 1] = ""
    changed = true
  end

  return lines, changed
end

-- on save: normalize CRLF and ensure trailing newline
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = on_safe_write(function(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local normalized, changed = normalize_lines(lines)
    if changed then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, normalized)
    end
  end),
})

-- on term open: close with q
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

-- in noice buffers: map "r" to reload
vim.api.nvim_create_autocmd("FileType", {
  pattern = "noice",
  callback = function(event)
    vim.keymap.set("n", "r", function()
      require("noice").cmd("all")
    end, {
      buffer = event.buf,
      silent = true,
      desc = "Refresh Noice console",
    })
  end,
})

