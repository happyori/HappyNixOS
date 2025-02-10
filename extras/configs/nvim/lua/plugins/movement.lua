---@module 'lazy'
---@type LazySpec
return {
  {
    'chrisgrieser/nvim-spider',
    keys = function(_, _)
      local legend = require 'legendary'
      local toolbox = require 'legendary.toolbox'
      local motion = function(arg)
        return toolbox.lazy_required_fn('spider', 'motion', arg)
      end

      ---@type LegendKeys
      local keys = {
        {
          itemgroup = 'Spider Motion',
          description = 'Motion keys powered by nvim-spider',
          keymaps = {
            { 'w', motion 'w', description = 'Spider move to next [w]ord', mode = { 'n', 'o', 'x' } },
            { 'e', motion 'e', description = 'Spider move to [e]nd', mode = { 'n', 'o', 'x' } },
            { 'b', motion 'b', description = 'Spider move [b]ack', mode = { 'n', 'o', 'x' } },
          },
        },
      }

      legend.keymaps(keys)

      return {}
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = function()
      ---@module 'flash',
      ---@type Flash.Config
      local opts = {}

      vim.api.nvim_set_hl(0, 'FlashLabel', { link = 'Cursor' })

      return opts
    end,
    keys = function()
      local legend = require 'legendary'
      local toolbox = require 'legendary.toolbox'
      local flash = function(fn)
        return toolbox.lazy_required_fn('flash', fn)
      end

      ---@type LegendKeys
      local keys = {
        {
          itemgroup = 'Flash Motion',
          description = 'Empowered w, e, b motions',
          keymaps = {
            { 's', flash 'jump', description = '[S]earch', mode = { 'n', 'x', 'o' } },
            {
              'S',
              flash 'treesitter',
              description = 'Treesitter [S]earch',
              mode = { 'n', 'x', 'o' },
            },
            { '<C-f>', flash 'toggle', description = 'Toggle Flash Search', mode = { 'c' } },
          },
        },
      }

      legend.keymaps(keys)
      return {}
    end,
  },
}
