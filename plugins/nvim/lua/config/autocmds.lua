-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- fix line endings when pasting from windows -> wsl
vim.api.nvim_create_autocmd({ "TextYankPost", "TextChanged", "TextChangedI" }, {
  callback = function()
    -- only run if buffer actually has CR characters
    if vim.fn.search("\r", "nw") ~= 0 then
      vim.cmd([[%s/\r//ge]])
    end
  end,
})
