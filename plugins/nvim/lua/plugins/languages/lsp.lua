local M = {}

-- enable capabilities
M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

-- helper command to show current LSP root
vim.api.nvim_create_user_command("LspRoot", function()
  print(vim.b.lsp_root or "(unknown)")
end, {})

-- callback
M.on_attach = function(client, bufnr)
  local root = (client and client.config and client.config.root_dir) or vim.loop.cwd()
  vim.api.nvim_buf_set_var(bufnr, "lsp_root", root)
end

return M
