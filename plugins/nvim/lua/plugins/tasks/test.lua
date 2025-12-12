local util = require("plugins.tasks.util")

local M = {}

local function command(ctx)
  local ft = ctx.ft
  local fname = ctx.fname or ""
  local root = ctx.root

  if ft == "cs" or ft == "fsharp" then
    return "dotnet test"
  elseif ft == "elixir" then
    return "mix test"
  elseif ft == "fortran" then
    return "echo 'No standard test runner'"
  elseif ft == "haskell" then
    return "stack test"
  elseif ft == "go" then
    return "go test ./..."
  elseif ft == "java" then
    return "java " .. vim.fn.fnamemodify(fname, ":t:r")
  elseif ft == "javascript" or ft == "typescript" or ft == "astro" or ft == "vue" then
    return util.js_helper(root, "test")
  elseif ft == "kotlin" then
    return "kotlinc -script " .. fname
  elseif ft == "lua" then
    return "busted --filter " .. vim.fn.fnamemodify(fname, ":t:r")
  elseif ft == "perl" then
    return "prove --verbose"
  elseif ft == "php" then
    if util.is_laravel(root) then
      return "php artisan test"
    end
    return vim.fn.executable("phpunit") == 1 and "phpunit"
  elseif ft == "python" then
    return vim.fn.executable("pytest") == 1 and "pytest" or "python3 -m unittest"
  elseif ft == "ruby" then
    if util.is_rails(root) then
      return "bin/rails test"
    elseif vim.fn.filereadable(root .. "/Gemfile") == 1 then
      return "bundle exec rspec"
    elseif vim.fn.executable("rspec") == 1 then
      return "rspec"
    end
  elseif ft == "rust" then
    return "cargo test"
  elseif ft == "scala" then
    return "sbt test"
  elseif ft == "sql" then
    return "sqlfluff lint --dialect tsql ."
  elseif ft == "swift" then
    if vim.fn.filereadable(root .. "/Package.swift") == 1 then
      return "swift test"
    elseif vim.fn.glob(root .. "/*.xcodeproj") ~= "" then
      return "xcodebuild test -quiet"
    end
  elseif ft == "zig" then
    return "zig build test"
  end
end

function M.run(opts)
  local ctx = util.current_context(opts)
  local cmd = command(ctx)
  if not cmd then
    error("No test command for filetype " .. (ctx.ft or ""))
  end
  util.term(cmd, ctx.root)
end

return M
