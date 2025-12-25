local M = {}

local function get_snacks()
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("snacks not available", vim.log.levels.ERROR)
    return nil
  end
  return snacks
end

function M.toggle_completions()
  if not pcall(require, "blink.cmp") then
    return vim.notify("blink.cmp not loaded", vim.log.levels.WARN)
  end

  local ok_config, config = pcall(require, "blink.cmp.config")
  if not ok_config then
    return vim.notify("blink.cmp.config not available", vim.log.levels.ERROR)
  end

  local menu_cfg = config.completion and config.completion.menu
  if not menu_cfg or menu_cfg.auto_show == nil then
    return vim.notify("blink.cmp auto_show not configured", vim.log.levels.ERROR)
  end

  local function resolve(value)
    if type(value) == "function" then
      local ok_call, result = pcall(value)
      if not ok_call then
        vim.notify("blink.cmp auto_show callback failed, defaulting to OFF", vim.log.levels.WARN)
        return false
      end
      return result
    end
    return value
  end

  local current = resolve(menu_cfg.auto_show)
  if type(current) ~= "boolean" then
    current = false
  end
  local new_value = not current

  menu_cfg.auto_show = new_value

  local ok_menu, menu_mod = pcall(require, "blink.cmp.completion.windows.menu")
  if ok_menu and menu_mod.auto_show then
    if menu_mod.reset_auto_show then
      menu_mod.reset_auto_show()
    end
  end

  vim.notify("Completions Auto-Show: " .. (new_value and "ON" or "OFF"), vim.log.levels.INFO)
end

function M.toggle_lsp()
  local has_clients = #vim.lsp.get_clients({ bufnr = 0 }) > 0
  local ok, err
  if has_clients then
    ok, err = pcall(vim.cmd, "LspStop")
  else
    ok, err = pcall(vim.cmd, "LspStart")
  end
  if not ok then
    return vim.notify("LSP toggle failed: " .. tostring(err), vim.log.levels.ERROR)
  end
  vim.notify("LSP: " .. (has_clients and "OFF" or "ON"), vim.log.levels.INFO)
end

function M.toggle_auto_format()
  if not LazyVim or not LazyVim.format or not LazyVim.format.snacks_toggle then
    return vim.notify("LazyVim format toggle not available", vim.log.levels.ERROR)
  end
  LazyVim.format.snacks_toggle():toggle()
end

function M.toggle_diagnostics()
  local snacks = get_snacks()
  if not snacks then
    return
  end
  if not snacks or not snacks.toggle or not snacks.toggle.diagnostics then
    return vim.notify("snacks.toggle.diagnostics not available", vim.log.levels.ERROR)
  end
  snacks.toggle.diagnostics():toggle()
end

function M.toggle_zen()
  local snacks = get_snacks()
  if not snacks then
    return
  end
  if not snacks or not snacks.toggle or not snacks.toggle.zen then
    return vim.notify("snacks.toggle.zen not available", vim.log.levels.ERROR)
  end
  snacks.toggle.zen():toggle()
end

return M

