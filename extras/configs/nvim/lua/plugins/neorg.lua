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
}
