return {
  -- code comments
  {
    'numToStr/Comment.nvim',
    version = false,
    opts = {}
  },

  -- code diagnostics
  {
    "neovim/nvim-lspconfig",
    version = false,
    opts = function(_, opts)
      -- run default setup first
      vim.diagnostic.config(opts.diagnostics)

      -- disable all diagnostics globally at startup
      -- manually enable with built-in keymap: <leader>ud
      vim.schedule(function()
        vim.diagnostic.enable(false)
      end)
    end,
  },

  -- inline diff
  {
    "nvim-mini/mini.diff",
    version = false,
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },

  -- move lines or words
  {
    "nvim-mini/mini.move",
    version = false,
    opts = {
      mappings = {
        left  = "<A-h>",
        right = "<A-l>",
        down  = "<A-j>",
        up    = "<A-k>",
      },
    },
  },

  -- multi-line formatting
  {
    'wansmer/treesj',
    version = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { "gS", function() require("treesj").split() end, desc = "Split lines" },
      { "gJ", function() require("treesj").join() end, desc = "Join lines" },
      { "gM", function() require("treesj").toggle() end, desc = "Toggle lines" },
    },
  },

  -- multi-cursors
  {
    {
      "mg979/vim-visual-multi",
      version = false,
      init = function()
        vim.g.VM_leader = "\\"
        vim.g.VM_theme = "codedark"
        vim.g.VM_maps = {
          ["Find Under"] = "<C-n>",
          ["Find Subword Under"] = "<C-n>",
          ["Select All"] = "<C-A-n>",
        }
      end,
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    version = false,
    opts = {
      icons = {
        group = " + ",
      },
    },
  },
}
