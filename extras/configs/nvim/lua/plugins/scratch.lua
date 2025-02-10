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
      '<leader>w',
      desc = '[W]hip',
    }
    whip.setup(opts)

    ---@type LegendKeys
    local keys = {
      {
        itemgroup = '[W]hip scratch pad',
        description = 'Scratch pad management',
        keymaps = {
          { '<leader>wo', whip.open, description = '[O]pen last scratch pad' },
          { '<leader>wc', whip.make, description = '[C]reate scratch pad' },
          { '<leader>wd', whip.drop, description = '[D]rop scratch pad' },
          { '<leader>wf', whip.find_file, description = '[F]ind scratch pad' },
          { '<leader>wg', whip.find_grep, description = '[G]rep all scratch pads' },
        },
      },
    }

    legend.keymaps(keys)
  end,
  opts = {
    dir = '/home/happy/Documents/ScratchPads',
  },
}
