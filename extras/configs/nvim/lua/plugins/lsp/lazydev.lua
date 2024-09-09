return {
  { 'Bilal2453/luvit-meta', lazy = false },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } }
      }
    }
  }
}
