-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local wk = require("which-key")
local map = vim.keymap.set

-- extend built-in "file" keymap
map("n", "<leader>fa", "ggVG", { desc = "Select all" })
map("n", "<leader>fi", "gg=G", { desc = "Indent all" })
map("n", "<leader>fy", ":%y+<CR>", { desc = "Yank all" })

-- extend built-in "search" keymap
map("n", "<leader>sk", function()
  require("snacks").picker.keymaps()
end, { desc = "[S]earch [K]eymaps" })

-- resize panes in all directions
map("n", "<C-M-h>", "<Cmd>vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-M-l>", "<Cmd>vertical resize +2<CR>", { desc = "Resize right" })
map("n", "<C-M-j>", "<Cmd>resize +2<CR>", { desc = "Resize down" })
map("n", "<C-M-k>", "<Cmd>resize -2<CR>", { desc = "Resize up" })

-- my
wk.add({
  { "<leader>m", group = "my", mode = { "n", "v" } },
  map("n", "<leader>mk", "gcc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mk", "gc", { desc = "Toggle Comment", remap = true }),
  map("n", "<leader>ms", "<cmd>wall<cr>", { desc = "Save all files" }),
  map("n", "<leader>mq", "<cmd>wqa<cr>", { desc = "Save all and quit" }),
})

-- languages
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>L")
wk.add({
  { "<leader>l", group = "langs", mode = { "n", "v" } },
  map("n", "<leader>ll", "<cmd>LangTaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>lf", "<cmd>LangTaskFormat<CR>", { desc = "Format" }),
  map("n", "<leader>lb", "<cmd>LangTaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>lt", "<cmd>LangTaskTest<CR>", { desc = "Test" }),
})

-- codecompanion
wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Actions" }),
  map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Chat" }),
  map({ "n", "v" }, "<leader>ap", "<cmd>CodeCompanion<cr>", { desc = "Prompt" }),
  map("v", "<leader>a2", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add 2 Chat" }),
})
