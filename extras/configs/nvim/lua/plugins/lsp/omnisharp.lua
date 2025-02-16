---@module 'lazy'
---@type LazySpec
return {
  'Hoffs/omnisharp-extended-lsp.nvim',
  event = 'VeryLazy',
  config = function(_, _)
    local legendary = require 'legendary'
    local toolbox = require 'legendary.toolbox'
    local function extended(fn)
      return toolbox.lazy_required_fn('omnisharp_extended', fn)
    end

    ---@type LegendKeys
    local keys = {
      {
        'gd',
        extended 'lsp_definition',
        description = 'Omnisharp Specific Lsp Definition',
        opts = { noremap = true },
      },
      {
        '<leader>lD',
        extended 'lsp_type_definition',
        description = 'Omnisharp Specific Lsp Type Definition',
        opts = { noremap = true },
      },
      {
        'gr',
        extended 'lsp_references',
        opts = { noremap = true },
      },
      {
        'gi',
        extended 'lsp_implementation',
        opts = { noremap = true },
      },
    }

    local autocmd = {
      name = 'happy_omnisharp_extended',
      clear = true,
      {
        'BufRead',
        function(event)
          keys = vim.tbl_map(function(tbl)
            return vim.tbl_deep_extend('keep', tbl, { opts = { buffer = event.buf } })
          end, keys)
          legendary.keymaps(keys)
        end,
        description = 'Attaches and remaps lsp keys to Omnisharp',
        opts = {
          pattern = { '*.cs' },
        },
      },
    }

    legendary.autocmd(autocmd)
  end,
}
