local M = {}

local function term(cmd)
  vim.cmd("split | terminal " .. cmd)
end

M.bundle_install = function()
  term("bundle install")
end

M.bundle_update = function()
  term("bundle update")
end

M.rails_about = function()
  term("rails about")
end

M.rails_console = function()
  term("rails console")
end

M.rails_console_db = function()
  term("rails dbconsole")
end

M.rails_server = function()
  term("rails server")
end

M.rails_test = function()
  term("rails test")
end

return M

