local M = {}

function M.resolve_root(root)
  if root and root ~= "" then
    return root
  end
  local workspaces = vim.lsp.buf.list_workspace_folders()
  if workspaces and workspaces[1] then
    return workspaces[1]
  end
  return vim.loop.cwd()
end

function M.buffer_name()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    name = vim.fn.expand("%:p")
  end
  return name or ""
end

function M.current_context(opts)
  opts = opts or {}
  return {
    ft = opts.ft or vim.bo.filetype,
    fname = opts.fname or M.buffer_name(),
    root = M.resolve_root(opts.root),
  }
end

function M.is_rails(root)
  root = M.resolve_root(root)
  return vim.fn.filereadable(root .. "/bin/rails") == 1
end

function M.is_laravel(root)
  root = M.resolve_root(root)
  return vim.fn.filereadable(root .. "/artisan") == 1
end

function M.js_helper(root, script)
  root = M.resolve_root(root)
  if vim.fn.filereadable(root .. "/package.json") == 1 then
    return "npm run " .. script
  elseif vim.fn.filereadable(root .. "/bun.lockb") == 1 then
    return "bun run " .. script
  elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
    return "yarn " .. script
  end
end

function M.elapsed(start)
  return string.format("%.2fs", (vim.loop.hrtime() - start) / 1e9)
end

function M.notify_ok(task, duration)
  vim.notify(("✅ %s completed in %s"):format(task, duration), vim.log.levels.INFO)
end

function M.notify_fail(task, msg)
  vim.notify(("❌ %s failed: %s"):format(task, msg or "unknown error"), vim.log.levels.ERROR)
end

local function cd_prefix(root)
  if not root or root == "" then
    return ""
  end
  return "cd " .. vim.fn.shellescape(root) .. " && "
end

function M.term(cmd, root)
  if not cmd or cmd == "" then
    return
  end
  vim.cmd("split | terminal " .. cd_prefix(root) .. cmd)
end

return M
