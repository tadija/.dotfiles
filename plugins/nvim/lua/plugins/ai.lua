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
      prompt_library = {
        ["Vibe Code"] = {
          strategy = "inline",
          description = "Rewrite code with clean modern vibes",
          opts = {
            short_name = "vibe",
            is_slash_cmd = true,
            auto_submit = true,
            modes = { "n", "v" },
          },
          prompts = {
            {
              role = "user",
              content = [[
If no code is selected (or the trimmed selection is empty), generate a short snippet in the context of the current buffer. 
Otherwise, rewrite or refactor the selected code (with focus on the selected code only) in a clean, elegant, modern style. 
Improve naming, structure, readability, and flow - all while preserving the original intended behaviour. Output code only.
              ]],
            },
          },
        },
      },
    },
  },
}
