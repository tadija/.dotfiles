-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- helper: guard of footguns
local function safe_bufname(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return nil
  end
  if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
    return nil
  end
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return nil
  end
  return path
end

-- helper: run only when buffer is safe to modify
local function on_safe_write(fn)
  return function(args)
    local path = safe_bufname(args.buf)
    if not path then
      return
    end
    fn(args.buf, path)
  end
end

-- on save: normalize CRLF and ensure trailing newline
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = on_safe_write(function(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if #lines == 0 then
      return
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

    if changed then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
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

