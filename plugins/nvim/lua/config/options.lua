-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.autoformat = false
vim.g.lint_autocmds = false
vim.opt_global.fileformats = { "unix", "dos" }
vim.opt_global.fileformat = "unix"
vim.opt_global.fixendofline = true
vim.opt_global.endofline = true
vim.opt.guicursor:append("a:blinkon0")
vim.opt.relativenumber = true
vim.opt.number = true

_G.dump = function(...)
  print(vim.inspect(...))
end

