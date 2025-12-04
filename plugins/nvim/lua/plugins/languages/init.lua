-- lua/plugins/languages.lua
-- Coordinator that wires syntax, servers, and task helpers together.

local lsp = require("plugins.languages.lsp")
local syntax = require("plugins.languages.syntax")
local servers = require("plugins.languages.servers")
local tasks = require("plugins.languages.tasks")

tasks.setup()

local function lsp_spec()
  return {
    "neovim/nvim-lspconfig",
    version = false,
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

local specs = { lsp_spec() }
vim.list_extend(specs, syntax.get_specs())

return {
  specs,
}

