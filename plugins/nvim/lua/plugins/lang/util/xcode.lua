return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/oil.nvim",
    },
    init = function()
      vim.api.nvim_create_user_command("XcodeOpen", function()
        local util = require("lazyvim.util")
        local root = util.root.get() or vim.loop.cwd()
        vim.fn.jobstart({ "xed", root }, { detach = true })
      end, { desc = "Open project in Xcode" })
    end,
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
      xcdap.setup()
    end,
  },
}

