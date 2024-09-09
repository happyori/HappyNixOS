---@module 'lazy'
---@type LazySpec
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    cmd = {
      'ToggleTerm',
      'TermExec',
      'ToggleTermToggleAll',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      direction = 'float',
      close_on_exit = true,
      shell = 'nu',
      float_opts = {
        border = 'curved',
        winblend = 30,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      highlights = {
        Normal = { link = 'ToggleTermNormal' },
        NormalFloat = { link = 'ToggleTermNormalFloat' },
        FloatBorder = { link = 'ToggleTermFloatBorder' },
      },
      on_create = function()
        vim.cmd [[ setlocal signcolumn=no ]]
      end,
      winbar = {
        enabled = false,
      },
    },
  },
}
