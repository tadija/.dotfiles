vim.api.nvim_set_hl(0, 'CmpItemIndex', { fg = '#ff8800', bg = '#222222', bold = true })

local cmp = require('blink.cmp')

return {
  'saghen/blink.cmp',
  version = false,
  dependencies = { 'rafamadriz/friendly-snippets' },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      ghost_text = {
        enabled = true,
        show_with_menu = false,
      },
      menu = {
        auto_show = false,
        border = 'single',
        draw = {
          columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          components = {
            item_idx = {
              text = function(ctx) return tostring(ctx.idx) end,
              highlight = 'CmpItemIndex'
            },
          },
        },
      },
      list = {
        selection = { 
          preselect = false, 
          auto_insert = false, 
        },
      },
    },
    fuzzy = {
      implementation = 'lua',
    },
    keymap = {
      preset = 'super-tab',
      ['1'] = { function() cmp.accept({ index = 1 }) end, 'fallback' },
      ['2'] = { function() cmp.accept({ index = 2 }) end, 'fallback' },
      ['3'] = { function() cmp.accept({ index = 3 }) end, 'fallback' },
      ['4'] = { function() cmp.accept({ index = 4 }) end, 'fallback' },
      ['5'] = { function() cmp.accept({ index = 5 }) end, 'fallback' },
      ['6'] = { function() cmp.accept({ index = 6 }) end, 'fallback' },
      ['7'] = { function() cmp.accept({ index = 7 }) end, 'fallback' },
      ['8'] = { function() cmp.accept({ index = 8 }) end, 'fallback' },
      ['9'] = { function() cmp.accept({ index = 9 }) end, 'fallback' },
    },
    sources = {
      default = { 'lsp', 'snippets', 'lazydev', 'codecompanion', 'dadbod', 'path', 'buffer' },
      providers = {
        codecompanion = {
          name = 'CodeCompanion',
          module = 'codecompanion.providers.completion.blink',
          enabled = true,
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          enabled = true,
        },
      }
    },
  },
}

