return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
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
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}

