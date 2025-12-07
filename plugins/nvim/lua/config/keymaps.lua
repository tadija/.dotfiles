-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local dap = require("dap")
local my = require("config.my")
local snacks = require("snacks")
local util = require("lazyvim.util")
local wk = require("which-key")

local del = vim.keymap.del
local map = vim.keymap.set

-- extend built-in "search" keymap
map("n", "<leader>sk", function() snacks.picker.keymaps() end, { desc = "[S]earch [K]eymaps" })

-- file browser
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- resize splits in all directions
map("n", "<C-A-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase Width" })
map("n", "<C-A-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-A-j>", "<cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-A-k>", "<cmd>resize -2<CR>", { desc = "Decrease Height" })

-- terminals
local term = snacks.terminal

-- project root
map({ "n", "t" }, "<A-1>", function()
  term.toggle(nil, { count = 101, cwd = vim.loop.cwd(), win = { position = "left" } })
end, { desc = "Terminal (Project)" })
-- home
map({ "n", "t" }, "<A-2>", function()
  term.toggle(nil, { count = 102, cwd = vim.loop.os_homedir(), win = { position = "float" } })
end, { desc = "Terminal (Home)" })
-- current file dir
map({ "n", "t" }, "<A-3>", function()
  term.toggle(nil, { count = 103, cwd = my.current_buf_dir(), win = { position = "right" } })
end, { desc = "Terminal (Buffer)" })
-- default 
map({ "n", "t" }, "<A-4>", "<C-/>", { desc = "Terminal (Default)", remap = true })

-- my keymaps
wk.add({
  { "<leader>m", group = "my", mode = { "n", "v" } },
  map("n", "<leader>ma", "ggVG", { desc = "Select all", remap = true }),
  map("n", "<leader>mi", "gg=G", { desc = "Indent all", remap = true }),
  map("n", "<leader>my", ":%y+<CR>", { desc = "Yank all" }),
  map("n", "<leader>mc", "<leader>sna", { desc = "Show Console", remap = true }),
  map("n", "<leader>mt", "<leader>uC", { desc = "Theme Picker", remap = true }),
  map("n", "<leader>mk", "gcc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mk", "gc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mf", vim.lsp.buf.format, { desc = "Format Selection" }),
  map("n", "<leader>mr", vim.lsp.buf.rename, { desc = "Rename Symbol" }),
  map("n", "<leader>mq", "<cmd>silent! wa | silent! qa!<CR>", { desc = "Save All + Quit" }),
  { "<leader>me", group = "extras", mode = { "n", "v" } },
})

-- dap
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>d.", dap.close, { desc = "Terminate Session" })
map("n", "<leader>ds", function() require("dap.ui.widgets").scopes() end, { desc = "Show Scopes" })
map({ "n", "v" }, "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" })

-- plugins/languages
my.remove_lazy_keymaps()
wk.add({
  { "<leader>l", group = "language", mode = { "n", "v" } },
  map("n", "<leader>ll", "<cmd>LangTaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>lf", "<cmd>LangTaskFormat<CR>", { desc = "Format" }),
  map("n", "<leader>lb", "<cmd>LangTaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>lt", "<cmd>LangTaskTest<CR>", { desc = "Test" }),
})

-- plugins/ai
wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  map("n", "<leader>ap", "<cmd>CodeCompanion<CR>", { desc = "Input Prompt" }),
  map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Chat" }),
  map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "All Actions" }),
  map({ "n", "v" }, "<leader>ae", function() require("codecompanion").prompt("senior") end, { desc = "Advice Expert" }),
  map({ "n", "v" }, "<leader>av", function() require("codecompanion").prompt("vibe") end, { desc = "Vibe Code" }),
  map("v", "<leader>a2", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add 2 Chat" }),
  map("x", "<leader>ap", ":'<,'>CodeCompanion ", { desc = "Prompt (selection)" }),
})

