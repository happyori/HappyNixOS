---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    cmd = 'Trouble',
    ---@module 'trouble.nvim'
    ---@type trouble.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      auto_close = true,
      auto_open = false,
      focus = false,
      pinned = true,
      ---@type trouble.Window.opts
      win = {
        position = 'right',
        size = 0.4,
      },
    },
    keys = function(_, keys)
      local bind = require('legendary').keymaps

      ---@type LegendKeys
      local legend = {
        {
          itemgroup = 'Diagnostics',
          keymaps = {
            { '<leader>dD', '<cmd>Trouble diagnostics toggle<cr>', description = '|Global [D]iagnostics' },
            {
              '<leader>dd',
              '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
              description = '|Local [D]iagnostics',
            },
            { '<leader>dl', '<cmd>Trouble loclist toggle<cr>', description = '[L]ocation List' },
            { '<leader>dq', '<cmd>Trouble qflist toggle<cr>', description = '[Q]uickfix List' },
          },
        },
      }

      bind(legend)

      return keys
    end,
  },
}
