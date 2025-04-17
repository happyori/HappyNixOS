---@module 'lazy'
---@type LazySpec
return {
  'epwalsh/obsidian.nvim',
  version = '*',
  ft = 'markdown',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'Main',
        path = '~/Vaults/General/',
      },
    },
    mappings = {
      ['<CR>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
  },
}
