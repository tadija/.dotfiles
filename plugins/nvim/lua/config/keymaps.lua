-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local dap = require("dap")
local dapui = require("dapui")
local cc = require("codecompanion")
local ai_utils = require("plugins.ai.utils")
local my = require("config.my")
local noice = require("noice")
local snacks = require("snacks")
local swift = require("plugins.languages.utils.swift")
local toggles = require("plugins.utils.toggles")
local xcdap = require("xcodebuild.integrations.dap")
local util = require("lazyvim.util")
local wk = require("which-key")

local map = vim.keymap.set
local buf = vim.lsp.buf

-- file browser
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- resize splits in all directions
map("n", "<C-A-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase Width" })
map("n", "<C-A-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-A-j>", "<cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-A-k>", "<cmd>resize -2<CR>", { desc = "Decrease Height" })

-- my keymaps
my.remove_lazy_keymaps()
wk.add({
  { "<leader>m", group = "my", icon = "", mode = { "n", "v" } },
  { "<leader>me", group = "extras", icon = "", mode = { "n", "v" } },

  map("n", "<leader>mc", "<leader>uC", { desc = "Select Colorscheme", remap = true }),
  map("n", "<leader>mr", "<cmd>SetRandomColorScheme<CR>", { desc = "Set Random Colorscheme" }),
  map("n", "<leader>mq", "<cmd>silent! wa | silent! qa!<CR>", { desc = "Save All & Quit" }),
  map("n", "<leader>m.", "<cmd>silent! qa!<CR>", { desc = "Quit All Without Saving" }),

  -- all
  { "<leader>ma", group = "all", icon = "󰈚", mode = { "n", "v" } },
  map("n", "<leader>mai", "gg=G", { desc = "Indent all" }),
  map("n", "<leader>mad", ":%d+<CR>", { desc = "Delete all" }),
  map("n", "<leader>mav", "ggVG", { desc = "Select all" }),
  map("n", "<leader>may", ":%y+<CR>", { desc = "Yank all" }),
  map("n", "<leader>mas", "<cmd>silent! wa<CR>", { desc = "Save All" }),

  -- dashboard
  { "<leader>md", group = "dashboard", mode = { "n", "v" } },
  map("n", "<leader>mdc", function() snacks.picker.commands() end, { desc = "Commands" }),
  map("n", "<leader>mdk", function() snacks.picker.keymaps() end, { desc = "Keymaps" }),
  map("n", "<leader>mdh", function() snacks.picker.help() end, { desc = "Help" }),
  map("n", "<leader>mdl", ":Lazy<CR>", { desc = "Lazy" }),
  map("n", "<leader>mdx", ":LazyExtras<CR>", { desc = "Lazy Extras" }),
  map("n", "<leader>mdH", ":LazyHealth<CR>", { desc = "Lazy Health" }),
  map("n", "<leader>mdm", ":Mason<CR>", { desc = "Mason" }),
  map("n", "<leader>mdo", ":MasonLog<CR>", { desc = "Mason Log" }),

  -- swift
  { "<leader>ms", group = "swift", icon = "󰛥", mode = { "n", "v" } },
  map("n", "<leader>msb", swift.build, { desc = "Swift Build" }),
  map("n", "<leader>msr", swift.repl, { desc = "Swift REPL" }),
  map("n", "<leader>msR", swift.run, { desc = "Swift Run" }),
  map("n", "<leader>mst", swift.test, { desc = "Swift Test" }),
  map("n", "<leader>msc", swift.clean, { desc = "Swift Clean" }),
  map("n", "<leader>msu", swift.update, { desc = "Swift Update" }),

  -- tasks
  { "<leader>mt", group = "tasks", icon = "", mode = { "n", "v" } },
  map("n", "<leader>mtb", "<cmd>TaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>mtt", "<cmd>TaskTest<CR>", { desc = "Test" }),
  map("n", "<leader>mtl", "<cmd>TaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>mtf", "<cmd>TaskFormat<CR>", { desc = "Format" }),

  -- toggles
  { "<leader>mg", group = "toggles", mode = { "n", "v" } },
  map("n", "<leader>mgc", toggles.toggle_completions, { desc = "Toggle Completions" }),
  map("n", "<leader>mgd", toggles.toggle_diagnostics, { desc = "Toggle Diagnostics" }),
  map("n", "<leader>mgf", toggles.toggle_auto_format, { desc = "Toggle Auto-Format" }),
  map("n", "<leader>mgl", toggles.toggle_lsp, { desc = "Toggle LSP" }),
  map("n", "<leader>mgz", toggles.toggle_zen, { desc = "Toggle Zen-Mode" }),
})

-- dap
wk.add({
  { "<leader>d", group = "debug/profile", mode = { "n", "v" } },
  map("n", "<leader>dc", dap.continue, { desc = "Continue" }),
  map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" }),
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
  map({ "n", "v" }, "<leader>de", function() dapui.eval() end, { desc = "Eval" }),
  map("n", "<leader>df", function() dapui.float_element() end, { desc = "Float Element" }),
  map({ "n", "v" }, "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" }),
  map("n", "<leader>do", dap.step_over, { desc = "Step Over" }),
  map("n", "<leader>di", dap.step_into, { desc = "Step Into" }),
  map("n", "<leader>dO", dap.step_out, { desc = "Step Out" }),
  map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" }),
  map("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle UI" }),
  map("n", "<leader>d.", dap.close, { desc = "Terminate Session" }),
})

-- lsp
wk.add({
  { "<leader>l", group = "lsp", mode = { "n", "v" } },
  map("n", "<leader>lI", ":LspInfo<CR>", { desc = "Lsp Info" }),
  map("n", "<leader>lL", ":LspLog<CR>", { desc = "Lsp Log" }),
  map("n", "<leader>lR", ":LspRestart<CR>", { desc = "Lsp Restart" }),
  map("n", "<leader>la", buf.code_action, { desc = "Code Action" }),
  map("v", "<leader>lf", buf.format, { desc = "Format Selection" }),
  map("n", "<leader>lr", buf.rename, { desc = "Rename Symbol" }),
  map("n", "<leader>lc", buf.references, { desc = "Show References" }),
  map("n", "<leader>ld", buf.definition, { desc = "Go to Definition" }),
  map("n", "<leader>lD", buf.declaration, { desc = "Go to Declaration" }),
  map("n", "<leader>lt", buf.type_definition, { desc = "Go to Type Definition" }),
  map("n", "<leader>li", buf.implementation, { desc = "Go to Implementation" }),
  map("n", "<leader>lh", buf.hover, { desc = "Hover Documentation" }),
  map("n", "<leader>ls", buf.signature_help, { desc = "Signature Help" }),
})

-- terminals
local term = snacks.terminal

map({ "n", "t" }, "<A-1>", function()
  my.close_explorer()
  term.toggle(nil, { count = 101, cwd = my.current_buf_dir(), win = { position = "left" } })
end, { desc = "Terminal (Current)" })

map({ "n", "t" }, "<A-2>", function()
  term.toggle(nil, { count = 102, cwd = vim.loop.cwd(), win = { position = "float" } })
end, { desc = "Terminal (Floating)" })

map({ "n", "t" }, "<A-3>", function()
  term.toggle(nil, { count = 103, cwd = vim.loop.cwd(), win = { position = "right" } })
end, { desc = "Terminal" })

map({ "n", "t" }, "<A-4>", "<C-/>", { desc = "Terminal (Default)", remap = true })

-- plugins/ai
wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  map({ "n", "v" }, "<leader>A", function() ai_utils.toggle_chat() end, { desc = "Toggle AI Chat" }),
  map({ "x" }, "<leader>a2", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add 2 Chat" }),
  map({ "x" }, "<leader>a+", ai_utils.send_selection_to_many, { desc = "Send to many" }),
  map({ "n" }, "<leader>a+", ai_utils.send_chat_to_many, { desc = "Chat with many" }),
  map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "All Actions" }),
  map({ "n", "v" }, "<leader>ac", function() ai_utils.toggle_chat() end, { desc = "Chat" }),
  map({ "n", "v" }, "<leader>aC", ai_utils.chat_select_and_toggle, { desc = "Chat (Select)" }),
  map({ "n" }, "<leader>ai", "<cmd>CodeCompanion<CR>", { desc = "Inline" }),
  map({ "x" }, "<leader>ai", ":'<,'>CodeCompanion", { desc = "Inline (with selection)" }),
  map({ "n", "v" }, "<leader>aI", ai_utils.prompt_select_and_run, { desc = "Inline (Select)" }),
  map({ "n", "v" }, "<leader>am", ai_utils.cmd_prompt, { desc = "Cmd" }),
  map({ "n", "v" }, "<leader>aM", ai_utils.cmd_select_and_run, { desc = "Cmd (Select)" }),
  map({ "n", "v" }, "<leader>ae", function() cc.prompt("senior") end, { desc = "Advice Expert [chat]" }),
  map({ "n", "v" }, "<leader>av", function() cc.prompt("vibe") end, { desc = "Vibe Code [inline]" }),
})
ai_utils.refresh_adapter_labels()

-- plugins/xcode
wk.add({
  map("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Toggle Xcodebuild" }),

  { "<leader>mx", group = "xcode", mode = { "n", "v" } },
  map("n", "<leader>mx.", "<cmd>XcodeOpen<cr>", { desc = "Open in Xcode" }),
  map("n", "<leader>mxa", "<cmd>XcodebuildPicker<cr>", { desc = "All Xcodebuild Actions" }),
  map("n", "<leader>mxb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" }),
  map("n", "<leader>mxd", xcdap.build_and_debug, { desc = "Debug Project" }),
  map("n", "<leader>mxr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Run Project" }),
  map("n", "<leader>mxs", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" }),
  map("n", "<leader>mxq", xcdap.terminate_session, { desc = "Stop Running" }),
  map("n", "<leader>mxx", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcodebuild Logs" }),

  { "<leader>mxl", group = "lldb", mode = { "n", "v" } },
  map("n", "<leader>mxlb", xcdap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
  map("n", "<leader>mxlB", xcdap.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" }),
  map("n", "<leader>mxld", xcdap.build_and_debug, { desc = "Build & Debug" }),
  map("n", "<leader>mxlr", xcdap.debug_without_build, { desc = "Debug Without Building" }),
  map("n", "<leader>mxlt", xcdap.debug_tests, { desc = "Debug Tests" }),
  map("n", "<leader>mxlT", xcdap.debug_class_tests, { desc = "Debug Class Tests" }),
  map("n", "<leader>mxl.", xcdap.terminate_session, { desc = "Terminate Debugger" }),

  { "<leader>mxt", group = "tests", mode = { "n", "v" } },
  map("n", "<leader>mxtb", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" }),
  map("n", "<leader>mxtr", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" }),
  map("v", "<leader>mxts", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" }),
  map("n", "<leader>mxtn", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" }),
  map("n", "<leader>mxtl", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" }),
  map("n", "<leader>mxtc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" }),
  map("n", "<leader>mxtC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" }),
  map("n", "<leader>mxte", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" }),

{ "<leader>mxo", group = "other", mode = { "n", "v" } },
  map("n", "<leader>mxop", "<cd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" }),
  map("n", "<leader>mxo<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" }),
  map("n", "<leader>mxoa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" }),
  map("n", "<leader>mxos", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" }),
  map("n", "<leader>mxop", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" }),
  map("n", "<leader>mxoq", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" }),
})

-- move noice from search (s) into diagnostics (x)
my.remove_noice_keymaps()
wk.add({
  { "<leader>xn", group = "noice", mode = { "n", "v" } },
  map("n", "<leader>xnl", function() noice.cmd("last") end, { desc = "Noice Last Message" }),
  map("n", "<leader>xnh", function() noice.cmd("history") end, { desc = "Noice History" }),
  map("n", "<leader>xna", function() noice.cmd("all") end, { desc = "Noice All" }),
  map("n", "<leader>xnd", function() noice.cmd("dismiss") end, { desc = "Dismiss All" }),
  map("n", "<leader>xnp", function() noice.cmd("pick") end, { desc = "Noice Picker" }),
})

