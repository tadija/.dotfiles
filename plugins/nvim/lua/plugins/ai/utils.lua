local M = {}

local intro_prefix = "press ? for options"

local function get_cc()
  return require("codecompanion")
end

local function get_config()
  return require("codecompanion.config")
end

local function adapter_label(name)
  local cc_config = get_config()
  local adapter = (cc_config.adapters.http or {})[name] or (cc_config.adapters.acp or {})[name]
  if type(adapter) == "table" then
    return adapter.formatted_name or adapter.name or name
  end
  return name
end

function M.chat_intro(adapter_name)
  return string.format("%s [%s]", intro_prefix, adapter_label(adapter_name))
end

function M.toggle_chat(adapter, opts)
  opts = opts or {}
  local parts = { "CodeCompanionChat" }
  if adapter then
    parts[#parts + 1] = "adapter=" .. adapter
  end

  if opts.force_new then
    get_cc().close_last_chat()
    return vim.cmd(table.concat(parts, " "))
  end

  parts[#parts + 1] = "Toggle"
  vim.cmd(table.concat(parts, " "))
end

function M.choose_adapter(opts)
  opts = opts or {}
  local cc_config = get_config()
  local adapters = {}
  local function collect(tbl, type_name)
    for key, adapter in pairs(tbl or {}) do
      if key ~= "opts" then
        adapters[#adapters + 1] = {
          key = key,
          name = adapter.formatted_name or adapter.name or key,
          type = type_name,
        }
      end
    end
  end

  collect(cc_config.adapters.http, "http")
  collect(cc_config.adapters.acp, "acp")

  if opts.filter then
    adapters = vim.tbl_filter(opts.filter, adapters)
  end

  if vim.tbl_isempty(adapters) then
    return vim.notify("No CodeCompanion adapters configured", vim.log.levels.WARN)
  end

  table.sort(adapters, function(a, b)
    return a.name < b.name
  end)

  vim.ui.select(
    adapters,
    {
      prompt = "Use CodeCompanion adapter",
      format_item = function(item)
        return string.format("%s (%s)", item.name, item.key)
      end,
    },
    function(choice)
      if not choice then
        return
      end
      if opts.on_choice then
        opts.on_choice(choice)
      end
      if opts.open_chat then
        M.toggle_chat(choice.key, { force_new = true })
      end
    end
  )
end

-- select multiple adapters in sequence; calls opts.on_submit(list)
function M.select_adapters_many(opts)
  opts = opts or {}
  local cc_config = get_config()
  local adapters = {}
  local function collect(tbl, type_name)
    for key, adapter in pairs(tbl or {}) do
      if key ~= "opts" then
        adapters[#adapters + 1] = {
          key = key,
          name = adapter.formatted_name or adapter.name or key,
          type = type_name,
        }
      end
    end
  end

  collect(cc_config.adapters.http, "http")
  collect(cc_config.adapters.acp, "acp")

  if opts.filter then
    adapters = vim.tbl_filter(opts.filter, adapters)
  end

  if vim.tbl_isempty(adapters) then
    return vim.notify("No CodeCompanion adapters configured", vim.log.levels.WARN)
  end

  local selected = {}
  local selected_set = {}

  local function pick()
    local remaining = vim.tbl_filter(function(item)
      return not selected_set[item.key]
    end, adapters)

    if vim.tbl_isempty(remaining) then
      if opts.on_submit then
        opts.on_submit(selected)
      end
      return
    end

    vim.ui.select(
      remaining,
      {
        prompt = "Add adapter (ESC to finish)",
        format_item = function(item)
          return string.format("%s (%s)", item.name, item.key)
        end,
      },
      function(choice)
      if not choice then
        if opts.on_submit then
          opts.on_submit(selected, opts.range)
        end
        return
      end
      selected[#selected + 1] = choice.key
      selected_set[choice.key] = true
        pick()
      end
    )
  end

  pick()
end

function M.send_chat_to_many()
  M.select_adapters_many({
    on_submit = function(list)
      if vim.tbl_isempty(list) then
        return
      end
      vim.ui.input({ prompt = "Send to adapters (chat prompt): " }, function(input)
        local prompt = vim.trim(input or "")
        if prompt == "" then
          return
        end
        for _, adapter in ipairs(list) do
          vim.cmd({ cmd = "CodeCompanionChat", args = { "adapter=" .. adapter, prompt } })
        end
      end)
    end,
  })
end

function M.send_selection_to_many()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local range = { math.min(start_line, end_line), math.max(start_line, end_line) }

  M.select_adapters_many({
    filter = function(adapter)
      return adapter.type == "http"
    end,
    range = range,
    on_submit = function(list)
      if vim.tbl_isempty(list) then
        return
      end
      vim.ui.input({ prompt = "Send selection (inline prompt): " }, function(input)
        local prompt = vim.trim(input or "")
        if prompt == "" then
          return
        end
        local buf_lines = vim.api.nvim_buf_line_count(0)
        local start = math.max(1, math.min(range[1], buf_lines))
        local finish = math.max(start, math.min(range[2], buf_lines))
        for _, adapter in ipairs(list) do
          vim.cmd({
            cmd = "CodeCompanion",
            range = { start, finish },
            args = { "adapter=" .. adapter, prompt },
          })
        end
      end)
    end,
  })
end

function M.adapter_desc(mode, label)
  local cc_config = get_config()
  local adapter = ((cc_config.interactions or {})[mode] or {}).adapter or "default"
  return string.format("%s [%s]", label or mode, adapter)
end

function M.set_mode_adapter(mode, opts)
  opts = opts or {}
  local cc_config = get_config()
  local interactions = cc_config.interactions or {}
  if not interactions[mode] then
    return vim.notify("Unknown CodeCompanion interaction: " .. mode, vim.log.levels.WARN)
  end
  M.choose_adapter({
    filter = opts.filter,
    on_choice = function(choice)
      interactions[mode].adapter = choice.key
      if mode == "chat" and cc_config.display and cc_config.display.chat then
        cc_config.display.chat.intro_message = M.chat_intro(choice.key)
      end
      vim.notify(
        string.format("CodeCompanion %s adapter -> %s", mode, choice.key),
        vim.log.levels.INFO
      )
      if opts.after_set then
        opts.after_set(mode, choice)
      end
    end,
  })
end

function M.setup_request_logging()
  local group = vim.api.nvim_create_augroup("CodeCompanionLogRequests", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "CodeCompanionRequestStarted",
    callback = function(event)
      local adapter = (event.data or {}).adapter or {}
      local name = adapter.formatted_name or adapter.name or "unknown"
      local model = adapter.model or "n/a"
      local message = string.format("CodeCompanion -> %s (%s)", name, model)
      vim.notify(message, vim.log.levels.INFO, { title = "My" })
    end,
  })
end

-- keymap helpers
function M.refresh_adapter_labels()
  local wk = require("which-key")
  wk.add({
    { "<leader>ac", desc = M.adapter_desc("chat", "Chat"), mode = { "n", "v" } },
    { "<leader>ai", desc = M.adapter_desc("inline", "Inline"), mode = { "n", "v" } },
    { "<leader>am", desc = M.adapter_desc("cmd", "Cmd"), mode = { "n", "v" } },
  })
end

function M.chat_select_and_toggle()
  M.set_mode_adapter("chat", {
    after_set = function(_, choice)
      M.refresh_adapter_labels()
      M.toggle_chat(choice.key, { force_new = true })
    end,
  })
end

function M.cmd_prompt()
  vim.ui.input({ prompt = "Cmd prompt: " }, function(input)
    if input and #vim.trim(input) > 0 then
      vim.cmd({ cmd = "CodeCompanionCmd", args = { input } })
    end
  end)
end

function M.prompt_select_and_run()
  M.set_mode_adapter("inline", {
    filter = function(adapter)
      return adapter.type == "http"
    end,
    after_set = function()
      M.refresh_adapter_labels()
      vim.cmd("CodeCompanion")
    end,
  })
end

function M.cmd_select_and_run()
  M.set_mode_adapter("cmd", {
    filter = function(adapter)
      return adapter.type == "http"
    end,
    after_set = function()
      M.refresh_adapter_labels()
      M.cmd_prompt()
    end,
  })
end

function M.extend_slash_commands(chat)
  return vim.tbl_deep_extend("force", chat.slash_commands or {}, {
    ["buffer"] = {
      keymaps = {
        modes = {
          i = "<C-b>",
          n = { "<C-b>", "gb" },
        },
      },
    },
    ["file"] = {
      keymaps = {
        modes = {
          i = "<C-f>",
          n = { "<C-f>", "gf" },
        },
      },
    },
    ["image"] = {
      keymaps = {
        modes = {
          i = "<C-i>",
          n = { "<C-i>", "gi" },
        },
      },
    },
  })
end

return M

