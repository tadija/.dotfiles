return {
  {
    "olimorris/codecompanion.nvim",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
    opts = function()
      local cc_defaults = require("codecompanion.config")

      local chat = vim.deepcopy(cc_defaults.interactions.chat)
      chat.adapter = "codex"
      chat.slash_commands = vim.tbl_deep_extend("force", chat.slash_commands or {}, {
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

      local inline = vim.deepcopy(cc_defaults.interactions.inline)
      inline.adapter = "gemini"

      local cmd = vim.deepcopy(cc_defaults.interactions.cmd)
      cmd.adapter = "copilot"

      local interactions = {
        chat = chat,
        cmd = cmd,
        inline = inline,
      }

      return {
        display = {
          chat = {
            intro_message = "press ? for options",
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
        opts = {
          log_level = "DEBUG",
        },
        prompt_library = require("plugins.ai.prompts"),
      }
    end,
  },
}

