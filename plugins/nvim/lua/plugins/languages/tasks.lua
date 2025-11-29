-- lua/plugins/languages/tasks.lua
-- Build/test helpers and LangTask commands.

local M = {}

local Task = {
  BUILD = "build",
  TEST = "test",
  LINT = "lint",
  FORMAT = "format",
}

-- Root helpers ---------------------------------------------------------------
local function resolve_root(root)
  if root and root ~= "" then
    return root
  end
  local workspaces = vim.lsp.buf.list_workspace_folders()
  if workspaces and workspaces[1] then
    return workspaces[1]
  end
  return vim.loop.cwd()
end

local function is_rails(root)
  root = resolve_root(root)
  return vim.fn.filereadable(root .. "/bin/rails") == 1
end

local function is_laravel(root)
  root = resolve_root(root)
  return vim.fn.filereadable(root .. "/artisan") == 1
end

local function js_helper(root, script)
  root = resolve_root(root)
  if vim.fn.filereadable(root .. "/package.json") == 1 then
    return "npm run " .. script
  elseif vim.fn.filereadable(root .. "/bun.lockb") == 1 then
    return "bun run " .. script
  elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
    return "yarn " .. script
  end
end

-- Build command --------------------------------------------------------------
local function build_command(ctx)
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
    return js_helper(root, "build")
  elseif ft == "kotlin" then
    return "kotlinc " .. fname .. " -d out.jar"
  elseif ft == "lua" then
    return "luacheck " .. fname
  elseif ft == "perl" then
    return "perl -c " .. fname
  elseif ft == "php" then
    if is_laravel(root) then
      return "php artisan test"
    end
    return "php -l " .. fname
  elseif ft == "python" then
    return "python3 -m py_compile " .. fname
  elseif ft == "ruby" then
    if is_rails(root) then
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

-- Test command ---------------------------------------------------------------
local function test_command(ctx)
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
    return js_helper(root, "test")
  elseif ft == "kotlin" then
    return "kotlinc -script " .. fname
  elseif ft == "lua" then
    return "busted --filter " .. vim.fn.fnamemodify(fname, ":t:r")
  elseif ft == "perl" then
    return "prove --verbose"
  elseif ft == "php" then
    if is_laravel(root) then
      return "php artisan test"
    end
    return vim.fn.executable("phpunit") == 1 and "phpunit"
  elseif ft == "python" then
    return vim.fn.executable("pytest") == 1 and "pytest" or "python3 -m unittest"
  elseif ft == "ruby" then
    if is_rails(root) then
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

-- Task Runner ----------------------------------------------------------------
local function elapsed(start)
  return string.format("%.2fs", (vim.loop.hrtime() - start) / 1e9)
end

local function notify_ok(task, duration)
  vim.notify(("✅ %s completed in %s"):format(task, duration), vim.log.levels.INFO)
end

local function notify_fail(task, msg)
  vim.notify(("❌ %s failed: %s"):format(task, msg or "unknown error"), vim.log.levels.ERROR)
end

local function buffer_name()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    name = vim.fn.expand("%:p")
  end
  return name or ""
end

local function current_context(ft, fname, root)
  return {
    ft = ft or vim.bo.filetype,
    fname = fname or buffer_name(),
    root = resolve_root(root),
  }
end

local function run_task(kind)
  local start = vim.loop.hrtime()
  local ok, err = pcall(function()
    if kind == Task.LINT then
      require("lint").try_lint()
    elseif kind == Task.FORMAT then
      require("conform").format({ async = false, lsp_fallback = true })
    elseif kind == Task.BUILD then
      build_command(current_context())
    elseif kind == Task.TEST then
      test_command(current_context())
    end
  end)
  local duration = elapsed(start)
  if ok then
    notify_ok(kind, duration)
  else
    notify_fail(kind, err)
  end
end

local function register_task_commands()
  if M._tasks_registered then
    return
  end

  vim.api.nvim_create_user_command("LangTaskLint", function()
    run_task(Task.LINT)
  end, {})
  vim.api.nvim_create_user_command("LangTaskFormat", function()
    run_task(Task.FORMAT)
  end, {})
  vim.api.nvim_create_user_command("LangTaskBuild", function()
    run_task(Task.BUILD)
  end, {})
  vim.api.nvim_create_user_command("LangTaskTest", function()
    run_task(Task.TEST)
  end, {})

  M._tasks_registered = true
end

function M.setup()
  register_task_commands()
end

return M
