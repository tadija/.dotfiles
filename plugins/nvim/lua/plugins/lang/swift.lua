local M = {}

local function term(cmd)
  vim.cmd("split | terminal " .. cmd)
end

M.build = function()
  term("swift build")
end

M.repl = function()
  term("swift repl")
end

M.run = function()
  term("swift run")
end

M.test = function()
  term("swift test")
end

M.package_clean = function()
  term("swift package clean")
end

M.package_update = function()
  term("swift package update")
end

return M

