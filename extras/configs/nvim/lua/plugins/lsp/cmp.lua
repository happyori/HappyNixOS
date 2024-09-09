---@module 'lazy'
---@type LazySpec
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = function(_, opts)
          local ls = require 'luasnip'

          opts = {
            snip_env = {
              s = function(...)
                local snip = ls.s(...)

                table.insert(getfenv(2).ls_file_snippets, snip)
              end,
              parse = function(...)
                local snip = ls.parser.parse_snippet(...)

                table.insert(getfenv(2).ls_file_snippets, snip)
              end,
            },
          }

          require('luasnip.loaders.from_lua').load { paths = { './snippets' } }

          return opts
        end,
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-path',
    },
    opts = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      local icons = require 'utils.icons'
      luasnip.config.setup {}

      ---@type cmp.ConfigSchema
      local opts = {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = false },
          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip', priority = -1 },
          { name = 'path' },
          { name = 'buffer', group_index = 100 },
        },
        window = {
          completion = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None',
            side_padding = 0,
            col_offset = -4,
          },
          documentation = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None',
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local fmt = lspkind.cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              ellipsis_char = icons.ui.Ellipsis,
            }(entry, vim_item)

            local strings = vim.split(fmt.kind, '%s', { trimempty = true })

            fmt.kind = ' ' .. (icons.kind[strings[2]] or '')
            fmt.kind = fmt.kind .. ' '
            fmt.menu = strings[2] ~= nil and (' ' .. (strings[2] or '')) or ''

            return fmt
          end,
          expandable_indicator = false,
        },
      }

      return opts
    end,
  },
}
