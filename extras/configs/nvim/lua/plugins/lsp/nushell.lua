---@module 'lazy'
---@type LazySpec
return {
  'LhKipp/nvim-nu',
  build = 'TSInstall nu',
  config = true,
  opts = {
    use_lsp_features = true,
  },
}
