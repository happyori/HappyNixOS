---@module 'lazy'
---@type LazySpec
return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  config = function(_, opts)
    local diag = require 'tiny-inline-diagnostic'
    diag.setup(opts)
    vim.diagnostic.config { virtual_text = false }
    local bind = require('legendary').keymaps
    ---@type LegendKeys
    local keys = {
      {
        itemgroup = 'Diagnostics',
        keymaps = {
          { '<leader>dt', diag.toggle, description = '[D]ignostics [T]oggle' },
        },
      },
    }
    bind(keys)
  end,
  opts = {
    preset = 'ghost',
    transparent_bg = false,
    options = {
      multilines = {
        enabled = true,
        always_show = false,
      },
      show_all_diags_on_cursorline = true,
      break_line = {
        enabled = true,
        after = 40,
      },
    },
  },
}
