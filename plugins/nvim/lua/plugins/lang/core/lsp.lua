local M = {}

local function cmp_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok and blink.get_lsp_capabilities then
    return blink.get_lsp_capabilities()
  end
  return {}
end

-- enable capabilities
M.get_capabilities = function()
  return vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_capabilities()
  )
end

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
