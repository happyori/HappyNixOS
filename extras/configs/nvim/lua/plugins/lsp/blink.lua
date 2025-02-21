local icons = require 'utils.icons'
---@module 'lazy'
---@type LazySpec
return {
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'xzbdmw/colorful-menu.nvim', 'saecki/crates.nvim' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = function()
          if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()):match 'Cargo.toml' then
            return { 'crates', 'lsp', 'path', 'snippets', 'buffer' }
          end
          return { 'lsp', 'path', 'snippets', 'buffer' }
        end,
        providers = {
          crates = {
            name = 'crates',
            module = 'blink.compat.source',
          },
        },
      },
      completion = {
        menu = {
          border = 'rounded',
          winblend = 20,
          scrolloff = 3,
          auto_show = function(ctx)
            return ctx.mode ~= 'cmdline' and not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,
          draw = {
            gap = 2,
            columns = {
              { 'kind_icon' },
              { 'label', gap = 1 },
              { 'kind' },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  if icons.kind[ctx.kind] then
                    return icons.kind[ctx.kind]
                  else
                    return ctx.kind_icon .. ctx.icon_gap
                  end
                end,
              },
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        accept = {
          auto_brackets = { enabled = true },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        documentation = {
          auto_show = false,
          window = {
            winblend = 30,
          },
        },
        ghost_text = {
          enabled = true,
          show_with_selection = true,
        },
      },
      snippets = { preset = 'luasnip' },
      signature = {
        enabled = false,
        window = { show_documentation = false },
      },
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-l>'] = { 'snippet_forward', 'select_and_accept', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
        ['<C-d>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
      },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'saghen/blink.compat',
    version = '*',
    opts = {},
  },
}
