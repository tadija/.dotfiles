return {

  -- code comments
  {
    'numToStr/Comment.nvim',
    version = false,
    opts = {}
  },

  -- extras 
  {
    "eandrju/cellular-automaton.nvim",
    version = false,
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>mel", "<cmd>CellularAutomaton game_of_life<cr>", desc = "Game of Life" },
      { "<leader>mer", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
      { "<leader>mes", "<cmd>CellularAutomaton scramble<cr>", desc = "Scramble Text" },
    },
  },

  -- file explorer
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    init = function()
      require("oil").setup()
    end,
  },

  -- inline diff
  {
    "nvim-mini/mini.diff",
    version = false,
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- disable on startup
        source = diff.gen_source.none(),
      })
    end,
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
    "mg979/vim-visual-multi",
    version = false,
    init = function()
      vim.g.VM_leader = "\\"
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"] = "<C-A-n>",
      }
    end,
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

