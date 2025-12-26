local util = require("plugins.lang.task.util")

local M = {}

local function command(ctx)
  local ft = ctx.ft
  local fname = ctx.fname or ""
  local root = ctx.root

  if ft == "cs" or ft == "fsharp" then
    return "dotnet build"
  elseif ft == "elixir" then
    return "mix compile"
  elseif ft == "fortran" then
    return "gfortran " .. fname .. " -o out"
  elseif ft == "haskell" then
    return "stack build"
  elseif ft == "go" then
    return "go build ./..."
  elseif ft == "java" then
    return "javac " .. fname
  elseif ft == "javascript" or ft == "typescript" or ft == "astro" or ft == "vue" then
    return util.js_helper(root, "build")
  elseif ft == "kotlin" then
    return "kotlinc " .. fname .. " -d out.jar"
  elseif ft == "lua" then
    return "luacheck " .. fname
  elseif ft == "perl" then
    return "perl -c " .. fname
  elseif ft == "php" then
    if util.is_laravel(root) then
      return "php artisan test"
    end
    return "php -l " .. fname
  elseif ft == "python" then
    return "python3 -m py_compile " .. fname
  elseif ft == "ruby" then
    if util.is_rails(root) then
      return "bin/rails test"
    end
    return "ruby -c " .. fname
  elseif ft == "rust" then
    return "cargo build"
  elseif ft == "scala" then
    return "sbt compile"
  elseif ft == "sql" then
    return "sqlfluff lint --dialect tsql ."
  elseif ft == "swift" then
    if vim.fn.filereadable(root .. "/Package.swift") == 1 then
      return "swift build"
    elseif vim.fn.glob(root .. "/*.xcodeproj") ~= "" then
      return "xcodebuild -quiet"
    end
  elseif ft == "zig" then
    return "zig build"
  end
end

function M.run(opts)
  local ctx = util.current_context(opts)
  local cmd = command(ctx)
  if not cmd then
    error("No build command for filetype " .. (ctx.ft or ""))
  end
  util.term(cmd, ctx.root)
end

return M
