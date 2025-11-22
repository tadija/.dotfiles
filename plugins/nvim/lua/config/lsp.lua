-- monorepo root detection
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local root = client.config.root_dir or vim.loop.cwd()
    vim.b.lsp_root = root
    vim.lsp.inlay_hint.enable(false)
  end,
})

-- helper command to show current LSP root
vim.api.nvim_create_user_command("LspRoot", function()
  print(vim.b.lsp_root or "(unknown)")
end, {})

local M = {}

-- enable capabilities
M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

-- callback
M.on_attach = function() end

return M
