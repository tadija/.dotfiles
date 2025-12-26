local cmp = require("plugins.lang.core.cmp")
local dap = require("plugins.lang.core.dap")
local lsp = require("plugins.lang.core.lsp")
local servers = require("plugins.lang.core.servers")
local syntax = require("plugins.lang.core.syntax")
local utils =  require("plugins.lang.util")
local tasks = require("plugins.lang.task")

local function lsp_spec()
  return {
    "neovim/nvim-lspconfig",
    version = false,
    init = function()
      -- disable on startup
      vim.diagnostic.enable(false)
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = false
      for name, config in pairs(servers) do
        opts.servers[name] = config
      end
      opts.setup = {
        ["*"] = function(server, server_opts)
          server_opts.on_attach = function(client, bufnr)
            lsp.on_attach(client, bufnr)
          end
          server_opts.capabilities = lsp.capabilities
          require("lspconfig")[server].setup(server_opts)
        end,
      }
      return opts
    end,
  }
end

local specs = { cmp, dap, lsp_spec() }
vim.list_extend(specs, syntax.get_specs())
vim.list_extend(specs, tasks)
vim.list_extend(specs, utils)

return specs
