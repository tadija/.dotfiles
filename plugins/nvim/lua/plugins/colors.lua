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
}
