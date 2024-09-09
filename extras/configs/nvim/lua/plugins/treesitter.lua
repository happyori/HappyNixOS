return {
  { 'tpope/vim-sleuth', lazy = false },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          node_decremental = '<C-S-Space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
      endwise = {
        enable = true,
      },
    },
  },
  {
    'windwp/nvim-ts-autotag',
    lazy = false,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = false,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
  },
  {
    'RRethy/nvim-treesitter-endwise',
    lazy = false,
  },
}
