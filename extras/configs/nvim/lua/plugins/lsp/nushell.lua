---@module 'lazy'
---@type LazySpec
return {
  'LhKipp/nvim-nu',
  ft = 'nu',
  build = function(_)
    vim.cmd [[ TSInstall nu ]]
  end,
  config = true,
  opts = {
    use_lsp_features = true,
  },
}