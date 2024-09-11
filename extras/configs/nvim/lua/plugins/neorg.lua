---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.completion'] = {},
        ['core.concealer'] = {},
        ['core.summary'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              core = '~/Neorg/Core',
            },
            index = 'index.norg',
          },
        },
      },
    },
  },
  {
    'mrjones2014/legendary.nvim',
    opts = {
      autocmds = {
        {
          name = 'Neorg Attach Source',
          clear = true,
          {
            'BufRead',
            function()
              local cmp = require 'cmp'
              cmp.setup.buffer {
                sources = {
                  { name = '[Neorg]' },
                  { name = 'buffer', group_index = 1 },
                },
              }
            end,
            opts = {
              pattern = { '%.norg$' },
            },
          },
        },
      },
    },
  },
}
