---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    keys = function()
      local bind = require('legendary').keymaps
      ---@type LegendKeys
      local keys = {
        {
          itemgroup = 'Neorg',
          keymaps = {
            { '<leader>nc', '<cmd>Neorg workspace core<cr>', description = '|Open [C]ore Workspace' },
            { '<leader>nj', '<cmd>Neorg journal<cr>', description = '|Create [J]ournal Entry' },
            { '<leader>ni', '<cmd>Neorg index<cr>', description = '|Open [I]ndex Entry' },
          },
        },
      }
      bind(keys)

      return {}
    end,
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.completion'] = {
          config = {
            engine = {
              module_name = 'external.lsp-completion',
            },
          },
        },
        ['core.concealer'] = {
          config = {
            icon_preset = 'diamond',
          },
        },
        ['core.summary'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              core = '~/Neorg/Core',
            },
            index = 'index.norg',
          },
        },
        ['external.interim-ls'] = {
          config = {
            completion_provider = {
              enable = true,
              documentation = true,
            },
          },
        },
      },
    },
  },
  {
    'benlubas/neorg-interim-ls',
  },
}
