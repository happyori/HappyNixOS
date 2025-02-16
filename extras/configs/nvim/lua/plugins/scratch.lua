---@module 'lazy'
---@type LazySpec
return {
  'slugbyte/whip.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  event = 'VeryLazy',
  config = function(_, opts)
    local whip = require 'whip'
    local legend = require 'legendary'
    local which = require 'which-key'
    which.add {
      '<leader>p',
      desc = 'Whip Scratch[P]ad',
    }
    whip.setup(opts)

    ---@type LegendKeys
    local keys = {
      {
        itemgroup = '[W]hip scratch pad',
        description = 'Scratch pad management',
        keymaps = {
          { '<leader>po', whip.open, description = '[O]pen last scratch pad' },
          { '<leader>pc', whip.make, description = '[C]reate scratch pad' },
          { '<leader>pd', whip.drop, description = '[D]rop scratch pad' },
          { '<leader>pf', whip.find_file, description = '[F]ind scratch pad' },
          { '<leader>pg', whip.find_grep, description = '[G]rep all scratch pads' },
        },
      },
    }

    legend.keymaps(keys)
  end,
  opts = {
    dir = '/home/happy/Documents/ScratchPads',
  },
}
