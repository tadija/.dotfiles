-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local dap = require("dap")
local cc = require("codecompanion")
local my = require("config.my")
local noice = require("noice")
local snacks = require("snacks")
local util = require("lazyvim.util")
local wk = require("which-key")

local del = vim.keymap.del
local map = vim.keymap.set
local buf = vim.lsp.buf

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
  my.close_explorer() -- fix layout issue if this terminal starts when explorer is open
  term.toggle(nil, { count = 101, cwd = vim.loop.cwd(), win = { position = "left" } })
end, { desc = "Terminal (Project)" })
map({ "n", "t" }, "<A-2>", function()
  term.toggle(nil, { count = 102, cwd = vim.loop.cwd(), win = { position = "float" } })
end, { desc = "Terminal (Home)" })

-- current file dir
map({ "n", "t" }, "<A-3>", function()
  term.toggle(nil, { count = 103, cwd = my.current_buf_dir(), win = { position = "right" } })
end, { desc = "Terminal (Buffer)" })

-- default 
map({ "n", "t" }, "<A-4>", "<C-/>", { desc = "Terminal (Default)", remap = true })

-- my keymaps
my.remove_noice_keymaps()
wk.add({
  { "<leader>m", group = "my", icon = "", mode = { "n", "v" } },
  { "<leader>me", group = "extras", icon = "", mode = { "n", "v" } },

  { "<leader>ma", group = "all", icon = "󰈚", mode = { "n", "v" } },
  map("n", "<leader>mas", "ggVG", { desc = "Select all" }),
  map("n", "<leader>mai", "gg=G", { desc = "Indent all" }),
  map("n", "<leader>may", ":%y+<CR>", { desc = "Yank all" }),
  map("n", "<leader>mad", ":%d+<CR>", { desc = "Delete all" }),

  { "<leader>mi", group = "install/update", mode = { "n", "v" } },
  map("n", "<leader>mil", ":Lazy<CR>", { desc = "Lazy" }),
  map("n", "<leader>mie", ":LazyExtras<CR>", { desc = "Lazy Extras" }),
  map("n", "<leader>mih", ":LazyHealth<CR>", { desc = "Lazy Health" }),
  map("n", "<leader>mim", ":Mason<CR>", { desc = "Mason" }),
  map("n", "<leader>mio", ":MasonLog<CR>", { desc = "Mason Log" }),

  map("n", "<leader>mt", "<leader>uC", { desc = "Theme Picker", remap = true }),
  map("n", "<leader>mk", "gcc", { desc = "Toggle Comment", remap = true }),
  map("v", "<leader>mk", "gc", { desc = "Toggle Comment", remap = true }),
  map("n", "<leader>mS", "<cmd>silent! wa<CR>", { desc = "Save All" }),
  map("n", "<leader>mq", "<cmd>silent! wa | silent! qa!<CR>", { desc = "Save All + Quit" }),
})

-- dap
wk.add({
  { "<leader>d", group = "debug/profiler", mode = { "n", "v" } },
  map("n", "<leader>dc", dap.continue, { desc = "Continue" }),
  map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" }),
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
  map("n", "<leader>do", dap.step_over, { desc = "Step Over" }),
  map("n", "<leader>di", dap.step_into, { desc = "Step Into" }),
  map("n", "<leader>dO", dap.step_out, { desc = "Step Out" }),
  map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" }),
  map("n", "<leader>d.", dap.close, { desc = "Terminate Session" }),
  map("n", "<leader>ds", function() require("dap.ui.widgets").scopes() end, { desc = "Show Scopes" }),
  map({ "n", "v" }, "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" }),
})

-- lsp
wk.add({
  { "<leader>ls", group = "lsp", mode = { "n", "v" } },
  map("n", "<leader>lsI", ":LspInfo<CR>", { desc = "Lsp Info" }),
  map("n", "<leader>lsL", ":LspLog<CR>", { desc = "Lsp Log" }),
  map("n", "<leader>lsR", ":LspRestart<CR>", { desc = "Lsp Restart" }),
  map("n", "<leader>lsa", buf.code_action, { desc = "Code Action" }),
  map("v", "<leader>lsf", buf.format, { desc = "Format Selection" }),
  map("n", "<leader>lsr", buf.rename, { desc = "Rename Symbol" }),
  map("n", "<leader>lsc", buf.references, { desc = "Show References" }),
  map("n", "<leader>lsd", buf.definition, { desc = "Go to Definition" }),
  map("n", "<leader>lsD", buf.declaration, { desc = "Go to Declaration" }),
  map("n", "<leader>lst", buf.type_definition, { desc = "Go to Type Definition" }),
  map("n", "<leader>lsi", buf.implementation, { desc = "Go to Implementation" }),
  map("n", "<leader>lsh", buf.hover, { desc = "Hover Documentation" }),
  map("n", "<leader>lss", buf.signature_help, { desc = "Signature Help" }),
})

-- move noice into diagnostics (x)
wk.add({
  { "<leader>xn", group = "noice", mode = { "n", "v" } },
  map("n", "<leader>xnl", function() noice.cmd("last") end, { desc = "Noice Last Message" }),
  map("n", "<leader>xnh", function() noice.cmd("history") end, { desc = "Noice History" }),
  map("n", "<leader>xna", function() noice.cmd("all") end, { desc = "Noice All" }),
  map("n", "<leader>xnd", function() noice.cmd("dismiss") end, { desc = "Dismiss All" }),
  map("n", "<leader>xnp", function() noice.cmd("pick") end, { desc = "Noice Picker" }),
})

-- plugins/languages
my.remove_lazy_keymaps()
wk.add({
  { "<leader>l", group = "language", icon = "", mode = { "n", "v" } },
  map("n", "<leader>ll", "<cmd>LangTaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>lf", "<cmd>LangTaskFormat<CR>", { desc = "Format" }),
  map("n", "<leader>lb", "<cmd>LangTaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>lt", "<cmd>LangTaskTest<CR>", { desc = "Test" }),
})

-- plugins/ai
wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  map("n", "<leader>A", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle AI Chat" }),
  map("n", "<leader>ap", "<cmd>CodeCompanion<CR>", { desc = "Input Prompt" }),
  map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "All Actions" }),
  map({ "n", "v" }, "<leader>ae", function() cc.prompt("senior") end, { desc = "Advice Expert" }),
  map({ "n", "v" }, "<leader>av", function() cc.prompt("vibe") end, { desc = "Vibe Code" }),
  map("v", "<leader>a2", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add 2 Chat" }),
  map("x", "<leader>ap", ":'<,'>CodeCompanion ", { desc = "Prompt (selection)" }),
})

