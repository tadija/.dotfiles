-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local cc = require("codecompanion")
local ai_utils = require("plugins.ai.utils")
local noice = require("noice")
local snacks = require("snacks")
local ruby = require("plugins.lang.ruby")
local swift = require("plugins.lang.swift")
local toggles = require("plugins.utils.toggles")
local util = require("lazyvim.util")
local wk = require("which-key")

local del = vim.keymap.del
local map = vim.keymap.set
local buf = vim.lsp.buf

-- helpers
local function remove_lazy_keymaps()
  del("n", "<leader>l")
  del("n", "<leader>L")
  del("n", "<leader>K")
end

local function remove_noice_keymaps()
  del("n", "<leader>snl")
  del("n", "<leader>snh")
  del("n", "<leader>sna")
  del("n", "<leader>snd")
  del("n", "<leader>snt")
  del("n", "<leader>sn")
end

-- file browser
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- resize splits in all directions
map("n", "<C-A-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase Width" })
map("n", "<C-A-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-A-j>", "<cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-A-k>", "<cmd>resize -2<CR>", { desc = "Decrease Height" })

-- terminals
local terms = require("plugins.utils.terms")
map({ "n", "t" }, "<A-1>", terms.toggle_left, { desc = "Terminal (Left)" })
map({ "n", "t" }, "<A-2>", terms.toggle_float, { desc = "Terminal (Floating)" })
map({ "n", "t" }, "<A-3>", terms.toggle_right, { desc = "Terminal (Right)" })
map({ "n", "t" }, "<A-4>", "<C-/>", { desc = "Terminal (Default)", remap = true })

-- my keymaps
remove_lazy_keymaps()
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

  -- toggles
  { "<leader>mt", group = "toggles", mode = { "n", "v" } },
  map("n", "<leader>mtc", toggles.toggle_completions, { desc = "Toggle Completions" }),
  map("n", "<leader>mtd", toggles.toggle_diagnostics, { desc = "Toggle Diagnostics" }),
  map("n", "<leader>mtf", toggles.toggle_auto_format, { desc = "Toggle Auto-Format" }),
  map("n", "<leader>mtl", toggles.toggle_lsp, { desc = "Toggle LSP" }),
  map("n", "<leader>mtz", toggles.toggle_zen, { desc = "Toggle Zen-Mode" }),
})

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

-- plugins/lang
wk.add({
  { "<leader>l", group = "lang", mode = { "n", "v" } },
})

-- dap
util.on_load("nvim-dap", function()
  local dap = require("dap")
  local dapui_ok, dapui = pcall(require, "dapui")
  local dap_widgets = require("dap.ui.widgets")

  wk.add({
    { "<leader>ld", group = "dap", mode = { "n", "v" } },
    map("n", "<leader>ldc", dap.continue, { desc = "Continue" }),
    map("n", "<leader>ldC", dap.run_to_cursor, { desc = "Run to Cursor" }),
    map("n", "<leader>ldb", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
    map({ "n", "v" }, "<leader>ldh", dap_widgets.hover, { desc = "Hover" }),
    map("n", "<leader>ldo", dap.step_over, { desc = "Step Over" }),
    map("n", "<leader>ldi", dap.step_into, { desc = "Step Into" }),
    map("n", "<leader>ldO", dap.step_out, { desc = "Step Out" }),
    map("n", "<leader>ldr", dap.repl.toggle, { desc = "Toggle REPL" }),
    map("n", "<leader>ld.", dap.close, { desc = "Terminate Session" }),
  })

  if dapui_ok then
    wk.add({
      map({ "n", "v" }, "<leader>lde", function() dapui.eval() end, { desc = "Eval" }),
      map("n", "<leader>df", function() dapui.float_element() end, { desc = "Float Element" }),
      map("n", "<leader>ldu", function() dapui.toggle() end, { desc = "Toggle UI" }),
    })
  end
end)

-- lsp
wk.add({
  { "<leader>ll", group = "lsp", mode = { "n", "v" } },
  map("n", "<leader>llI", ":LspInfo<CR>", { desc = "Lsp Info" }),
  map("n", "<leader>llL", ":LspLog<CR>", { desc = "Lsp Log" }),
  map("n", "<leader>llR", ":LspRestart<CR>", { desc = "Lsp Restart" }),
  map("n", "<leader>lla", buf.code_action, { desc = "Code Action" }),
  map("v", "<leader>llf", buf.format, { desc = "Format Selection" }),
  map("n", "<leader>llr", buf.rename, { desc = "Rename Symbol" }),
  map("n", "<leader>llc", buf.references, { desc = "Show References" }),
  map("n", "<leader>lld", buf.definition, { desc = "Go to Definition" }),
  map("n", "<leader>llD", buf.declaration, { desc = "Go to Declaration" }),
  map("n", "<leader>llt", buf.type_definition, { desc = "Go to Type Definition" }),
  map("n", "<leader>lli", buf.implementation, { desc = "Go to Implementation" }),
  map("n", "<leader>llh", buf.hover, { desc = "Hover Documentation" }),
  map("n", "<leader>lls", buf.signature_help, { desc = "Signature Help" }),
})

-- ruby
wk.add({
  { "<leader>lr", group = "ruby", icon = "", mode = { "n", "v" } },
  map("n", "<leader>lri", ruby.bundle_install, { desc = "Bundle Install" }),
  map("n", "<leader>lru", ruby.bundle_update, { desc = "Bundle Update" }),
  map("n", "<leader>lry", ruby.rails_about, { desc = "Rails About" }),
  map("n", "<leader>lrc", ruby.rails_console, { desc = "Rails Console" }),
  map("n", "<leader>lrd", ruby.rails_console_db, { desc = "Rails DB Console" }),
  map("n", "<leader>lrs", ruby.rails_server, { desc = "Rails Server" }),
  map("n", "<leader>lrt", ruby.rails_test, { desc = "Rails Test" }),
})

-- swift
wk.add({
  { "<leader>ls", group = "swift", icon = "󰛥", mode = { "n", "v" } },
  map("n", "<leader>lsb", swift.build, { desc = "Swift Build" }),
  map("n", "<leader>lsR", swift.repl, { desc = "Swift REPL" }),
  map("n", "<leader>lsr", swift.run, { desc = "Swift Run" }),
  map("n", "<leader>lst", swift.test, { desc = "Swift Test" }),
  map("n", "<leader>lsc", swift.package_clean, { desc = "Swift Package Clean" }),
  map("n", "<leader>lsu", swift.package_update, { desc = "Swift Package Update" }),
})

-- tasks
wk.add({
  { "<leader>lt", group = "tasks", icon = "", mode = { "n", "v" } },
  map("n", "<leader>ltb", "<cmd>TaskBuild<CR>", { desc = "Build" }),
  map("n", "<leader>ltt", "<cmd>TaskTest<CR>", { desc = "Test" }),
  map("n", "<leader>ltl", "<cmd>TaskLint<CR>", { desc = "Lint" }),
  map("n", "<leader>ltf", "<cmd>TaskFormat<CR>", { desc = "Format" }),
})

-- plugins/lang/util/xcode
wk.add({
  map("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Toggle Xcodebuild" }),

  { "<leader>lx", group = "xcode", mode = { "n", "v" } },
  map("n", "<leader>lx.", "<cmd>XcodeOpen<cr>", { desc = "Open in Xcode" }),
  map("n", "<leader>lxa", "<cmd>XcodebuildPicker<cr>", { desc = "All Xcodebuild Actions" }),
  map("n", "<leader>lxb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" }),
  map("n", "<leader>lxr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Run Project" }),
  map("n", "<leader>lxs", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" }),
  map("n", "<leader>lxx", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcodebuild Logs" }),

  { "<leader>lxt", group = "tests", mode = { "n", "v" } },
  map("n", "<leader>lxtb", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" }),
  map("n", "<leader>lxtr", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" }),
  map("v", "<leader>lxts", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" }),
  map("n", "<leader>lxtn", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" }),
  map("n", "<leader>lxtl", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" }),
  map("n", "<leader>lxtc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" }),
  map("n", "<leader>lxtC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" }),
  map("n", "<leader>lxte", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" }),

  { "<leader>lxo", group = "other", mode = { "n", "v" } },
  map("n", "<leader>lxop", "<cd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" }),
  map("n", "<leader>lxo<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" }),
  map("n", "<leader>lxoa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" }),
  map("n", "<leader>lxos", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" }),
  map("n", "<leader>lxop", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" }),
  map("n", "<leader>lxoq", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" }),
})

local xcdap_ok, xcdap = pcall(require, "xcodebuild.integrations.dap")
if xcdap_ok then
  wk.add({
    map("n", "<leader>lxd", xcdap.build_and_debug, { desc = "Debug Project" }),
    map("n", "<leader>lxq", xcdap.terminate_session, { desc = "Stop Running" }),

    { "<leader>lxl", group = "lldb", mode = { "n", "v" } },
    map("n", "<leader>lxlb", xcdap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
    map("n", "<leader>lxlB", xcdap.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" }),
    map("n", "<leader>lxld", xcdap.build_and_debug, { desc = "Build & Debug" }),
    map("n", "<leader>lxlr", xcdap.debug_without_build, { desc = "Debug Without Building" }),
    map("n", "<leader>lxlt", xcdap.debug_tests, { desc = "Debug Tests" }),
    map("n", "<leader>lxlT", xcdap.debug_class_tests, { desc = "Debug Class Tests" }),
    map("n", "<leader>lxl.", xcdap.terminate_session, { desc = "Terminate Debugger" }),
  })
end

-- move noice from search (s) into diagnostics (x)
remove_noice_keymaps()
wk.add({
  { "<leader>xn", group = "noice", mode = { "n", "v" } },
  map("n", "<leader>xnl", function() noice.cmd("last") end, { desc = "Noice Last Message" }),
  map("n", "<leader>xnh", function() noice.cmd("history") end, { desc = "Noice History" }),
  map("n", "<leader>xna", function() noice.cmd("all") end, { desc = "Noice All" }),
  map("n", "<leader>xnd", function() noice.cmd("dismiss") end, { desc = "Dismiss All" }),
  map("n", "<leader>xnp", function() noice.cmd("pick") end, { desc = "Noice Picker" }),
})

