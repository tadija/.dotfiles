return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/oil.nvim",
    },
    config = function()
      require("xcodebuild").setup({
        code_coverage = {
          enabled = true,
        },
        integrations = {
          pymobiledevice = {
            enabled = true,
          },
        },
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim",
    },
    config = function()
      local xcdap = require("xcodebuild.integrations.dap")
      local map = vim.keymap.set
      local swift = require("plugins.tasks.swift")
      local wk = require("which-key")
      xcdap.setup()

      -- xcodebuild
      wk.add({
        { "<leader>mx", group = "xcodebuild", mode = { "n", "v" } },
        map("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" }),
        map("n", "<leader>mxf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" }),
        map("n", "<leader>mxb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" }),
        map("n", "<leader>mxB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" }),
        map("n", "<leader>mxr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" }),
        map("n", "<leader>mxt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" }),
        map("v", "<leader>mxt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" }),
        map("n", "<leader>mxT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" }),
        map("n", "<leader>mx.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" }),
        map("n", "<leader>mxl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" }),
        map("n", "<leader>mxc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" }),
        map("n", "<leader>mxC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" }),
        map("n", "<leader>mxe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" }),
        map("n", "<leader>mxs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" }),
        map("n", "<leader>mxp", "<cd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" }),
        map("n", "<leader>mx<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" }),
        map("n", "<leader>mxv", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" }),
        map("n", "<leader>mxx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" }),
        map("n", "<leader>mxa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" }),
      })

      -- xcodebuild dap
      wk.add({
        { "<leader>ml", group = "lldb", mode = { "n", "v" } },
        map("n", "<leader>mlb", xcdap.toggle_breakpoint, { desc = "Toggle Breakpoint" }),
        map("n", "<leader>mlB", xcdap.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" }),
        map("n", "<leader>mld", xcdap.build_and_debug, { desc = "Build & Debug" }),
        map("n", "<leader>mlr", xcdap.debug_without_build, { desc = "Debug Without Building" }),
        map("n", "<leader>mlt", xcdap.debug_tests, { desc = "Debug Tests" }),
        map("n", "<leader>mlT", xcdap.debug_class_tests, { desc = "Debug Class Tests" }),
        map("n", "<leader>ml.", xcdap.terminate_session, { desc = "Terminate Debugger" }),
      })

      -- swift cmds
      wk.add({
        { "<leader>ms", group = "swift", mode = { "n", "v" } },
        map("n", "<leader>msb", swift.build, { desc = "Swift Build" }),
        map("n", "<leader>msr", swift.repl, { desc = "Swift REPL" }),
        map("n", "<leader>msR", swift.run, { desc = "Swift Run" }),
        map("n", "<leader>mst", swift.test, { desc = "Swift Test" }),
        map("n", "<leader>msc", swift.clean, { desc = "Swift Clean" }),
        map("n", "<leader>msu", swift.update, { desc = "Swift Update" }),
      })
    end,
  },
}

