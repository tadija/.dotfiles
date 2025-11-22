-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local snacks = require("snacks")
local wk = require("which-key")
local map = vim.keymap.set

-- extend built-in "search" keymap
map("n", "<leader>sk", function()
  snacks.picker.keymaps()
end, { desc = "[S]earch [K]eymaps" })

-- my custom shortcuts
wk.add({
  { "<leader>m", group = "my", mode = { "n", "v" } },
  map("n", "<leader>ma", "ggVG", { desc = "Select all" }),
  map("n", "<leader>mi", "gg=G", { desc = "Indent all" }),
  map("n", "<leader>my", ":%y+<CR>", { desc = "Yank all" }),
  map("n", "<leader>mk", "gcc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mk", "gc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mf", vim.lsp.buf.format, { desc = "Format selection" }),
  map("n", "<leader>mr", vim.lsp.buf.rename, { desc = "Rename Symbol" }),
  map("n", "<leader>mq", "<cmd>silent! wa | silent! qa!<CR>", { desc = "Save All + Quit" }),
})

-- resize splits in all directions
map("n", "<C-A-l>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Width" })
map("n", "<C-A-h>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-A-j>", "<Cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-A-k>", "<Cmd>resize -2<CR>", { desc = "Decrease Height" })

-- terminals
local term = snacks.terminal
map({ "n", "t" }, "<M-1>", function() term.toggle(nil, { cwd = vim.fn.expand("~"), win = { position = "top" } }) end, { desc = " Terminal (Global)" })
map({ "n", "t" }, "<M-2>", function() term.toggle(nil, { cwd = vim.loop.cwd(), win = { position = "float" } }) end, { desc = "Terminal (Project)" })

-- plugins/languages
vim.keymap.del("n", "<leader>l") -- Lazy
vim.keymap.del("n", "<leader>L") -- LazyVim Changelog
wk.add({
  { "<leader>l", group = "langs", mode = { "n", "v" } },
  map("n", "<leader>ll", "<cmd>LangTaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>lf", "<cmd>LangTaskFormat<CR>", { desc = "Format" }),
  map("n", "<leader>lb", "<cmd>LangTaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>lt", "<cmd>LangTaskTest<CR>", { desc = "Test" }),
})

-- plugins/ai
wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  map("n", "<leader>ap", "<cmd>CodeCompanion<CR>", { desc = "Prompt" }),
  map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Chat" }),
  map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "Actions" }),
  map({ "n", "v" }, "<leader>av", function() require("codecompanion").prompt("vibe") end, { desc = "Vibe Code" }),
  map("v", "<leader>a2", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add 2 Chat" }),
  map("x", "<leader>ap", ":'<,'>CodeCompanion ", { desc = "Prompt (selection)" }),
})
