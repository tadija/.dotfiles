return {
  -- set default colorscheme 
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
    init = function()
      local function set_random_colorscheme()
        local ok, themes = pcall(vim.fn.getcompletion, "", "color")
        if not ok or vim.tbl_isempty(themes) then
          return vim.notify("No colorschemes found", vim.log.levels.WARN)
        end
        math.randomseed(os.time())
        local choice = themes[math.random(#themes)]
        vim.cmd.colorscheme(choice)
        vim.notify("Colorscheme -> " .. choice)
      end

      vim.api.nvim_create_user_command("SetRandomColorScheme", set_random_colorscheme, {
        desc = "Set random colorscheme",
      })
    end,
  },

  -- add a few themes
  { "AlexvZyl/nordic.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "bluz71/vim-moonfly-colors" },
  { "chriskempson/vim-tomorrow-theme", },
  { "deparr/tairiki.nvim" },
  { "dracula/vim", name = "dracula" },
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
  { "luisiacc/gruvbox-baby" },
  { "mhartington/oceanic-next" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "pineapplegiant/spaceduck" },
  { "projekt0n/github-nvim-theme" },
  { "rebelot/kanagawa.nvim" },
  { "ribru17/bamboo.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "sainnhe/everforest" },
  { "sainnhe/sonokai" },
  { "savq/melange-nvim" },
  { "scottmckendry/cyberdream.nvim" },
  { "srcery-colors/srcery-vim" },

  -- persist colorscheme per project
  {
    "nvim-lua/plenary.nvim",
    lazy = false,

    config = function()
      local function set_theme_overrides()
        local orange = "#ff8800"
        vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = orange })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = orange })
      end

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
          set_theme_overrides()
          local name = vim.g.colors_name
          if name and #name > 0 then
            if vim.fn.isdirectory(dir) == 0 then
              vim.fn.mkdir(dir, "p")
            end
            vim.fn.writefile({ name }, file)
          end
        end,
      })

      set_theme_overrides()
    end,
  },
}

