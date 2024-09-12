---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    config = true,
    keys = function(_, keys)
      local bind = require('legendary').keymaps
      local toolbox = require 'legendary.toolbox'

      ---@type LegendKeys
      local legend = {
        {
          itemgroup = '[T]rouble',
          description = 'Trouble (Quickfix alt) keybinds',
          keymaps = {
            { '<leader>td', '<cmd>Trouble diagnostics toggle<cr>', description = 'Global [D]iagnostics' },
            { '<leader>tD', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', description = 'Local [D]iagnostics' },
            { '<leader>tl', '<cmd>Trouble loclist toggle<cr>', description = '[L]ocation List' },
            { '<leader>tq', '<cmd>Trouble qflist toggle<cr>', description = '[Q]uickfix List' },
          },
        },
      }

      bind(legend)

      return keys
    end,
  },
}
