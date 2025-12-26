local M = {}

function M.run()
  require("conform").format({ async = false, lsp_fallback = true })
end

return M
