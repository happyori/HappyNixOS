---@module 'lazy'
---@type LazySpec
return {
  'nvimtools/none-ls.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  opts = function()
    local null_ls = require 'null-ls'
    return {
      sources = {
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
      }
    }
  end,
}
