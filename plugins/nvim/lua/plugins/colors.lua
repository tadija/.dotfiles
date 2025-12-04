return {
  -- set default colorscheme 
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- add a few themes
  { "EdenEast/nightfox.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
  { "navarasu/onedark.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "sainnhe/everforest" },
  { "savq/melange-nvim" },

  -- override tokyonight highlights
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        hl.BlinkCmpGhostText = {
          fg = c.orange,
        }
        hl.WinSeparator = {
          fg = c.orange,
        }
      end,
    },
  },

  -- persist colorscheme per project
  {
    "nvim-lua/plenary.nvim",
    lazy = false,

    config = function()
      local util = require("lazyvim.util")
      local root = util.root.get()
      local dir = root .. "/.nvim"
      local file = dir .. "/colorscheme"

      -- load
      if vim.fn.filereadable(file) == 1 then
        local cs = vim.fn.readfile(file)[1]
        if cs and #cs > 0 then
          vim.cmd("colorscheme " .. cs)
        end
      end

      -- save
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local name = vim.g.colors_name
          if name and #name > 0 then
            if vim.fn.isdirectory(dir) == 0 then
              vim.fn.mkdir(dir, "p")
            end
            vim.fn.writefile({ name }, file)
          end
        end,
      })
    end,
  },
}

