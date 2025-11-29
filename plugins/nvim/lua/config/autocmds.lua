-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- on save: ensure every normal modifiable buffer ends in a newline
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    -- skip special buffers (e.g., help, terminal) and unmodifiable buffers
    local bufnr = args.buf
    if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
      return
    end
    -- nothing to do for empty buffers
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    if line_count == 0 then
      return
    end
    -- if the last line is not empty (i.e., no trailing newline), add one
    local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count - 1, line_count, true)[1]
    if last_line ~= "" then
      vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, true, { "" })
    end
  end,
})

-- on paste: from windows -> wsl = fix line endings
vim.api.nvim_create_autocmd({ "TextYankPost", "TextChanged", "TextChangedI" }, {
  callback = function()
    -- only run if buffer actually has CR characters
    if vim.fn.search("\r", "nw") ~= 0 then
      -- remove all carriage return characters, effectively converting CRLF to LF
      vim.cmd([[%s/\r//ge]])
    end
  end,
})

