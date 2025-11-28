return {
  {
    "olimorris/codecompanion.nvim",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
    },
    opts = {
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
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
      prompt_library = require("config.prompts"),
      strategies = {
        chat = {
          adapter = "codex",
          slash_commands = {
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
          },
        },
        cmd = {
          adapter = "copilot",
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
  },
}
