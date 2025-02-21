---@module 'lazy'
---@type LazySpec
return {
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
}
