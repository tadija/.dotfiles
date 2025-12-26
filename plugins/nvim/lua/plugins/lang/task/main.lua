local util = require("plugins.lang.task.util")
local build = require("plugins.lang.task.build")
local test = require("plugins.lang.task.test")
local lint = require("plugins.lang.task.lint")
local format = require("plugins.lang.task.format")

local M = {}

local Task = {
  BUILD = "build",
  TEST = "test",
  LINT = "lint",
  FORMAT = "format",
}

local handlers = {
  [Task.BUILD] = build.run,
  [Task.TEST] = test.run,
  [Task.LINT] = lint.run,
  [Task.FORMAT] = format.run,
}

local function run_task(kind)
  local start = vim.loop.hrtime()
  local handler = handlers[kind]
  if not handler then
    return
  end

  local ok, err = pcall(handler)
  local duration = util.elapsed(start)
  if ok then
    util.notify_ok(kind, duration)
  else
    util.notify_fail(kind, err)
  end
end

local function register(name, kind)
  vim.api.nvim_create_user_command(name, function()
    run_task(kind)
  end, {})
end

function M.setup()
  if M._tasks_registered then
    return
  end

  register("TaskBuild", Task.BUILD)
  register("TaskTest", Task.TEST)
  register("TaskLint", Task.LINT)
  register("TaskFormat", Task.FORMAT)

  M._tasks_registered = true
end

return M
