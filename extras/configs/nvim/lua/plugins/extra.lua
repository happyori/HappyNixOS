---@type LazySpec
return {
  {
    'rasulomaroff/cursor.nvim',
    event = 'VeryLazy',
    opts = {
      cursors = {
        {
          mode = 'a',
          shape = 'block',
          blink = 400,
        },
        {
          mode = 'i',
          shape = 'ver',
          blink = 400,
          size = 25,
        },
        {
          mode = 'v',
          shape = 'hor',
          blink = 400,
          size = 10,
        },
      },
    },
  },
  'Tastyep/structlog.nvim',
  {
    'shortcuts/no-neck-pain.nvim',
    cmd = 'NoNeckPain',
  },
  { 'NvChad/nvim-colorizer.lua', lazy = false },
  { 'RRethy/vim-illuminate', event = 'BufEnter' },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      scope = {
        enabled = true,
      },
      indent = {
        tab_char = '>',
        char = '⎸',
        smart_indent_cap = true,
      },
    },
  },
}
