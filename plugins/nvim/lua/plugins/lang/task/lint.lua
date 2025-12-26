local M = {}

function M.run()
  require("lint").try_lint()
end

return M
