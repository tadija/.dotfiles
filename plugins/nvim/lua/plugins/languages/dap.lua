local dap = require("dap")
local map = vim.keymap.set

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- lldb
      dap.adapters.codelldb = dap.adapters.codelldb or {
        type = 'server',
        port = "${port}",
        executable = {
          command = 'codelldb',
          args = { "--port", "${port}" },
        },
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function ()
      require("dapui").setup()
    end,
  },
}

