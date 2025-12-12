-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.autoformat = false
vim.g.lint_autocmds = false
vim.opt.fileformats = { "unix", "dos" }
vim.opt.fileformat = "unix"
vim.opt.fixendofline = true
vim.opt.endofline = true
vim.opt.guicursor:append("a:blinkon0")
vim.opt.relativenumber = true
vim.opt.number = true

