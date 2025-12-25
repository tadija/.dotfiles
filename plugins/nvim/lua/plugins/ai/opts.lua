local function codecompanion_opts()
  local cc_defaults = require("codecompanion.config")
  local ai_utils = require("plugins.ai.utils")

  local codex = vim.deepcopy(require("codecompanion.adapters.acp.codex"))
  codex.defaults.auth_method = "chatgpt"

  local chat = vim.deepcopy(cc_defaults.interactions.chat)
  chat.adapter = "codex"
  chat.opts = vim.tbl_deep_extend("force", chat.opts or {}, {
    completion_provider = "blink",
  })
  chat.slash_commands = ai_utils.extend_slash_commands(chat)

  local inline = vim.deepcopy(cc_defaults.interactions.inline)
  inline.adapter = "openai"

  local cmd = vim.deepcopy(cc_defaults.interactions.cmd)
  cmd.adapter = "gemini"

  local interactions = {
    chat = chat,
    cmd = cmd,
    inline = inline,
  }

  return {
    adapters = {
      acp = {
        codex = codex,
      },
    },
    display = {
      chat = {
        intro_message = ai_utils.chat_intro(chat.adapter),
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    interactions = interactions,
    memory = {
      opts = {
        chat = {
          enabled = true,
          condition = true,
        },
      },
    },
    opts = { log_level = "DEBUG" },
    prompt_library = require("plugins.ai.prompts"),
  }
end

return codecompanion_opts

